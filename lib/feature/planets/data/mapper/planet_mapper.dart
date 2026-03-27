import 'package:swapi_planets/feature/planets/data/model/planet_dto.dart';
import 'package:swapi_planets/feature/planets/domain/entity/planet.dart';

/// Converts DTO (data layer) → Entity (domain layer).
/// Single Responsibility: shape transformation only.
abstract final class PlanetMapper {
  /// Maps [PlanetDto] to [Planet] entity.
  /// [films] and [residents] are pre-resolved strings from repository.
  static Planet toEntity(
    PlanetDto dto, {
    List<String> films = const [],
    List<String> residents = const [],
  }) =>
      Planet(
        name:           dto.name,
        rotationPeriod: dto.rotationPeriod,
        orbitalPeriod:  dto.orbitalPeriod,
        diameter:       dto.diameter,
        climate:        dto.climate,
        gravity:        dto.gravity,
        terrain:        dto.terrain,
        surfaceWater:   dto.surfaceWater,
        population:     dto.population,
        films:          films,
        residents:      residents,
        url:            dto.url,
        created:        dto.created,
        edited:         dto.edited,
      );
}
