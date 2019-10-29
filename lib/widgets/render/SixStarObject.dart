import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// RenderBox内部实现了RenderObject要求必须重写的几个方法，并提供了笛卡尔二维坐标系
class SixStarObject extends RenderBox {
  final Paint _paint = Paint()
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

  SixStarObject(this._paintColor, this._starSize);

  /// 必须重写为true或者用RepaintBoundary包裹，否则会出现offset偏移的问题
  @override
  bool get isRepaintBoundary => true;

  /// 通过查看RenderProxyBox源码发现：layout是处理的内部的Size，所以这里不用重写，在[markNeedsLayout]之前修改[size]即可
  @override
  void layout(Constraints constraints, {bool parentUsesSize = false}) {
    super.layout(constraints, parentUsesSize: parentUsesSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _paint.color = _paintColor;

    final canvas = context.canvas..translate(offset.dx, offset.dy);
    final width = size.width;

    Offset point1Top = Offset(width / 2, 0);
    Offset point1Left = Offset(width * (2 - sqrt(3)) / 4, width * 3 / 4);
    Offset point1Right = Offset(width * (2 + sqrt(3)) / 4, width * 3 / 4);

    Offset point2Left = Offset(width * (2 - sqrt(3)) / 4, width * 1 / 4);
    Offset point2Right = Offset(width * (2 + sqrt(3)) / 4, width * 1 / 4);
    Offset point2Bottom = Offset(width / 2, width);

    canvas.drawLine(point1Top, point1Left, _paint);
    canvas.drawLine(point1Left, point1Right, _paint);
    canvas.drawLine(point1Right, point1Top, _paint);

    canvas.drawLine(point2Left, point2Bottom, _paint);
    canvas.drawLine(point2Bottom, point2Right, _paint);
    canvas.drawLine(point2Right, point2Left, _paint);

    canvas.drawCircle(Offset(width / 2, width / 2), width / 2, _paint);
  }

  /// 必须重写此方法，否则红屏
  @override
  void performLayout() {
    size = constraints.constrain(Size(_starSize, _starSize));
  }

  /// 只有父布局size改变引起当前resize时才会调用，而performLayout是各种情况引起的resize都会调用
  @override
  void performResize() {
    super.performResize();
  }

  /// onTap判断
  @override
  bool hitTest(BoxHitTestResult result, {@required Offset position}) {
    return super.hitTest(result, position: position);
  }

  /// 作为叶子widget，如果想要监听onTap就必须return true
  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  /// 如果有child时需要重写
  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    return super.hitTestChildren(result, position: position);
  }

  /* Color */
  Color _paintColor;

  set paintColor(Color value) {
    if (value == _paintColor) return;
    _paintColor = value;
    markNeedsPaint();
  }

  /* widget size */
  double _starSize;

  set starSize(value) {
    if (_starSize == value) {
      return;
    }
    _starSize = value;
    markNeedsLayout();
  }
}
