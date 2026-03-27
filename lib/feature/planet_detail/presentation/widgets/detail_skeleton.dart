import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swapi_planets/core/theme/app_colors.dart';

/// Skeleton loading for detail screen — mirrors the actual layout.
class DetailSkeleton extends StatefulWidget {
  const DetailSkeleton({super.key});

  @override
  State<DetailSkeleton> createState() => _DetailSkeletonState();
}

class _DetailSkeletonState extends State<DetailSkeleton>
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
        builder: (_, __) {
          final shimmer = Color.lerp(
            AppColors.current.bgCardLight,
            AppColors.current.primaryDim.withOpacity(0.3),
            _anim.value,
          )!;
          return SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(children: [
              // Hero orb placeholder
              _OrbSkeleton(shimmer: shimmer),
              SizedBox(height: 8.h),
              // Section cards
              _CardSkeleton(shimmer: shimmer, rows: 4),
              _CardSkeleton(shimmer: shimmer, rows: 4),
              _CardSkeleton(shimmer: shimmer, rows: 3),
            ]),
          );
        },
      );
}

class _OrbSkeleton extends StatelessWidget {
  const _OrbSkeleton({required this.shimmer});
  final Color shimmer;

  @override
  Widget build(BuildContext context) => Container(
        height: 260.h,
        width: double.infinity,
        color: AppColors.current.bg,
        child: Center(
          child: Container(
            width: 120.r, height: 120.r,
            decoration: BoxDecoration(shape: BoxShape.circle, color: shimmer),
          ),
        ),
      );
}

class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton({required this.shimmer, required this.rows});
  final Color shimmer;
  final int rows;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 10.h),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.current.bgCard,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.current.border, width: 0.5),
          ),
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section header
              Row(children: [
                Container(width: 28.r, height: 28.r,
                    decoration: BoxDecoration(
                        color: shimmer, borderRadius: BorderRadius.circular(8.r))),
                SizedBox(width: 10.w),
                Container(width: 100.w, height: 12.h,
                    decoration: BoxDecoration(
                        color: shimmer, borderRadius: BorderRadius.circular(4.r))),
              ]),
              Divider(height: 16.h, color: AppColors.current.divider),
              ...List.generate(rows, (i) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Row(children: [
                  Container(width: 100.w, height: 10.h,
                      decoration: BoxDecoration(color: shimmer.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(4.r))),
                  SizedBox(width: 16.w),
                  Container(width: (120 - i * 10).w, height: 10.h,
                      decoration: BoxDecoration(color: shimmer,
                          borderRadius: BorderRadius.circular(4.r))),
                ]),
              )),
            ],
          ),
        ),
      );
}
