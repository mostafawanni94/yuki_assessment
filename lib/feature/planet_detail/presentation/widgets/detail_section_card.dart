import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swapi_planets/core/theme/app_theme.dart';

/// Section card with a title header and arbitrary child content.
/// Single Responsibility: section layout only.
class DetailSectionCard extends StatelessWidget {
  const DetailSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.icon,
  });

  final String title;
  final Widget child;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(title: title, icon: icon),
              Divider(height: 16.h),
              child,
            ],
          ),
        ),
      );
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.icon});
  final String title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18.r, color: AppTheme.highlight),
            SizedBox(width: 8.w),
          ],
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.highlight,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
          ),
        ],
      );
}
