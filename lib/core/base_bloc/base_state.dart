import 'package:flutter/material.dart';
import 'package:swapi_planets/core/errors/base_exception.dart';

/// Sealed state shared by all BLoCs / Cubits.
/// Plain Dart sealed class — no code generation needed.
sealed class BaseState<T> {
  const BaseState();
}

final class Init<T> extends BaseState<T> {
  const Init();
}

final class Loading<T> extends BaseState<T> {
  const Loading();
}

final class Success<T> extends BaseState<T> {
  const Success([this.model]);
  final T? model;
}

final class Failure<T> extends BaseState<T> {
  const Failure(this.error, this.retry);
  final BaseException error;
  final VoidCallback retry;
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

  /// Exhaustive pattern match — compiler enforces all cases.
  R when<R>({
    required R Function() init,
    required R Function() loading,
    required R Function(T? model) success,
    required R Function(BaseException error, VoidCallback retry) failure,
  }) =>
      switch (this) {
        Init<T>()                                   => init(),
        Loading<T>()                                => loading(),
        Success<T>(model: final m)                  => success(m),
        Failure<T>(error: final e, retry: final r)  => failure(e, r),
      };

  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? init,
    R Function()? loading,
    R Function(T? model)? success,
    R Function(BaseException error, VoidCallback retry)? failure,
  }) =>
      switch (this) {
        Init<T>()                                   => init?.call()    ?? orElse(),
        Loading<T>()                                => loading?.call() ?? orElse(),
        Success<T>(model: final m)                  => success?.call(m) ?? orElse(),
        Failure<T>(error: final e, retry: final r)  =>
          failure?.call(e, r) ?? orElse(),
      };
}
