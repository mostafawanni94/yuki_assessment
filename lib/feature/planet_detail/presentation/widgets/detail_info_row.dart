import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swapi_planets/core/theme/app_theme.dart';

/// Single label + value row in the detail card.
/// Single Responsibility: renders one data field only.
class DetailInfoRow extends StatelessWidget {
  const DetailInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16.r, color: AppTheme.highlight),
              SizedBox(width: 8.w),
            ],
            SizedBox(
              width: 110.w,
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            Expanded(
              child: Text(
                value.isEmpty || value == 'unknown' || value == 'n/a'
                    ? '—'
                    : value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      );
}
