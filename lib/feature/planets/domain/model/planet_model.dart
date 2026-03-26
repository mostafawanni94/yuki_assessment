import 'package:freezed_annotation/freezed_annotation.dart';

part 'planet_model.freezed.dart';
part 'planet_model.g.dart';

/// Domain model for a SWAPI planet.
///
/// Const-correct: immutable via Freezed.
/// All nullable fields mirror the SWAPI "unknown" / "n/a" responses.
@freezed
class PlanetModel with _$PlanetModel {
  const factory PlanetModel({
    required String name,
    required String rotationPeriod,
    required String orbitalPeriod,
    required String diameter,
    required String climate,
    required String gravity,
    required String terrain,
    required String surfaceWater,
    required String population,
    /// Film URLs — resolved to titles in the repository layer.
    required List<String> films,
    /// Resident URLs — kept as raw URLs for future use.
    required List<String> residents,
    required String url,
    required String created,
    required String edited,
  }) = _PlanetModel;

  factory PlanetModel.fromJson(Map<String, dynamic> json) =>
      _$PlanetModelFromJson(json);
}
