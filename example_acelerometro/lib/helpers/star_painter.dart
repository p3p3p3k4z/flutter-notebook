// TODO Implement this library.
// ════════════════════════════════════════════════════════════════════
//  CAPA 6 — HELPERS
//  lib/helpers/star_painter.dart
//  Modelo StarObstacle + CustomPainter para dibujar estrellas.
// ════════════════════════════════════════════════════════════════════

import 'dart:math';
import 'package:flutter/material.dart';

// ── Modelo de datos ───────────────────────────────────────────────
class StarObstacle {
  final double xF;
  final double yF;
  final double size;

  const StarObstacle({required this.xF, required this.yF, required this.size});
}

// ── CustomPainter: dibuja una estrella de 5 puntas ────────────────
class StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black45
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    canvas.drawPath(_buildStarPath(size), paint);
  }

  Path _buildStarPath(Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double outerR = size.width / 2;
    final double innerR = outerR * 0.40;
    final Path path = Path();

    for (int i = 0; i < 5; i++) {
      final double outerAngle = (i * 72 - 90) * pi / 180;
      final double innerAngle = ((i * 72 + 36) - 90) * pi / 180;

      final Offset outerPt = Offset(
        cx + outerR * cos(outerAngle),
        cy + outerR * sin(outerAngle),
      );
      final Offset innerPt = Offset(
        cx + innerR * cos(innerAngle),
        cy + innerR * sin(innerAngle),
      );

      if (i == 0) {
        path.moveTo(outerPt.dx, outerPt.dy);
      } else {
        path.lineTo(outerPt.dx, outerPt.dy);
      }
      path.lineTo(innerPt.dx, innerPt.dy);
    }

    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
