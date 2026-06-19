// orb_painter.dart
import 'dart:math';
import 'package:flutter/material.dart';

class OrbPainter extends CustomPainter {
  final double time;
  OrbPainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final R = size.width * 0.38;

    // Capas de ondas (de afuera hacia adentro)
    final layers = [
      (r: R,       opacity: 0.55, waveN: 5, phase: 0.0),
      (r: R * 0.8, opacity: 0.45, waveN: 6, phase: 1.2),
      (r: R * 0.6, opacity: 0.50, waveN: 7, phase: 2.4),
      (r: R * 0.4, opacity: 0.60, waveN: 8, phase: 0.8),
    ];

    for (final (i, l) in layers.indexed) {
      final breathe = 1.0 + sin(time * 0.9 + i * 0.7) * 0.03;
      final path = Path();
      const steps = 120;

      for (int s = 0; s <= steps; s++) {
        final a = (s / steps) * 2 * pi;
        final ripple =
            sin(a * l.waveN + time * (1.1 + i * 0.2) + l.phase) * 0.18 +
            sin(a * (l.waveN + 1) - time * 0.7 + l.phase * 1.3) * 0.09;
        final pr = l.r * breathe * (1 + ripple);
        final px = cx + cos(a) * pr;
        final py = cy + sin(a) * pr;
        s == 0 ? path.moveTo(px, py) : path.lineTo(px, py);
      }
      path.close();

      final paint = Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.25),
          colors: [
            Colors.purple.withOpacity(l.opacity),
            Colors.deepPurple.withOpacity(0.05),
          ],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: l.r));

      canvas.drawPath(path, paint);
    }

    // Anillo exterior brillante
    final ringPath = Path();
    for (int s = 0; s <= 200; s++) {
      final a = (s / 200) * 2 * pi;
      final noise = sin(a * 5 + time * 1.2) * 0.05 +
                    sin(a * 9 - time * 0.8) * 0.03;
      final pr = R * (1 + noise);
      final px = cx + cos(a) * pr;
      final py = cy + sin(a) * pr;
      s == 0 ? ringPath.moveTo(px, py) : ringPath.lineTo(px, py);
    }
    ringPath.close();

    canvas.drawPath(
      ringPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..shader = const LinearGradient(
          colors: [
            Color(0xAAC896FF),
            Color(0x885050FF),
            Color(0xAA50B4FF),
          ],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: R)),
    );
  }

  @override
  bool shouldRepaint(OrbPainter old) => old.time != time;
}