import 'package:swapi_planets/feature/planets/data/model/planet_dto.dart';
import 'package:swapi_planets/feature/planets/domain/entity/planet.dart';

/// Converts between data layer (DTO) and domain layer (Entity).
///
/// Single Responsibility: shape transformation only.
/// DRY: one mapper — used by repository, never duplicated.
abstract final class PlanetMapper {
  /// DTO → Entity.
  /// [films] and [residents] are already resolved to human-readable strings
  /// by the repository before calling this.
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

  /// Entity → DTO (for cache write-back, if needed in future).
  static PlanetDto toDto(Planet entity) => PlanetDto(
        name:           entity.name,
        rotationPeriod: entity.rotationPeriod,
        orbitalPeriod:  entity.orbitalPeriod,
        diameter:       entity.diameter,
        climate:        entity.climate,
        gravity:        entity.gravity,
        terrain:        entity.terrain,
        surfaceWater:   entity.surfaceWater,
        population:     entity.population,
        filmUrls:       entity.films,
        residentUrls:   entity.residents,
        url:            entity.url,
        created:        entity.created,
        edited:         entity.edited,
      );
}
