// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planets_page_model.dart';

_$PlanetsPageModelImpl _$$PlanetsPageModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PlanetsPageModelImpl(
      count: (json['count'] as num).toInt(),
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>)
          .map((e) => PlanetModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PlanetsPageModelImplToJson(
        _$PlanetsPageModelImpl instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results.map((e) => e.toJson()).toList(),
    };
