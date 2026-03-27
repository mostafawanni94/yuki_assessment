/// Pure domain entity — no Flutter, no Dio, no JSON.
/// Immutable value object. Equality by [url] (unique SWAPI identifier).
class Planet {
  const Planet({
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

  /// Film titles — resolved from URLs by the repository layer.
  final List<String> films;

  /// Resident names — resolved from URLs by the repository layer.
  final List<String> residents;

  final String url;
  final String created;
  final String edited;

  Planet copyWith({
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
      Planet(
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
      other is Planet &&
          runtimeType == other.runtimeType &&
          url == other.url;

  @override
  int get hashCode => url.hashCode;

  @override
  String toString() => 'Planet(name: $name, url: $url)';
}
