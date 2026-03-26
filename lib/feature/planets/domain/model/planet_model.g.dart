// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlanetModelImpl _$$PlanetModelImplFromJson(Map<String, dynamic> json) =>
    _$PlanetModelImpl(
      name: json['name'] as String,
      rotationPeriod: json['rotation_period'] as String,
      orbitalPeriod: json['orbital_period'] as String,
      diameter: json['diameter'] as String,
      climate: json['climate'] as String,
      gravity: json['gravity'] as String,
      terrain: json['terrain'] as String,
      surfaceWater: json['surface_water'] as String,
      population: json['population'] as String,
      films: (json['films'] as List<dynamic>).map((e) => e as String).toList(),
      residents:
          (json['residents'] as List<dynamic>).map((e) => e as String).toList(),
      url: json['url'] as String,
      created: json['created'] as String,
      edited: json['edited'] as String,
    );

Map<String, dynamic> _$$PlanetModelImplToJson(_$PlanetModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'rotation_period': instance.rotationPeriod,
      'orbital_period': instance.orbitalPeriod,
      'diameter': instance.diameter,
      'climate': instance.climate,
      'gravity': instance.gravity,
      'terrain': instance.terrain,
      'surface_water': instance.surfaceWater,
      'population': instance.population,
      'films': instance.films,
      'residents': instance.residents,
      'url': instance.url,
      'created': instance.created,
      'edited': instance.edited,
    };
