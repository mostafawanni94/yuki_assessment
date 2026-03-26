import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapi_planets/core/base_bloc/base_state.dart';
import 'package:swapi_planets/core/errors/base_exception.dart';
import 'package:swapi_planets/core/errors/cancel_exception.dart';
import 'package:swapi_planets/core/errors/unknown_exception.dart';
import 'package:swapi_planets/core/result/result.dart';

/// Generic base for all feature BLoCs / Cubits.
///
/// Single Responsibility: handles safe emit + unified action execution.
/// DRY: error mapping and retry wiring done once here.
abstract class BaseBloc<T> extends Cubit<BaseState<T>> {
  BaseBloc([T? data])
      : super(data != null ? BaseState.success(data) : const BaseState.init());

  /// Emits only when cubit is still open.
  @protected
  Future<void> safeEmit(BaseState<T> state) async {
    if (!isClosed) emit(state);
  }

  /// Runs [action], maps result to state, wires up retry.
  @protected
  Future<void> performAction(
    Future<MyResult<T>> Function() action, {
    void Function(T)? onSuccess,
    void Function(BaseException)? onError,
  }) async {
    try {
      if (isClosed) return;
      await safeEmit(const BaseState.loading());

      final result = await action();
      switch (result) {
        case IsSuccess<T>():
          onSuccess?.call(result.model as T);
          await safeEmit(BaseState.success(result.model));
        case IsError<T>():
          if (_isCancellation(result.error)) {
            await safeEmit(const BaseState.init());
          } else {
            onError?.call(result.error);
            await safeEmit(
              BaseState.failure(
                result.error,
                () => performAction(action,
                    onSuccess: onSuccess, onError: onError),
              ),
            );
          }
      }
    } catch (_) {
      await safeEmit(
        BaseState.failure(
          const UnknownException(),
          () => performAction(action,
              onSuccess: onSuccess, onError: onError),
        ),
      );
    }
  }

  /// Returns true when the error represents a user-initiated cancellation.
  bool _isCancellation(dynamic error) {
    if (error is DioException && error.type == DioExceptionType.cancel) {
      return true;
    }
    if (error is CancelException) return true;
    return error.toString().toLowerCase().contains('cancelled');
  }
}
