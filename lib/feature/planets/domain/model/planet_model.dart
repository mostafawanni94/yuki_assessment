/// Domain model for a SWAPI planet.
/// Plain Dart class — no code generation, no part directives.
class PlanetModel {
  const PlanetModel({
    required this.name,
    required this.rotationPeriod,
    required this.orbitalPeriod,
    required this.diameter,
    required this.climate,
    required this.gravity,
    required this.terrain,
    required this.surfaceWater,
    required this.population,
    required this.films,
    required this.residents,
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
  /// Film URLs — resolved to titles in the repository layer.
  final List<String> films;
  /// Resident URLs — resolved to names in the repository layer.
  final List<String> residents;
  final String url;
  final String created;
  final String edited;

  factory PlanetModel.fromJson(Map<String, dynamic> json) => PlanetModel(
        name: json['name'] as String,
        rotationPeriod: json['rotation_period'] as String,
        orbitalPeriod: json['orbital_period'] as String,
        diameter: json['diameter'] as String,
        climate: json['climate'] as String,
        gravity: json['gravity'] as String,
        terrain: json['terrain'] as String,
        surfaceWater: json['surface_water'] as String,
        population: json['population'] as String,
        films: (json['films'] as List<dynamic>)
            .map((e) => e as String)
            .toList(),
        residents: (json['residents'] as List<dynamic>)
            .map((e) => e as String)
            .toList(),
        url: json['url'] as String,
        created: json['created'] as String,
        edited: json['edited'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'rotation_period': rotationPeriod,
        'orbital_period': orbitalPeriod,
        'diameter': diameter,
        'climate': climate,
        'gravity': gravity,
        'terrain': terrain,
        'surface_water': surfaceWater,
        'population': population,
        'films': films,
        'residents': residents,
        'url': url,
        'created': created,
        'edited': edited,
      };

  PlanetModel copyWith({
    String? name,
    String? rotationPeriod,
    String? orbitalPeriod,
    String? diameter,
    String? climate,
    String? gravity,
    String? terrain,
    String? surfaceWater,
    String? population,
    List<String>? films,
    List<String>? residents,
    String? url,
    String? created,
    String? edited,
  }) =>
      PlanetModel(
        name:           name           ?? this.name,
        rotationPeriod: rotationPeriod ?? this.rotationPeriod,
        orbitalPeriod:  orbitalPeriod  ?? this.orbitalPeriod,
        diameter:       diameter       ?? this.diameter,
        climate:        climate        ?? this.climate,
        gravity:        gravity        ?? this.gravity,
        terrain:        terrain        ?? this.terrain,
        surfaceWater:   surfaceWater   ?? this.surfaceWater,
        population:     population     ?? this.population,
        films:          films          ?? this.films,
        residents:      residents      ?? this.residents,
        url:            url            ?? this.url,
        created:        created        ?? this.created,
        edited:         edited         ?? this.edited,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlanetModel && runtimeType == other.runtimeType && url == other.url;

  @override
  int get hashCode => url.hashCode;
}
