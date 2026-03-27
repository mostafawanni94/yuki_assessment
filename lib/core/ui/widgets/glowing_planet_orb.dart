import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swapi_planets/core/theme/app_colors.dart';

/// Animated glowing planet sphere.
/// Used in list items AND as detail screen hero.
/// Single Responsibility: visual orb only.
class GlowingPlanetOrb extends StatefulWidget {
  const GlowingPlanetOrb({
    super.key,
    required this.size,
    required this.colors,
    this.heroTag,
    this.animate = true,
  });

  final double size;
  final List<Color> colors;
  final String? heroTag;
  final bool animate;

  @override
  State<GlowingPlanetOrb> createState() => _GlowingPlanetOrbState();
}

class _GlowingPlanetOrbState extends State<GlowingPlanetOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _pulse = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    if (widget.animate) _ctrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orb = AnimatedBuilder(
      animation: _pulse,
      builder: (_, child) => Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(-0.3, -0.3),
            colors: [
              widget.colors.first.withOpacity(0.9),
              widget.colors.last,
              AppColors.current.bg,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: widget.colors.first
                  .withOpacity(0.35 * _pulse.value),
              blurRadius: widget.size * 0.6,
              spreadRadius: widget.size * 0.05,
            ),
          ],
        ),
        child: child,
      ),
      child: _RingOverlay(size: widget.size, color: widget.colors.first),
    );

    if (widget.heroTag == null) return orb;
    return Hero(tag: widget.heroTag!, child: orb);
  }
}

/// Subtle equatorial ring drawn on top of the orb.
class _RingOverlay extends StatelessWidget {
  const _RingOverlay({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _RingPainter(color: color.withOpacity(0.25)),
        child: SizedBox(width: size, height: size),
      );
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.05;

    canvas.drawOval(
      Rect.fromCenter(
        center: size.center(Offset.zero),
        width: size.width * 0.85,
        height: size.height * 0.18,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.color != color;
}
