import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swapi_planets/core/theme/app_theme.dart';
import 'package:swapi_planets/feature/planets/domain/model/planet_model.dart';

/// Single planet row in the list.
/// Single Responsibility: renders one planet — name + film chips.
class PlanetListItem extends StatelessWidget {
  const PlanetListItem({
    super.key,
    required this.planet,
    required this.onTap,
  });

  final PlanetModel planet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PlanetHeader(planet: planet),
                if (planet.films.isNotEmpty) ...[
                  SizedBox(height: 10.h),
                  _FilmChips(films: planet.films),
                ],
              ],
            ),
          ),
        ),
      );
}

class _PlanetHeader extends StatelessWidget {
  const _PlanetHeader({required this.planet});
  final PlanetModel planet;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          // Planet icon
          Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.highlight.withOpacity(0.6),
                  AppTheme.accent.withOpacity(0.9),
                ],
              ),
            ),
            child: Icon(Icons.public, size: 22.r, color: Colors.white),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  planet.name,
                  style: context.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Climate: ${planet.climate}  ·  Terrain: ${planet.terrain}',
                  style: context.textTheme.bodySmall
                      ?.copyWith(color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppTheme.highlight, size: 20.r),
        ],
      );
}

class _FilmChips extends StatelessWidget {
  const _FilmChips({required this.films});
  final List<String> films;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 6.w,
        runSpacing: 4.h,
        children: films
            .map(
              (title) => Chip(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                labelPadding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                label: Text(
                  title,
                  style: context.textTheme.labelSmall
                      ?.copyWith(fontSize: 10.sp),
                ),
                backgroundColor: AppTheme.highlight.withOpacity(0.15),
                side: BorderSide(
                    color: AppTheme.highlight.withOpacity(0.4), width: 0.5),
              ),
            )
            .toList(),
      );
}
