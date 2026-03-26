// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'planets_page_model.dart';

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. '
    'This is only to be used by code generation.');

/// @nodoc
mixin _$PlanetsPageModel {
  int get count => throw _privateConstructorUsedError;
  String? get next => throw _privateConstructorUsedError;
  String? get previous => throw _privateConstructorUsedError;
  List<PlanetModel> get results => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlanetsPageModelCopyWith<PlanetsPageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

abstract class $PlanetsPageModelCopyWith<$Res> {
  factory $PlanetsPageModelCopyWith(
          PlanetsPageModel value, $Res Function(PlanetsPageModel) then) =
      _$PlanetsPageModelCopyWithImpl<$Res, PlanetsPageModel>;
  @useResult
  $Res call({int count, String? next, String? previous, List<PlanetModel> results});
}

class _$PlanetsPageModelCopyWithImpl<$Res, $Val extends PlanetsPageModel>
    implements $PlanetsPageModelCopyWith<$Res> {
  _$PlanetsPageModelCopyWithImpl(this._value, this._then);
  final $Val _value;
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
    Object? next = freezed,
    Object? previous = freezed,
    Object? results = null,
  }) {
    return _then(_value.copyWith(
      count: null == count ? _value.count : count as int,
      next: freezed == next ? _value.next : next as String?,
      previous: freezed == previous ? _value.previous : previous as String?,
      results: null == results ? _value.results : results as List<PlanetModel>,
    ) as $Val);
  }
}

abstract class _$$PlanetsPageModelImplCopyWith<$Res>
    implements $PlanetsPageModelCopyWith<$Res> {
  factory _$$PlanetsPageModelImplCopyWith(_$PlanetsPageModelImpl value,
          $Res Function(_$PlanetsPageModelImpl) then) =
      __$$PlanetsPageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int count, String? next, String? previous, List<PlanetModel> results});
}

class __$$PlanetsPageModelImplCopyWithImpl<$Res>
    extends _$PlanetsPageModelCopyWithImpl<$Res, _$PlanetsPageModelImpl>
    implements _$$PlanetsPageModelImplCopyWith<$Res> {
  __$$PlanetsPageModelImplCopyWithImpl(_$PlanetsPageModelImpl _value,
      $Res Function(_$PlanetsPageModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
    Object? next = freezed,
    Object? previous = freezed,
    Object? results = null,
  }) {
    return _then(_$PlanetsPageModelImpl(
      count: null == count ? _value.count : count as int,
      next: freezed == next ? _value.next : next as String?,
      previous: freezed == previous ? _value.previous : previous as String?,
      results: null == results ? _value.results : results as List<PlanetModel>,
    ));
  }
}

@JsonSerializable()
class _$PlanetsPageModelImpl implements _PlanetsPageModel {
  const _$PlanetsPageModelImpl({
    required this.count,
    this.next,
    this.previous,
    required final List<PlanetModel> results,
  }) : _results = results;

  factory _$PlanetsPageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlanetsPageModelImplFromJson(json);

  @override
  final int count;
  @override
  final String? next;
  @override
  final String? previous;
  final List<PlanetModel> _results;
  @override
  List<PlanetModel> get results => _results;

  @override
  String toString() => 'PlanetsPageModel(count: $count, next: $next, previous: $previous, results: $results)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType && other is _$PlanetsPageModelImpl &&
          other.count == count && other.next == next);

  @override
  int get hashCode => Object.hash(runtimeType, count, next);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanetsPageModelImplCopyWith<_$PlanetsPageModelImpl> get copyWith =>
      __$$PlanetsPageModelImplCopyWithImpl<_$PlanetsPageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() => _$$PlanetsPageModelImplToJson(this);
}

abstract class _PlanetsPageModel implements PlanetsPageModel {
  const factory _PlanetsPageModel({
    required final int count,
    final String? next,
    final String? previous,
    required final List<PlanetModel> results,
  }) = _$PlanetsPageModelImpl;

  factory _PlanetsPageModel.fromJson(Map<String, dynamic> json) =
      _$PlanetsPageModelImpl.fromJson;

  @override
  int get count;
  @override
  String? get next;
  @override
  String? get previous;
  @override
  List<PlanetModel> get results;
  @override
  @JsonKey(ignore: true)
  _$$PlanetsPageModelImplCopyWith<_$PlanetsPageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
