import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swapi_planets/core/connectivity/connectivity_cubit.dart';
import 'package:swapi_planets/core/theme/app_colors.dart';
import 'package:swapi_planets/core/theme/app_text_styles.dart';

/// Animated banner that slides in when offline, slides out when online.
class ConnectivityBanner extends StatelessWidget {
  const ConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ConnectivityCubit, bool>(
        builder: (_, isOnline) => AnimatedSlide(
          offset: isOnline ? const Offset(0, -1) : Offset.zero,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: AnimatedOpacity(
            opacity: isOnline ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
              color: AppColors.current.error,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off_rounded, size: 14.r, color: Colors.white),
                  SizedBox(width: 8.w),
                  Text(
                    'No internet connection',
                    style: AppTextStyles.labelLargeCurrent
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
