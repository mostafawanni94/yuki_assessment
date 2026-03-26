import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swapi_planets/core/theme/app_colors.dart';
import 'package:swapi_planets/core/theme/app_text_styles.dart';
import 'package:swapi_planets/core/ui/widgets/glowing_planet_orb.dart';
import 'package:swapi_planets/feature/planets/domain/model/planet_model.dart';

/// Pro planet card — name, climate/terrain, film chips, animated orb.
/// Single Responsibility: renders one planet card.
class PlanetListItem extends StatelessWidget {
  const PlanetListItem({
    super.key,
    required this.planet,
    required this.index,
    required this.onTap,
  });

  final PlanetModel planet;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        child: _CardShell(
          onTap: onTap,
          child: Row(
            children: [
              GlowingPlanetOrb(
                size: 52.r,
                colors: AppColors.planetGradientAt(index),
                heroTag: 'planet_orb_${planet.url}',
              ),
              SizedBox(width: 14.w),
              Expanded(child: _PlanetInfo(planet: planet)),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
                size: 18.r,
              ),
            ],
          ),
        ),
      );
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          splashColor: AppColors.goldGlow,
          highlightColor: AppColors.goldGlow.withOpacity(0.5),
          child: Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border:
                  Border.all(color: AppColors.border, width: 0.5),
              // Subtle top-left highlight
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.bgCardLight.withOpacity(0.6),
                  AppColors.bgCard,
                ],
              ),
            ),
            child: child,
          ),
        ),
      );
}

class _PlanetInfo extends StatelessWidget {
  const _PlanetInfo({required this.planet});
  final PlanetModel planet;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(planet.name, style: AppTextStyles.headingMedium),
          SizedBox(height: 3.h),
          Row(children: [
            _MiniTag(
              icon: Icons.thermostat_rounded,
              label: planet.climate,
            ),
            SizedBox(width: 8.w),
            _MiniTag(
              icon: Icons.terrain_rounded,
              label: planet.terrain,
            ),
          ]),
          if (planet.films.isNotEmpty) ...[
            SizedBox(height: 8.h),
            _FilmChips(films: planet.films),
          ],
        ],
      );
}

class _MiniTag extends StatelessWidget {
  const _MiniTag({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icon, size: 10.r, color: AppColors.textMuted),
        SizedBox(width: 3.w),
        Flexible(
          child: Text(
            label,
            style: AppTextStyles.bodySmall,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ]);
}

class _FilmChips extends StatelessWidget {
  const _FilmChips({required this.films});
  final List<String> films;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 5.w,
        runSpacing: 4.h,
        children: films
            .map((t) => Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.goldGlow,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                        color: AppColors.goldDim.withOpacity(0.5),
                        width: 0.5),
                  ),
                  child: Text(t, style: AppTextStyles.chip),
                ))
            .toList(),
      );
}
