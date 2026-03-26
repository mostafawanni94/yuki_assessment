import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';
import 'package:swapi_planets/core/errors/base_exception.dart';

part 'base_state.freezed.dart';

/// Sealed state shared by all BLoCs / Cubits.
/// Freezed generates: when(), whenOrNull(), maybeWhen() on each variant.
@Freezed(genericArgumentFactories: true)
sealed class BaseState<T> with _$BaseState<T> {
  const factory BaseState.init() = Init<T>;
  const factory BaseState.loading() = Loading<T>;
  const factory BaseState.success([T? model]) = Success<T>;
  const factory BaseState.failure(
    BaseException error,
    VoidCallback retry,
  ) = Failure<T>;
}

/// Convenience getters — avoids casting at call site.
extension BaseStateX<T> on BaseState<T> {
  bool get isInit    => this is Init<T>;
  bool get isLoading => this is Loading<T>;
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get model => switch (this) {
        Success<T>(model: final m) => m,
        _ => null,
      };

  BaseException? get error => switch (this) {
        Failure<T>(error: final e) => e,
        _ => null,
      };
}
