import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:swapi_planets/core/base_bloc/base_state.dart';
import 'package:swapi_planets/core/l10n/app_strings.dart';
import 'package:swapi_planets/core/theme/app_colors.dart';
import 'package:swapi_planets/core/theme/app_text_styles.dart';
import 'package:swapi_planets/core/ui/error_handling/error_state_widget.dart';
import 'package:swapi_planets/core/ui/widgets/star_field_background.dart';
import 'package:swapi_planets/feature/planet_detail/presentation/screen/planet_detail_screen.dart';
import 'package:swapi_planets/feature/planets/domain/model/planet_model.dart';
import 'package:swapi_planets/feature/planets/presentation/bloc/planets_bloc.dart';
import 'package:swapi_planets/feature/planets/presentation/widgets/planet_list_item.dart';
import 'package:swapi_planets/feature/planets/presentation/widgets/planets_loading_shimmer.dart';

class PlanetsListScreen extends StatefulWidget {
  const PlanetsListScreen({super.key});
  static const String route = '/';

  @override
  State<PlanetsListScreen> createState() => _PlanetsListScreenState();
}

class _PlanetsListScreenState extends State<PlanetsListScreen>
    with SingleTickerProviderStateMixin {
  late final PlanetsBloc _bloc;
  late final ScrollController _scroll;
  late final AnimationController _headerCtrl;
  late final Animation<double> _headerFade;

  @override
  void initState() {
    super.initState();
    _bloc = GetIt.I<PlanetsBloc>();
    _scroll = ScrollController()..addListener(_onScroll);
    _headerCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _headerFade =
        CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut);
    _bloc.loadPlanets();
    _headerCtrl.forward();
  }

  @override
  void dispose() {
    _scroll.dispose();
    _headerCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.position.pixels >=
        _scroll.position.maxScrollExtent - 200) {
      _bloc.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: _bloc,
        child: Scaffold(
          backgroundColor: AppColors.bg,
          body: Stack(children: [
            const Positioned.fill(child: StarFieldBackground()),
            CustomScrollView(
              controller: _scroll,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                _buildSliverAppBar(),
                BlocBuilder<PlanetsBloc, BaseState<List<PlanetModel>>>(
                  builder: (_, state) => state.when(
                    init: () =>
                        const SliverToBoxAdapter(child: SizedBox.shrink()),
                    loading: _buildLoading,
                    success: (planets) => _buildSuccess(planets ?? []),
                    failure: (error, retry) => _buildFailure(error, retry),
                  ),
                ),
              ],
            ),
          ]),
        ),
      );

  // ─── AppBar ───────────────────────────────────────────────────────────────

  Widget _buildSliverAppBar() => SliverAppBar(
        expandedHeight: 140.h,
        floating: true,
        snap: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          background: _HeaderBanner(animation: _headerFade),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: AppStrings.refresh,
            onPressed: _bloc.loadPlanets,
            color: AppColors.textSecondary,
          ),
          SizedBox(width: 8.w),
        ],
      );

  // ─── State builders ───────────────────────────────────────────────────────

  Widget _buildLoading() {
    // Page 1 → full shimmer. Page 2+ → keep visible list + append spinner.
    final cached = _bloc.cachedPlanets;
    if (cached.isEmpty) {
      return const SliverFillRemaining(
          child: PlanetsLoadingShimmer());
    }
    return SliverToBoxAdapter(
      child: _PlanetsList(
        planets: cached,
        isLoadingMore: true,
        onTap: _navigateToDetail,
      ),
    );
  }

  Widget _buildSuccess(List<PlanetModel> planets) {
    if (planets.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: ErrorStateWidget.empty(
            emptyTitle: AppStrings.emptyPlanets,
            emptyMessage: AppStrings.emptyPlanetsMsg,
          ),
        ),
      );
    }
    return SliverToBoxAdapter(
      child: RefreshIndicator(
        onRefresh: _bloc.loadPlanets,
        color: AppColors.gold,
        backgroundColor: AppColors.bgCard,
        child: _PlanetsList(
          planets: planets,
          isLoadingMore: false,
          onTap: _navigateToDetail,
        ),
      ),
    );
  }

  Widget _buildFailure(dynamic error, VoidCallback retry) =>
      SliverFillRemaining(
        child:
            Center(child: ErrorStateWidget(error: error, onRetry: retry)),
      );

  void _navigateToDetail(PlanetModel planet) =>
      context.push(PlanetDetailScreen.route, extra: planet);
}

// ─── Header banner ────────────────────────────────────────────────────────────

class _HeaderBanner extends StatelessWidget {
  const _HeaderBanner({required this.animation});
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: animation,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 56.h, 20.w, 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(children: [
                Container(
                  width: 3.w,
                  height: 28.h,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(2.r),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.goldGlow,
                          blurRadius: 8,
                          spreadRadius: 1)
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStrings.planetsTitle,
                        style: AppTextStyles.displayMedium),
                    Text(AppStrings.planetsSubtitle,
                        style: AppTextStyles.bodySmall),
                  ],
                ),
              ]),
            ],
          ),
        ),
      );
}

// ─── Planet list ──────────────────────────────────────────────────────────────

class _PlanetsList extends StatelessWidget {
  const _PlanetsList({
    required this.planets,
    required this.isLoadingMore,
    required this.onTap,
  });
  final List<PlanetModel> planets;
  final bool isLoadingMore;
  final void Function(PlanetModel) onTap;

  @override
  Widget build(BuildContext context) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 8.h, bottom: 24.h),
        itemCount: planets.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (_, i) {
          if (i == planets.length) return const _LoadMoreSpinner();
          return PlanetListItem(
            planet: planets[i],
            index: i,
            onTap: () => onTap(planets[i]),
          );
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
            width: 20.r,
            height: 20.r,
            child: CircularProgressIndicator(
                strokeWidth: 1.5, color: AppColors.gold),
          ),
        ),
      );
}
