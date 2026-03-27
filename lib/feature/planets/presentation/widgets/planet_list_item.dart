import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swapi_planets/core/theme/app_colors.dart';
import 'package:swapi_planets/core/theme/app_text_styles.dart';
import 'package:swapi_planets/core/ui/widgets/glowing_planet_orb.dart';
import 'package:swapi_planets/feature/planets/domain/entity/planet.dart';

/// Single planet card in the list.
class PlanetListItem extends StatelessWidget {
  const PlanetListItem({
    super.key,
    required this.planet,
    required this.index,
    required this.onTap,
  });

  final Planet planet;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        child: Material(
          color: AppColors.current.bgCard,
          borderRadius: BorderRadius.circular(16.r),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16.r),
            splashColor: AppColors.current.primaryGlow,
            child: Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.current.border, width: 0.5),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.current.bgCardLight.withOpacity(0.6),
                    AppColors.current.bgCard,
                  ],
                ),
              ),
              // Row is bounded by the card width — safe to use Expanded here
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GlowingPlanetOrb(
                    size: 52.r,
                    colors: AppColors.current.planetGradientAt(index),
                    heroTag: 'planet_orb_${planet.url}',
                  ),
                  SizedBox(width: 12.w),
                  // Expanded gives a finite width to the column → fixes unbounded Row crash
                  Expanded(
                    child: _PlanetInfo(planet: planet),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.current.textMuted,
                    size: 18.r,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _PlanetInfo extends StatelessWidget {
  const _PlanetInfo({required this.planet});
  final Planet planet;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            planet.name,
            style: AppTextStyles.headingMediumCurrent,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          // Use a Row with intrinsicWidth tags — no Flexible/Expanded needed
          // Each tag is shrink-wrapped; the Row itself is bounded by Expanded above
          _MetaRow(climate: planet.climate, terrain: planet.terrain),
          if (planet.films.isNotEmpty) ...[
            SizedBox(height: 8.h),
            _FilmChips(films: planet.films),
          ],
        ],
      );
}

/// Climate + terrain tags in a bounded row.
class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.climate, required this.terrain});
  final String climate;
  final String terrain;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,      // shrink-wrap — no unbounded expansion
        children: [
          _Tag(icon: Icons.thermostat_rounded, label: climate),
          SizedBox(width: 10.w),
          _Tag(icon: Icons.terrain_rounded, label: terrain),
        ],
      );
}

/// Single icon + text tag — intrinsically sized, no Flexible.
class _Tag extends StatelessWidget {
  const _Tag({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11.r, color: AppColors.current.textMuted),
          SizedBox(width: 3.w),
          ConstrainedBox(
            // Cap at 90px so long values don't overflow the card
            constraints: BoxConstraints(maxWidth: 90.w),
            child: Text(
              label,
              style: AppTextStyles.bodySmallCurrent,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
}

class _FilmChips extends StatelessWidget {
  const _FilmChips({required this.films});
  final List<String> films;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 5.w,
        runSpacing: 4.h,
        children: films
            .map(
              (t) => Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.current.primaryGlow,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                      color: AppColors.current.primaryDim.withOpacity(0.5),
                      width: 0.5),
                ),
                child: Text(t, style: AppTextStyles.chipCurrent),
              ),
            )
            .toList(),
      );
}
