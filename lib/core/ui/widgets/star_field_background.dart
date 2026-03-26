import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:swapi_planets/core/theme/app_colors.dart';

/// Parallax star-field painted behind the app bar.
/// Single Responsibility: decorative background only.
class StarFieldBackground extends StatefulWidget {
  const StarFieldBackground({super.key, this.starCount = 120});
  final int starCount;

  @override
  State<StarFieldBackground> createState() => _StarFieldBackgroundState();
}

class _StarFieldBackgroundState extends State<StarFieldBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<_Star> _stars;

  @override
  void initState() {
    super.initState();
    final rng = math.Random(42); // fixed seed → deterministic
    _stars = List.generate(
      widget.starCount,
      (i) => _Star(
        x: rng.nextDouble(),
        y: rng.nextDouble(),
        r: rng.nextDouble() * 1.5 + 0.3,
        opacity: rng.nextDouble() * 0.6 + 0.2,
        twinkleOffset: rng.nextDouble(),
      ),
    );
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => CustomPaint(
          painter: _StarPainter(stars: _stars, tick: _ctrl.value),
          child: const SizedBox.expand(),
        ),
      );
}

class _Star {
  const _Star({
    required this.x,
    required this.y,
    required this.r,
    required this.opacity,
    required this.twinkleOffset,
  });
  final double x, y, r, opacity, twinkleOffset;
}

class _StarPainter extends CustomPainter {
  const _StarPainter({required this.stars, required this.tick});
  final List<_Star> stars;
  final double tick;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final s in stars) {
      final twinkle = (math.sin(
                  (tick + s.twinkleOffset) * math.pi * 2) *
              0.3 +
          0.7);
      paint.color = AppColors.textPrimary
          .withOpacity(s.opacity * twinkle);
      canvas.drawCircle(
        Offset(s.x * size.width, s.y * size.height),
        s.r,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StarPainter old) => old.tick != tick;
}
