import 'dart:math';

import 'package:flutter/material.dart';

class SemiCircle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white10
      ..style = PaintingStyle.fill;

    final Path path = Path();

    path.moveTo(0, 0);
    path.arcTo(
      const Rect.fromLTWH(0, 0, 90, 100),
      pi,
      -pi,
      true,
    );
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
