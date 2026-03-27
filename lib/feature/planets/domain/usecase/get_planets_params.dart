import 'package:swapi_planets/core/usecase/use_case_params.dart';

/// Parameters for [GetPlanetsUseCase].
class GetPlanetsParams extends UseCaseParams {
  GetPlanetsParams({required this.page, super.cancelToken});
  final int page;
}
