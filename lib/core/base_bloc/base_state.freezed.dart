// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'base_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. '
    'This is only to be used by code generation.');

/// @nodoc
mixin _$BaseState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(T? model) success,
    required TResult Function(BaseException error, VoidCallback retry) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function(T? model)? success,
    TResult? Function(BaseException error, VoidCallback retry)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(T? model)? success,
    TResult Function(BaseException error, VoidCallback retry)? failure,
    required TResult Function() orElse,
  }) =>
      throw _privateConstructorUsedError;
}

/// Init

class _$InitImpl<T> implements Init<T> {
  const _$InitImpl();

  @override
  String toString() => 'BaseState<$T>.init()';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(T? model) success,
    required TResult Function(BaseException error, VoidCallback retry) failure,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function(T? model)? success,
    TResult? Function(BaseException error, VoidCallback retry)? failure,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(T? model)? success,
    TResult Function(BaseException error, VoidCallback retry)? failure,
    required TResult Function() orElse,
  }) {
    if (init != null) return init();
    return orElse();
  }
}

abstract class Init<T> implements BaseState<T> {
  const factory Init() = _$InitImpl<T>;
}

/// Loading

class _$LoadingImpl<T> implements Loading<T> {
  const _$LoadingImpl();

  @override
  String toString() => 'BaseState<$T>.loading()';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(T? model) success,
    required TResult Function(BaseException error, VoidCallback retry) failure,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function(T? model)? success,
    TResult? Function(BaseException error, VoidCallback retry)? failure,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(T? model)? success,
    TResult Function(BaseException error, VoidCallback retry)? failure,
    required TResult Function() orElse,
  }) {
    if (loading != null) return loading();
    return orElse();
  }
}

abstract class Loading<T> implements BaseState<T> {
  const factory Loading() = _$LoadingImpl<T>;
}

/// Success

class _$SuccessImpl<T> implements Success<T> {
  const _$SuccessImpl([this.model]);

  @override
  final T? model;

  @override
  String toString() => 'BaseState<$T>.success(model: $model)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuccessImpl<T> &&
            const DeepCollectionEquality().equals(other.model, model));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(model));

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(T? model) success,
    required TResult Function(BaseException error, VoidCallback retry) failure,
  }) {
    return success(model);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function(T? model)? success,
    TResult? Function(BaseException error, VoidCallback retry)? failure,
  }) {
    return success?.call(model);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(T? model)? success,
    TResult Function(BaseException error, VoidCallback retry)? failure,
    required TResult Function() orElse,
  }) {
    if (success != null) return success(model);
    return orElse();
  }
}

abstract class Success<T> implements BaseState<T> {
  const factory Success([final T? model]) = _$SuccessImpl<T>;

  T? get model;
}

/// Failure

class _$FailureImpl<T> implements Failure<T> {
  const _$FailureImpl(this.error, this.retry);

  @override
  final BaseException error;
  @override
  final VoidCallback retry;

  @override
  String toString() => 'BaseState<$T>.failure(error: $error)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FailureImpl<T> &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function(T? model) success,
    required TResult Function(BaseException error, VoidCallback retry) failure,
  }) {
    return failure(error, retry);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function(T? model)? success,
    TResult? Function(BaseException error, VoidCallback retry)? failure,
  }) {
    return failure?.call(error, retry);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function(T? model)? success,
    TResult Function(BaseException error, VoidCallback retry)? failure,
    required TResult Function() orElse,
  }) {
    if (failure != null) return failure(error, retry);
    return orElse();
  }
}

abstract class Failure<T> implements BaseState<T> {
  const factory Failure(
    final BaseException error,
    final VoidCallback retry,
  ) = _$FailureImpl<T>;

  BaseException get error;
  VoidCallback get retry;
}
