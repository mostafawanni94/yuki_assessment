// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. '
    'This is only to be used by code generation.');

/// @nodoc
mixin _$MyResult<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T? model) isSuccess,
    required TResult Function(BaseException error) isError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T? model)? isSuccess,
    TResult? Function(BaseException error)? isError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T? model)? isSuccess,
    TResult Function(BaseException error)? isError,
    required TResult Function() orElse,
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyResultCopyWith<T, $Res> {}

/// @nodoc
class _$IsSuccessImpl<T> implements IsSuccess<T> {
  const _$IsSuccessImpl([this.model]);

  @override
  final T? model;

  @override
  String toString() => 'MyResult<$T>.isSuccess(model: $model)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IsSuccessImpl<T> &&
            const DeepCollectionEquality().equals(other.model, model));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(model));

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T? model) isSuccess,
    required TResult Function(BaseException error) isError,
  }) {
    return isSuccess(model);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T? model)? isSuccess,
    TResult? Function(BaseException error)? isError,
  }) {
    return isSuccess?.call(model);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T? model)? isSuccess,
    TResult Function(BaseException error)? isError,
    required TResult Function() orElse,
  }) {
    if (isSuccess != null) {
      return isSuccess(model);
    }
    return orElse();
  }
}

abstract class IsSuccess<T> implements MyResult<T> {
  const factory IsSuccess([final T? model]) = _$IsSuccessImpl<T>;

  T? get model;
}

/// @nodoc
class _$IsErrorImpl<T> implements IsError<T> {
  const _$IsErrorImpl(this.error);

  @override
  final BaseException error;

  @override
  String toString() => 'MyResult<$T>.isError(error: $error)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IsErrorImpl<T> &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T? model) isSuccess,
    required TResult Function(BaseException error) isError,
  }) {
    return isError(error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(T? model)? isSuccess,
    TResult? Function(BaseException error)? isError,
  }) {
    return isError?.call(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T? model)? isSuccess,
    TResult Function(BaseException error)? isError,
    required TResult Function() orElse,
  }) {
    if (isError != null) {
      return isError(error);
    }
    return orElse();
  }
}

abstract class IsError<T> implements MyResult<T> {
  const factory IsError(final BaseException error) = _$IsErrorImpl<T>;

  BaseException get error;
}
