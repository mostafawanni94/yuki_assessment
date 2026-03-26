import 'planet_model.dart';

/// SWAPI paginated envelope: { count, next, previous, results }.
/// Plain Dart class — no code generation, no part directives.
class PlanetsPageModel {
  const PlanetsPageModel({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  final int count;
  final String? next;
  final String? previous;
  final List<PlanetModel> results;

  factory PlanetsPageModel.fromJson(Map<String, dynamic> json) =>
      PlanetsPageModel(
        count: (json['count'] as num).toInt(),
        next: json['next'] as String?,
        previous: json['previous'] as String?,
        results: (json['results'] as List<dynamic>)
            .map((e) => PlanetModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
