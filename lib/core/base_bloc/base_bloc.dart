import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapi_planets/core/base_bloc/base_state.dart';
import 'package:swapi_planets/core/errors/base_exception.dart';
import 'package:swapi_planets/core/errors/cancel_exception.dart';
import 'package:swapi_planets/core/errors/unknown_exception.dart';
import 'package:swapi_planets/core/result/result.dart';

/// Generic base for all feature BLoCs / Cubits.
/// Single Responsibility: safe emit + unified action execution + cancel token.
abstract class BaseBloc<T> extends Cubit<BaseState<T>> {
  BaseBloc([T? data])
      : super(data != null ? Success(data) : const Init());

  CancelToken _cancelToken = CancelToken();
  CancelToken get cancelToken => _cancelToken;

  @protected
  Future<void> safeEmit(BaseState<T> state) async {
    if (!isClosed) emit(state);
  }

  @protected
  Future<void> performAction(
    Future<MyResult<T>> Function() action, {
    void Function(T)? onSuccess,
    void Function(BaseException)? onError,
  }) async {
    try {
      if (isClosed) return;
      _cancelToken = CancelToken();
      await safeEmit(const Loading());

      final result = await action();
      if (isClosed) return;

      if (result is IsSuccess<T>) {
        onSuccess?.call(result.model as T);
        await safeEmit(Success(result.model));
      } else if (result is IsError<T>) {
        if (_isCancellation(result.error)) {
          await safeEmit(const Init());
        } else {
          onError?.call(result.error);
          await safeEmit(Failure(
            result.error,
            () => performAction(action, onSuccess: onSuccess, onError: onError),
          ));
        }
      }
    } catch (_) {
      await safeEmit(Failure(
        const UnknownException(),
        () => performAction(action, onSuccess: onSuccess, onError: onError),
      ));
    }
  }

  bool _isCancellation(dynamic error) {
    if (error is DioException && error.type == DioExceptionType.cancel) {
      return true;
    }
    return error is CancelException;
  }

  @override
  Future<void> close() {
    _cancelToken.cancel();
    return super.close();
  }
}
