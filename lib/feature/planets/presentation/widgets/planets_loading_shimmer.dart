import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swapi_planets/core/theme/app_colors.dart';

/// Skeleton loading shimmer matching the planet card layout.
class PlanetsLoadingShimmer extends StatefulWidget {
  const PlanetsLoadingShimmer({super.key, this.itemCount = 8});
  final int itemCount;

  @override
  State<PlanetsLoadingShimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<PlanetsLoadingShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          itemCount: widget.itemCount,
          itemBuilder: (_, i) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _ShimmerCard(t: _anim.value, delay: i * 0.1),
          ),
        ),
      );
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard({required this.t, required this.delay});
  final double t;
  final double delay;

  Color get _base {
    final v = ((t - delay).clamp(0.0, 1.0));
    return AppColors.bgCardLight.withOpacity(0.4 + v * 0.4);
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Row(children: [
          // Orb placeholder
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(shape: BoxShape.circle, color: _base),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Bar(width: 0.55, color: _base, height: 14.h),
                SizedBox(height: 6.h),
                _Bar(width: 0.80, color: _base, height: 10.h),
                SizedBox(height: 8.h),
                Row(children: [
                  _Bar(width: 0.28, color: _base, height: 18.h),
                  SizedBox(width: 6.w),
                  _Bar(width: 0.28, color: _base, height: 18.h),
                ]),
              ],
            ),
          ),
        ]),
      );
}

class _Bar extends StatelessWidget {
  const _Bar({required this.width, required this.color, required this.height});
  final double width;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) => FractionallySizedBox(
        widthFactor: width,
        child: Container(
          height: height,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(6.r)),
        ),
      );
}
