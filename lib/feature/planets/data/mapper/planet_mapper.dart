import 'package:swapi_planets/feature/planets/data/model/planet_dto.dart';
import 'package:swapi_planets/feature/planets/domain/entity/planet.dart';

/// Converts DTO (data layer) → Entity (domain layer).
/// Single Responsibility: shape transformation only.
abstract final class PlanetMapper {
  /// Maps [PlanetDto] to [Planet] entity.
  ///
  /// [films]        — pre-resolved film titles (from repository).
  /// [residentUrls] — raw resident URLs kept for lazy resolution on detail.
  ///                  Defaults to [] when not provided (e.g. in tests).
  static Planet toEntity(
    PlanetDto dto, {
    List<String> films = const [],
    List<String> residentUrls = const [],
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
        residents:      residentUrls,   // raw URLs — resolved lazily on detail
        url:            dto.url,
        created:        dto.created,
        edited:         dto.edited,
      );
}
