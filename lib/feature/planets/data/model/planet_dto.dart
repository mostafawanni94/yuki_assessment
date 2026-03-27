/// Data Transfer Object — mirrors the SWAPI JSON shape exactly.
/// Only responsible for JSON deserialization. No business logic.
class PlanetDto {
  const PlanetDto({
    required this.name,
    required this.rotationPeriod,
    required this.orbitalPeriod,
    required this.diameter,
    required this.climate,
    required this.gravity,
    required this.terrain,
    required this.surfaceWater,
    required this.population,
    required this.filmUrls,
    required this.residentUrls,
    required this.url,
    required this.created,
    required this.edited,
  });

  final String name;
  final String rotationPeriod;
  final String orbitalPeriod;
  final String diameter;
  final String climate;
  final String gravity;
  final String terrain;
  final String surfaceWater;
  final String population;

  /// Raw film URLs — e.g. ["https://swapi.dev/api/films/1/"]
  final List<String> filmUrls;

  /// Raw resident URLs — e.g. ["https://swapi.dev/api/people/1/"]
  final List<String> residentUrls;

  final String url;
  final String created;
  final String edited;

  factory PlanetDto.fromJson(Map<String, dynamic> json) => PlanetDto(
        name:           json['name']           as String,
        rotationPeriod: json['rotation_period'] as String,
        orbitalPeriod:  json['orbital_period']  as String,
        diameter:       json['diameter']        as String,
        climate:        json['climate']         as String,
        gravity:        json['gravity']         as String,
        terrain:        json['terrain']         as String,
        surfaceWater:   json['surface_water']   as String,
        population:     json['population']      as String,
        filmUrls: (json['films'] as List<dynamic>)
            .map((e) => e as String)
            .toList(),
        residentUrls: (json['residents'] as List<dynamic>)
            .map((e) => e as String)
            .toList(),
        url:     json['url']     as String,
        created: json['created'] as String,
        edited:  json['edited']  as String,
      );
}
