import 'package:freezed_annotation/freezed_annotation.dart';
import 'planet_model.dart';

part 'planets_page_model.freezed.dart';
part 'planets_page_model.g.dart';

/// SWAPI paginated envelope: { count, next, previous, results }.
@freezed
class PlanetsPageModel with _$PlanetsPageModel {
  const factory PlanetsPageModel({
    required int count,
    String? next,
    String? previous,
    required List<PlanetModel> results,
  }) = _PlanetsPageModel;

  factory PlanetsPageModel.fromJson(Map<String, dynamic> json) =>
      _$PlanetsPageModelFromJson(json);
}
