import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swapi_planets/core/theme/app_colors.dart';

class PlanetsLoadingShimmer extends StatefulWidget {
  const PlanetsLoadingShimmer({super.key, this.itemCount = 7});
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
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          itemCount: widget.itemCount,
          itemBuilder: (_, i) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _ShimmerCard(t: _anim.value),
          ),
        ),
      );
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard({required this.t});
  final double t;

  @override
  Widget build(BuildContext context) {
    // High-contrast shimmer: gold tint on bgCardLight
    final shimmer = Color.lerp(
      AppColors.current.bgCardLight,
      AppColors.current.primaryDim.withOpacity(0.3),
      t,
    )!;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.current.bgCard,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.current.border, width: 0.5),
      ),
      child: Row(children: [
        // Circle placeholder
        Container(
          width: 52.r, height: 52.r,
          decoration: BoxDecoration(shape: BoxShape.circle, color: shimmer),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _Bar(widthFactor: 0.55, color: shimmer, height: 14.h),
            SizedBox(height: 8.h),
            _Bar(widthFactor: 0.80, color: shimmer, height: 10.h),
            SizedBox(height: 8.h),
            Row(children: [
              Expanded(child: _Bar(widthFactor: 0.5, color: shimmer, height: 18.h)),
              SizedBox(width: 8.w),
              Expanded(child: _Bar(widthFactor: 0.5, color: shimmer, height: 18.h)),
            ]),
          ]),
        ),
      ]),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.widthFactor, required this.color, required this.height});
  final double widthFactor;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) => FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          height: height,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(6.r)),
        ),
      );
}
