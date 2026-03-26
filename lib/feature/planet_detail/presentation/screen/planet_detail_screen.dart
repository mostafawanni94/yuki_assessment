import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swapi_planets/core/base_bloc/base_state.dart';
import 'package:swapi_planets/core/theme/app_theme.dart';
import 'package:swapi_planets/core/ui/error_handling/error_state_widget.dart';
import 'package:swapi_planets/feature/planet_detail/presentation/bloc/planet_detail_bloc.dart';
import 'package:swapi_planets/feature/planet_detail/presentation/widgets/detail_info_row.dart';
import 'package:swapi_planets/feature/planet_detail/presentation/widgets/detail_section_card.dart';
import 'package:swapi_planets/feature/planets/domain/model/planet_model.dart';

/// Planet detail screen — shows all available SWAPI planet data.
///
/// Receives [PlanetModel] via GoRouter extra — already has film titles
/// from the list screen, then fetches resident names on init.
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
    // Create a fresh bloc per detail screen — not a singleton
    _bloc = PlanetDetailBloc();
    _bloc.loadDetail(widget.planet);
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
          body: BlocBuilder<PlanetDetailBloc, BaseState<PlanetModel>>(
            builder: (context, state) => state.when(
              init: () => const SizedBox.shrink(),
              loading: () => _buildLoadingScaffold(),
              success: (planet) => _buildDetail(planet ?? widget.planet),
              failure: (error, retry) => _buildErrorScaffold(error, retry),
            ),
          ),
        ),
      );

  // ─── State builders ───────────────────────────────────────────────────────

  Widget _buildLoadingScaffold() => _DetailScaffold(
        planet: widget.planet,
        child: const Center(child: CircularProgressIndicator()),
      );

  Widget _buildErrorScaffold(dynamic error, VoidCallback retry) =>
      _DetailScaffold(
        planet: widget.planet,
        child: Center(
          child: ErrorStateWidget(error: error, onRetry: retry),
        ),
      );

  Widget _buildDetail(PlanetModel planet) => _DetailScaffold(
        planet: planet,
        child: _DetailBody(planet: planet),
      );
}

// ─── Layout scaffold ──────────────────────────────────────────────────────────

class _DetailScaffold extends StatelessWidget {
  const _DetailScaffold({required this.planet, required this.child});
  final PlanetModel planet;
  final Widget child;

  @override
  Widget build(BuildContext context) => CustomScrollView(
        slivers: [
          _PlanetSliverAppBar(planet: planet),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 32.h),
              child: child,
            ),
          ),
        ],
      );
}

// ─── Sliver AppBar ────────────────────────────────────────────────────────────

class _PlanetSliverAppBar extends StatelessWidget {
  const _PlanetSliverAppBar({required this.planet});
  final PlanetModel planet;

  @override
  Widget build(BuildContext context) => SliverAppBar(
        expandedHeight: 200.h,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          title: Text(
            planet.name,
            style: context.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          background: _PlanetHero(name: planet.name),
          titlePadding: EdgeInsets.only(left: 16.w, bottom: 16.h),
        ),
      );
}

class _PlanetHero extends StatelessWidget {
  const _PlanetHero({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.primary, AppTheme.accent, AppTheme.secondary],
          ),
        ),
        child: Center(
          child: Container(
            width: 100.r,
            height: 100.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                AppTheme.highlight.withOpacity(0.8),
                AppTheme.accent,
              ]),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.highlight.withOpacity(0.4),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Icon(Icons.public, size: 54.r, color: Colors.white),
          ),
        ),
      );
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.planet});
  final PlanetModel planet;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          SizedBox(height: 8.h),
          _PhysicsSection(planet: planet),
          _EnvironmentSection(planet: planet),
          if (planet.films.isNotEmpty) _FilmsSection(films: planet.films),
          if (planet.residents.isNotEmpty)
            _ResidentsSection(residents: planet.residents),
        ],
      );
}

class _PhysicsSection extends StatelessWidget {
  const _PhysicsSection({required this.planet});
  final PlanetModel planet;

  @override
  Widget build(BuildContext context) => DetailSectionCard(
        title: 'ORBITAL DATA',
        icon: Icons.orbit,
        child: Column(children: [
          DetailInfoRow(
            label: 'Diameter',
            value: '${planet.diameter} km',
            icon: Icons.straighten,
          ),
          DetailInfoRow(
            label: 'Rotation',
            value: '${planet.rotationPeriod} hrs',
            icon: Icons.rotate_right,
          ),
          DetailInfoRow(
            label: 'Orbital period',
            value: '${planet.orbitalPeriod} days',
            icon: Icons.loop,
          ),
          DetailInfoRow(
            label: 'Gravity',
            value: planet.gravity,
            icon: Icons.arrow_downward,
          ),
        ]),
      );
}

class _EnvironmentSection extends StatelessWidget {
  const _EnvironmentSection({required this.planet});
  final PlanetModel planet;

  @override
  Widget build(BuildContext context) => DetailSectionCard(
        title: 'ENVIRONMENT',
        icon: Icons.landscape,
        child: Column(children: [
          DetailInfoRow(
            label: 'Climate',
            value: planet.climate,
            icon: Icons.thermostat,
          ),
          DetailInfoRow(
            label: 'Terrain',
            value: planet.terrain,
            icon: Icons.terrain,
          ),
          DetailInfoRow(
            label: 'Surface water',
            value: '${planet.surfaceWater}%',
            icon: Icons.water,
          ),
          DetailInfoRow(
            label: 'Population',
            value: _formatPopulation(planet.population),
            icon: Icons.people,
          ),
        ]),
      );

  String _formatPopulation(String raw) {
    final n = int.tryParse(raw);
    if (n == null) return raw;
    if (n >= 1000000000) return '${(n / 1000000000).toStringAsFixed(1)}B';
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return raw;
  }
}

class _FilmsSection extends StatelessWidget {
  const _FilmsSection({required this.films});
  final List<String> films;

  @override
  Widget build(BuildContext context) => DetailSectionCard(
        title: 'APPEARS IN',
        icon: Icons.movie_outlined,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: films
              .map((title) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(children: [
                      Icon(Icons.star, size: 14.r, color: AppTheme.highlight),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(title,
                            style: context.textTheme.bodyMedium),
                      ),
                    ]),
                  ))
              .toList(),
        ),
      );
}

class _ResidentsSection extends StatelessWidget {
  const _ResidentsSection({required this.residents});
  final List<String> residents;

  @override
  Widget build(BuildContext context) => DetailSectionCard(
        title: 'KNOWN RESIDENTS',
        icon: Icons.person_outline,
        child: Wrap(
          spacing: 8.w,
          runSpacing: 6.h,
          children: residents
              .map((name) => Chip(
                    avatar: Icon(Icons.person, size: 14.r,
                        color: AppTheme.highlight),
                    label: Text(name,
                        style: context.textTheme.labelSmall),
                    backgroundColor:
                        AppTheme.accent.withOpacity(0.3),
                    side: BorderSide(
                        color: AppTheme.highlight.withOpacity(0.3),
                        width: 0.5),
                  ))
              .toList(),
        ),
      );
}
