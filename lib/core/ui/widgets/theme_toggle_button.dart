import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swapi_planets/core/theme/app_colors.dart';
import 'package:swapi_planets/core/theme/theme_cubit.dart';

/// Cycles themes with haptic feedback + animated icon swap.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ThemeCubit, AppColorScheme>(
        builder: (ctx, scheme) {
          final cubit = ctx.read<ThemeCubit>();
          return Tooltip(
            message: 'Theme: ${scheme.name}  (tap to change)',
            child: IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) => RotationTransition(
                  turns: anim,
                  child: FadeTransition(opacity: anim, child: child),
                ),
                child: Icon(
                  _iconFor(scheme),
                  key: ValueKey(scheme.name),
                  size: 20.r,
                  color: scheme.primary,  // uses primary color, stands out
                ),
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();  // tactile feedback
                cubit.nextTheme();
              },
            ),
          );
        },
      );

  IconData _iconFor(AppColorScheme s) {
    if (s == lightTheme) return Icons.light_mode_rounded;
    if (s == sithTheme) return Icons.whatshot_rounded;
    return Icons.dark_mode_rounded;
  }
}
