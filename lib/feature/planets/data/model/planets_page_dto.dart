import 'planet_dto.dart';

/// DTO for the SWAPI paginated envelope.
class PlanetsPageDto {
  const PlanetsPageDto({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  final int count;
  final String? next;
  final String? previous;
  final List<PlanetDto> results;

  factory PlanetsPageDto.fromJson(Map<String, dynamic> json) =>
      PlanetsPageDto(
        count:    (json['count'] as num).toInt(),
        next:     json['next']     as String?,
        previous: json['previous'] as String?,
        results: (json['results'] as List<dynamic>)
            .map((e) => PlanetDto.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
