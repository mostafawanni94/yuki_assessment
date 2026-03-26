import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swapi_planets/core/theme/app_theme.dart';

/// Shimmer skeleton shown while the first page loads.
/// Single Responsibility: loading placeholder only.
class PlanetsLoadingShimmer extends StatefulWidget {
  const PlanetsLoadingShimmer({super.key, this.itemCount = 7});
  final int itemCount;

  @override
  State<PlanetsLoadingShimmer> createState() => _PlanetsLoadingShimmerState();
}

class _PlanetsLoadingShimmerState extends State<PlanetsLoadingShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
        parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animation,
        builder: (_, __) => ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.itemCount,
          itemBuilder: (_, __) => _ShimmerCard(opacity: _animation.value),
        ),
      );
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard({required this.opacity});
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final base = AppTheme.accent.withOpacity(0.3 + opacity * 0.3);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Row(children: [
          // Avatar placeholder
          Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(shape: BoxShape.circle, color: base),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Bar(width: 0.5, color: base),
                SizedBox(height: 6.h),
                _Bar(width: 0.75, color: base),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.width, required this.color});
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) => FractionallySizedBox(
        widthFactor: width,
        child: Container(
          height: 10.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      );
}
