import 'dart:math';

import 'package:flutter/material.dart';

/// CustomPaint只是为了方便开发者封装的一个代理类，通过内部[RenderCustomPaint]的paint方法将[Canvas]和[CustomPainter]连接起来实现了最终的绘制
class SixStarPaint extends CustomPaint {
  final Color _paintColor;
  final double _starSize;

  SixStarPaint(this._paintColor, this._starSize);

  @override
  CustomPainter get painter => _SixStarPainter(_paintColor);

  @override
  Size get size => Size(_starSize, _starSize);
}

class _SixStarPainter extends CustomPainter {
  Paint _paint;

  _SixStarPainter(Color paintColor) {
    _paint = Paint()
      ..color = paintColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double _starSize = size.width;

    Offset point1Top = Offset(_starSize / 2, 0);
    Offset point1Left = Offset(_starSize * (2 - sqrt(3)) / 4, _starSize * 3 / 4);
    Offset point1Right = Offset(_starSize * (2 + sqrt(3)) / 4, _starSize * 3 / 4);

    Offset point2Left = Offset(_starSize * (2 - sqrt(3)) / 4, _starSize * 1 / 4);
    Offset point2Right = Offset(_starSize * (2 + sqrt(3)) / 4, _starSize * 1 / 4);
    Offset point2Bottom = Offset(_starSize / 2, _starSize);

    canvas.drawLine(point1Top, point1Left, _paint);
    canvas.drawLine(point1Left, point1Right, _paint);
    canvas.drawLine(point1Right, point1Top, _paint);

    canvas.drawLine(point2Left, point2Bottom, _paint);
    canvas.drawLine(point2Bottom, point2Right, _paint);
    canvas.drawLine(point2Right, point2Left, _paint);

    canvas.drawCircle(Offset(_starSize / 2, _starSize / 2), _starSize / 2, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
