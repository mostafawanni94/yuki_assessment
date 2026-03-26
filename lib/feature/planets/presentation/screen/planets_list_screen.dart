import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:swapi_planets/core/base_bloc/base_state.dart';
import 'package:swapi_planets/core/theme/app_theme.dart';
import 'package:swapi_planets/core/ui/error_handling/error_state_widget.dart';
import 'package:swapi_planets/feature/planets/domain/model/planet_model.dart';
import 'package:swapi_planets/feature/planets/presentation/bloc/planets_bloc.dart';
import 'package:swapi_planets/feature/planets/presentation/widgets/planet_list_item.dart';
import 'package:swapi_planets/feature/planets/presentation/widgets/planets_loading_shimmer.dart';

/// Planets list screen — entry point of the assessment.
///
/// Responsibilities:
///   - Provides [PlanetsBloc] via BlocProvider
///   - Renders loading / error / empty / success states
///   - Triggers pagination on scroll-to-bottom
///   - Navigates to detail screen on planet tap
class PlanetsListScreen extends StatefulWidget {
  const PlanetsListScreen({super.key});

  static const String route = '/';

  @override
  State<PlanetsListScreen> createState() => _PlanetsListScreenState();
}

class _PlanetsListScreenState extends State<PlanetsListScreen> {
  late final PlanetsBloc _bloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _bloc = GetIt.I<PlanetsBloc>();
    _bloc.loadPlanets();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final pos = _scrollController.position;
    // Trigger load-more when within 200px of bottom
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      _bloc.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: _bloc,
        child: Scaffold(
          appBar: _buildAppBar(),
          body: BlocBuilder<PlanetsBloc, BaseState<List<PlanetModel>>>(
            builder: (context, state) => state.when(
              init: () => const SizedBox.shrink(),
              loading: _buildLoading,
              success: (planets) => _buildList(planets ?? []),
              failure: (error, retry) => _buildError(error, retry),
            ),
          ),
        ),
      );

  // ─── AppBar ───────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() => AppBar(
        title: const Text('Star Wars Planets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _bloc.loadPlanets,
          ),
        ],
      );

  // ─── State builders ───────────────────────────────────────────────────────

  Widget _buildLoading() => _bloc.currentPage == 1
      ? const PlanetsLoadingShimmer()
      : _buildList(_bloc.state.model ?? [], isLoadingMore: true);

  Widget _buildError(dynamic error, VoidCallback retry) =>
      Center(child: ErrorStateWidget(error: error, onRetry: retry));

  Widget _buildList(
    List<PlanetModel> planets, {
    bool isLoadingMore = false,
  }) {
    if (planets.isEmpty) {
      return const Center(
        child: ErrorStateWidget.empty(emptyTitle: 'No planets found'),
      );
    }

    return RefreshIndicator(
      onRefresh: _bloc.loadPlanets,
      color: AppTheme.highlight,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 8.h, bottom: 24.h),
        itemCount: planets.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == planets.length) return _LoadMoreIndicator();
          return PlanetListItem(
            planet: planets[index],
            onTap: () => context.push('/planet', extra: planets[index]),
          );
        },
      ),
    );
  }
}

/// Inline spinner shown at list bottom while loading next page.
class _LoadMoreIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Center(
          child: SizedBox(
            width: 24.r,
            height: 24.r,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppTheme.highlight,
            ),
          ),
        ),
      );
}
