import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swapi_planets/core/theme/app_colors.dart';
import 'package:swapi_planets/core/theme/theme_cubit.dart';

/// Cycles through available themes on tap.
/// Shows theme name as tooltip.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ThemeCubit, AppColorScheme>(
        builder: (ctx, scheme) {
          final cubit = ctx.read<ThemeCubit>();
          final icon = _iconFor(scheme);
          return Tooltip(
            message: 'Theme: ${scheme.name}  (tap to change)',
            child: IconButton(
              icon: Icon(icon, size: 20.r,
                  color: scheme.textSecondary),
              onPressed: cubit.nextTheme,
            ),
          );
        },
      );

  IconData _iconFor(AppColorScheme s) {
    if (s == lightTheme) return Icons.light_mode_rounded;
    if (s == sithTheme) return Icons.whatshot_rounded;
    return Icons.dark_mode_rounded; // space (default)
  }
}
