import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:swapi_planets/core/base_bloc/base_state.dart';
import 'package:swapi_planets/core/connectivity/connectivity_cubit.dart';
import 'package:swapi_planets/core/l10n/app_strings.dart';
import 'package:swapi_planets/core/theme/app_colors.dart';
import 'package:swapi_planets/core/theme/app_text_styles.dart';
import 'package:swapi_planets/core/theme/theme_cubit.dart';
import 'package:swapi_planets/core/ui/error_handling/error_state_widget.dart';
import 'package:swapi_planets/core/ui/widgets/connectivity_banner.dart';
import 'package:swapi_planets/core/ui/widgets/star_field_background.dart';
import 'package:swapi_planets/core/ui/widgets/theme_toggle_button.dart';
import 'package:swapi_planets/feature/planet_detail/presentation/screen/planet_detail_screen.dart';
import 'package:swapi_planets/feature/planets/domain/entity/planet.dart';
import 'package:swapi_planets/feature/planets/presentation/bloc/planets_bloc.dart';
import 'package:swapi_planets/feature/planets/presentation/bloc/planets_search_cubit.dart';
import 'package:swapi_planets/feature/planets/presentation/widgets/planet_list_item.dart';
import 'package:swapi_planets/feature/planets/presentation/widgets/planets_loading_shimmer.dart';

class PlanetsListScreen extends StatefulWidget {
  const PlanetsListScreen({super.key});
  static const String route = '/';

  @override
  State<PlanetsListScreen> createState() => _PlanetsListScreenState();
}

class _PlanetsListScreenState extends State<PlanetsListScreen> {
  late final PlanetsBloc _bloc;
  final PlanetsSearchCubit _search = PlanetsSearchCubit();
  final ScrollController _scroll = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    _bloc = GetIt.I<PlanetsBloc>();
    _scroll.addListener(_onScroll);
    _bloc.loadPlanets();
  }

  @override
  void dispose() {
    _scroll.dispose();
    _searchCtrl.dispose();
    _search.close();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
      _bloc.loadMore();
    }
  }

  void _toggleSearch() {
    HapticFeedback.lightImpact();
    setState(() => _showSearch = !_showSearch);
    if (!_showSearch) {
      _searchCtrl.clear();
      _search.clear();
    }
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _bloc),
          BlocProvider.value(value: _search),
        ],
        child: BlocBuilder<ThemeCubit, AppColorScheme>(
          bloc: GetIt.I<ThemeCubit>(),
          builder: (_, scheme) => Scaffold(
            backgroundColor: scheme.bg,
            appBar: _buildAppBar(scheme),
            body: Column(
              children: [
                // ConnectivityCubit already in tree from App via MultiBlocProvider
                const ConnectivityBanner(),
                Expanded(
                  child: Stack(children: [
                    const Positioned.fill(child: StarFieldBackground()),
                    _buildBody(),
                  ]),
                ),
              ],
            ),
          ),
        ),
      );

  PreferredSizeWidget _buildAppBar(AppColorScheme scheme) => AppBar(
        backgroundColor: scheme.bg,
        elevation: 0,
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _showSearch
              ? _SearchField(
                  key: const ValueKey('search'),
                  controller: _searchCtrl,
                  onChanged: _search.search,
                )
              : Column(
                  key: const ValueKey('title'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.planetsTitle,
                        style: AppTextStyles.displayMedium(scheme)
                            .copyWith(color: scheme.primary)),
                    Text(AppStrings.planetsSubtitle,
                        style: AppTextStyles.bodySmall(scheme)),
                  ],
                ),
        ),
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _showSearch ? Icons.close_rounded : Icons.search_rounded,
                key: ValueKey(_showSearch),
                color: scheme.textSecondary,
                size: 22.r,
              ),
            ),
            onPressed: _toggleSearch,
          ),
          BlocProvider.value(
            value: GetIt.I<ThemeCubit>(),
            child: const ThemeToggleButton(),
          ),
          IconButton(
            icon: Icon(Icons.refresh_rounded,
                color: scheme.textSecondary, size: 20.r),
            tooltip: AppStrings.refresh,
            onPressed: _bloc.loadPlanets,
          ),
        ],
      );

  Widget _buildBody() =>
      // Sync search source whenever planets list updates
      BlocListener<PlanetsBloc, BaseState<List<Planet>>>(
        listener: (_, state) {
          if (state is Success<List<Planet>>) {
            _search.updateSource(state.model ?? []);
          }
        },
        child: BlocBuilder<PlanetsBloc, BaseState<List<Planet>>>(
          builder: (_, state) => state.when(
            init: () => const SizedBox.shrink(),
            loading: _buildLoading,
            success: (_) => _buildSearchResults(),
            failure: (error, retry) =>
                Center(child: ErrorStateWidget(error: error, onRetry: retry)),
          ),
        ),
      );

  Widget _buildLoading() {
    final cached = _bloc.cachedPlanets;
    if (cached.isEmpty) return const PlanetsLoadingShimmer();
    return _PlanetsList(
        planets: cached, scroll: _scroll,
        isLoadingMore: true, onTap: _navigateToDetail);
  }

  Widget _buildSearchResults() =>
      BlocBuilder<PlanetsSearchCubit, List<Planet>>(
        builder: (_, planets) {
          if (planets.isEmpty && _search.isSearching) {
            return Center(
              child: ErrorStateWidget.empty(
                emptyIcon: Icons.search_off_rounded,
                emptyTitle: 'No results',
                emptyMessage: 'No planets match "${_search.query}"',
              ),
            );
          }
          if (planets.isEmpty) {
            return Center(
              child: ErrorStateWidget.empty(
                emptyTitle: AppStrings.emptyPlanets,
                emptyMessage: AppStrings.emptyPlanetsMsg,
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _bloc.loadPlanets,
            color: AppColors.current.primary,
            backgroundColor: AppColors.current.bgCard,
            displacement: 20,
            strokeWidth: 2,
            child: _PlanetsList(
              // Disable pagination scroll during search — not needed
              planets: planets,
              scroll: _search.isSearching ? ScrollController() : _scroll,
              isLoadingMore: !_search.isSearching && _bloc.state.isLoading,
              onTap: _navigateToDetail,
            ),
          );
        },
      );

  void _navigateToDetail(Planet planet) =>
      context.push(PlanetDetailScreen.route, extra: planet);
}

// ─── Search field ─────────────────────────────────────────────────────────────

class _SearchField extends StatelessWidget {
  const _SearchField({super.key, required this.controller, required this.onChanged});
  final TextEditingController controller;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        autofocus: true,
        onChanged: onChanged,
        style: AppTextStyles.bodyMediumCurrent,
        cursorColor: AppColors.current.primary,
        decoration: InputDecoration(
          hintText: 'Search by name, climate, terrain, film...',
          hintStyle: AppTextStyles.bodySmallCurrent,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          prefixIcon: Icon(Icons.search_rounded,
              color: AppColors.current.primary, size: 18.r),
        ),
      );
}

// ─── Planet list — portrait + landscape ──────────────────────────────────────

class _PlanetsList extends StatelessWidget {
  const _PlanetsList({
    required this.planets, required this.scroll,
    required this.isLoadingMore, required this.onTap,
  });
  final List<Planet> planets;
  final ScrollController scroll;
  final bool isLoadingMore;
  final void Function(Planet) onTap;

  @override
  Widget build(BuildContext context) => OrientationBuilder(
        builder: (_, orientation) => orientation == Orientation.landscape
            ? _LandscapeGrid(
                planets: planets, scroll: scroll,
                isLoadingMore: isLoadingMore, onTap: onTap)
            : _PortraitList(
                planets: planets, scroll: scroll,
                isLoadingMore: isLoadingMore, onTap: onTap),
      );
}

class _PortraitList extends StatelessWidget {
  const _PortraitList({
    required this.planets, required this.scroll,
    required this.isLoadingMore, required this.onTap,
  });
  final List<Planet> planets;
  final ScrollController scroll;
  final bool isLoadingMore;
  final void Function(Planet) onTap;

  @override
  Widget build(BuildContext context) => ListView.builder(
        controller: scroll,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 8.h, bottom: 24.h),
        itemCount: planets.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (_, i) {
          if (i == planets.length) return const _LoadMoreSpinner();
          return PlanetListItem(
              planet: planets[i], index: i, onTap: () => onTap(planets[i]));
        },
      );
}

class _LandscapeGrid extends StatelessWidget {
  const _LandscapeGrid({
    required this.planets, required this.scroll,
    required this.isLoadingMore, required this.onTap,
  });
  final List<Planet> planets;
  final ScrollController scroll;
  final bool isLoadingMore;
  final void Function(Planet) onTap;

  @override
  Widget build(BuildContext context) => GridView.builder(
        controller: scroll,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
          childAspectRatio: 2.8,
        ),
        itemCount: planets.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (_, i) {
          if (i == planets.length) return const _LoadMoreSpinner();
          return PlanetListItem(
              planet: planets[i], index: i, onTap: () => onTap(planets[i]));
        },
      );
}

class _LoadMoreSpinner extends StatelessWidget {
  const _LoadMoreSpinner();

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Center(
          child: SizedBox(
            width: 20.r, height: 20.r,
            child: CircularProgressIndicator(
                strokeWidth: 1.5, color: AppColors.current.primary),
          ),
        ),
      );
}
