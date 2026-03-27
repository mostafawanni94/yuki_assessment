import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swapi_planets/core/base_bloc/base_state.dart';
import 'package:swapi_planets/core/l10n/app_strings.dart';
import 'package:swapi_planets/core/theme/app_colors.dart';
import 'package:swapi_planets/core/theme/app_text_styles.dart';
import 'package:swapi_planets/core/ui/error_handling/error_state_widget.dart';
import 'package:swapi_planets/core/ui/widgets/glowing_planet_orb.dart';
import 'package:swapi_planets/core/ui/widgets/star_field_background.dart';
import 'package:swapi_planets/feature/planet_detail/presentation/bloc/planet_detail_bloc.dart';
import 'package:swapi_planets/feature/planets/domain/model/planet_model.dart';

class PlanetDetailScreen extends StatefulWidget {
  const PlanetDetailScreen({super.key, required this.planet});
  static const String route = '/planet';
  final PlanetModel planet;

  @override
  State<PlanetDetailScreen> createState() => _PlanetDetailScreenState();
}

class _PlanetDetailScreenState extends State<PlanetDetailScreen> {
  late final PlanetDetailBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = PlanetDetailBloc()..loadDetail(widget.planet);
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: _bloc,
        child: Scaffold(
          backgroundColor: AppColors.current.bg,
          body: BlocBuilder<PlanetDetailBloc, BaseState<PlanetModel>>(
            builder: (_, state) => state.when(
              init: () => const SizedBox.shrink(),
              loading: () => _DetailLayout(
                planet: widget.planet,
                body: const Center(
                  child: CircularProgressIndicator(color: AppColors.current.primary),
                ),
              ),
              success: (p) => _DetailLayout(
                planet: p ?? widget.planet,
                body: _DetailBody(planet: p ?? widget.planet),
              ),
              failure: (e, r) => _DetailLayout(
                planet: widget.planet,
                body: Center(
                  child: ErrorStateWidget(error: e, onRetry: r),
                ),
              ),
            ),
          ),
        ),
      );
}

// ─── Layout shell ─────────────────────────────────────────────────────────────

class _DetailLayout extends StatelessWidget {
  const _DetailLayout({required this.planet, required this.body});
  final PlanetModel planet;
  final Widget body;

  @override
  Widget build(BuildContext context) => Stack(children: [
        const Positioned.fill(child: StarFieldBackground(starCount: 80)),
        CustomScrollView(slivers: [
          _PlanetSliverAppBar(planet: planet),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 40.h),
              child: body,
            ),
          ),
        ]),
      ]);
}

// ─── Sliver AppBar ────────────────────────────────────────────────────────────

class _PlanetSliverAppBar extends StatelessWidget {
  const _PlanetSliverAppBar({required this.planet});
  final PlanetModel planet;

  // Derive orb gradient from planet name hash — same index as list
  List<Color> get _colors {
    final idx = planet.name.codeUnits
        .fold(0, (sum, c) => sum + c);
    return AppColors.planetGradientAt(idx);
  }

  @override
  Widget build(BuildContext context) => SliverAppBar(
        expandedHeight: 260.h,
        pinned: true,
        backgroundColor: AppColors.current.bg.withOpacity(0.92),
        iconTheme: const IconThemeData(color: AppColors.current.textPrimary),
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          titlePadding: EdgeInsets.only(left: 52.w, bottom: 14.h),
          title: Text(planet.name,
              style: AppTextStyles.headingMediumCurrent.copyWith(
                shadows: [
                  Shadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 8)
                ],
              )),
          background: _AppBarBackground(planet: planet, colors: _colors),
        ),
      );
}

class _AppBarBackground extends StatelessWidget {
  const _AppBarBackground(
      {required this.planet, required this.colors});
  final PlanetModel planet;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.current.bg,
              colors.last.withOpacity(0.15),
              AppColors.current.bg,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 32.h),
              GlowingPlanetOrb(
                size: 120.r,
                colors: colors,
                heroTag: 'planet_orb_${planet.url}',
              ),
              SizedBox(height: 14.h),
              // Population badge
              if (planet.population.isNotEmpty &&
                  planet.population != 'unknown')
                _PopulationBadge(population: planet.population),
            ],
          ),
        ),
      );
}

class _PopulationBadge extends StatelessWidget {
  const _PopulationBadge({required this.population});
  final String population;

  String get _formatted {
    final n = int.tryParse(population);
    if (n == null) return population;
    if (n >= 1000000000) return '${(n / 1e9).toStringAsFixed(1)}B';
    if (n >= 1000000) return '${(n / 1e6).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1e3).toStringAsFixed(1)}K';
    return '$n';
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: AppColors.current.primaryGlow,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
              color: AppColors.current.primaryDim.withOpacity(0.5), width: 0.5),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.people_rounded,
              size: 12.r, color: AppColors.current.primary),
          SizedBox(width: 4.w),
          Text('$_formatted inhabitants',
              style: AppTextStyles.chipCurrent),
        ]),
      );
}

// ─── Detail body ──────────────────────────────────────────────────────────────

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.planet});
  final PlanetModel planet;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          SizedBox(height: 8.h),
          _SectionCard(
            title: AppStrings.sectionOrbital,
            icon: Icons.radar_rounded,
            rows: [
              _Row(AppStrings.fieldDiameter,
                  '${AppStrings.display(planet.diameter)} ${AppStrings.unitKm}'),
              _Row(AppStrings.fieldRotation,
                  '${AppStrings.display(planet.rotationPeriod)} ${AppStrings.unitHours}'),
              _Row(AppStrings.fieldOrbital,
                  '${AppStrings.display(planet.orbitalPeriod)} ${AppStrings.unitDays}'),
              _Row(AppStrings.fieldGravity,
                  AppStrings.display(planet.gravity)),
            ],
          ),
          _SectionCard(
            title: AppStrings.sectionEnvironment,
            icon: Icons.landscape_rounded,
            rows: [
              _Row(AppStrings.fieldClimate,
                  AppStrings.display(planet.climate)),
              _Row(AppStrings.fieldTerrain,
                  AppStrings.display(planet.terrain)),
              _Row(AppStrings.fieldSurfaceWater,
                  '${AppStrings.display(planet.surfaceWater)}${AppStrings.unitPercent}'),
            ],
          ),
          if (planet.films.isNotEmpty)
            _ListSection(
              title: AppStrings.sectionFilms,
              icon: Icons.movie_creation_rounded,
              items: planet.films,
              itemIcon: Icons.star_rounded,
              itemIconColor: AppColors.current.primary,
            ),
          if (planet.residents.isNotEmpty)
            _ListSection(
              title: AppStrings.sectionResidents,
              icon: Icons.people_alt_rounded,
              items: planet.residents,
              itemIcon: Icons.person_rounded,
              itemIconColor: AppColors.current.accent,
            ),
        ],
      );
}

// ─── Section card ─────────────────────────────────────────────────────────────

class _Row {
  const _Row(this.label, this.value);
  final String label;
  final String value;
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.rows,
  });
  final String title;
  final IconData icon;
  final List<_Row> rows;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.current.bgCard,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.current.border, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(title: title, icon: icon),
              Divider(
                  height: 0,
                  thickness: 0.5,
                  color: AppColors.current.divider),
              ...rows.map((r) => _InfoRow(label: r.label, value: r.value)),
            ],
          ),
        ),
      );
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 10.h),
        child: Row(children: [
          Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              color: AppColors.current.primaryGlow,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 15.r, color: AppColors.current.primary),
          ),
          SizedBox(width: 10.w),
          Text(title, style: AppTextStyles.headingSmallCurrent),
        ]),
      );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 16.w, vertical: 11.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110.w,
              child: Text(label,
                  style: AppTextStyles.labelLargeCurrent.copyWith(
                      color: AppColors.current.textSecondary)),
            ),
            Expanded(
              child: Text(value, style: AppTextStyles.bodyMediumCurrent),
            ),
          ],
        ),
      );
}

// ─── List section (films / residents) ────────────────────────────────────────

class _ListSection extends StatelessWidget {
  const _ListSection({
    required this.title,
    required this.icon,
    required this.items,
    required this.itemIcon,
    required this.itemIconColor,
  });
  final String title;
  final IconData icon;
  final List<String> items;
  final IconData itemIcon;
  final Color itemIconColor;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.current.bgCard,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.current.border, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(title: title, icon: icon),
              Divider(
                  height: 0,
                  thickness: 0.5,
                  color: AppColors.current.divider),
              SizedBox(height: 6.h),
              ...items.map((item) => _ListItemRow(
                    text: item,
                    icon: itemIcon,
                    iconColor: itemIconColor,
                  )),
              SizedBox(height: 6.h),
            ],
          ),
        ),
      );
}

class _ListItemRow extends StatelessWidget {
  const _ListItemRow({
    required this.text,
    required this.icon,
    required this.iconColor,
  });
  final String text;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 16.w, vertical: 8.h),
        child: Row(children: [
          Container(
            width: 24.r,
            height: 24.r,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(icon, size: 13.r, color: iconColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
              child: Text(text, style: AppTextStyles.bodyMediumCurrent)),
        ]),
      );
}
