import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// RenderBox内部实现了RenderObject要求必须重写的几个方法, 并提供了笛卡尔二维坐标系
/// [CustomPaint]继承自[SingleChildRenderObjectWidget]: 与完全自定义的RenderBox的相比, 缺少了一自定义的API, 例如不能指定isRepaintBoundary
///
/// 四部分比较重要的点:
/// 1. [layout]和[paint], [performLayout]和[performResize]
/// 2. [_paint], [_paintColor], [_starSize]
/// 3. [isRepaintBoundary]
/// 4. [hitTest], [hitTestSelf], [hitTestChildren]
class SixStarObject extends RenderBox {
  /// 画笔
  final Paint _paint = Paint()
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke // 画线, 不填充包裹路径
    ..isAntiAlias = true // 抗锯齿
    ..strokeCap = StrokeCap.round // 线条端点样式
    ..strokeJoin = StrokeJoin.round; // 线条交汇处样式

  /// 属性1
  Color _paintColor;

  set paintColor(Color value) {
    if (value == _paintColor) return;
    _paintColor = value;
    // 在属性变化时更新PipelineOwner的待paint待更新列表: PipelineOwner._nodesNeedingPaint.add(this);
    markNeedsPaint();
  }

  /// 属性2, 因为RenderObject是复用的, 所以必须自己维护
  double _starSize;

  set starSize(value) {
    if (_starSize == value) {
      return;
    }
    _starSize = value;
    // 在属性变化时更新PipelineOwner的待layout列表: PipelineOwner._nodesNeedingLayout.add(this);
    markNeedsLayout();
  }

  SixStarObject(this._paintColor, this._starSize);

  /// 重写为true或者用[RepaintBoundary]包裹该Widget时会规定此Widget不会影响父布局, 如果不重写可能会出现相对于父布局的offset偏移
  /// 在[markNeedsPaint]时会判断此属性, 如果false会调用[parent.markNeedsPaint]
  ///
  /// [isRepaintBoundary] 绘制边界
  /// [relayoutBoundary] 布局边界
  @override
  bool get isRepaintBoundary => true;

  /// 通过查看兄弟类RenderProxyBox源码发现: layout是处理的内部Size, 流程基本是相同的, 所以这里不用重写, 具体的布局算法子类应该通过重写performResize() 和 performLayout()两个方法来实现
  /// layout中最后会调用[markNeedsPaint]
  ///
  /// [constraints] 指父节点对子节点的大小约束, 根据父节点的布局逻辑确定(BoxConstraints)
  /// [parentUsesSize] 用于确定[relayoutBoundary], 表示子节点的布局变化是否影响父节点
  @override
  void layout(Constraints constraints, {bool parentUsesSize = false}) {
    super.layout(constraints, parentUsesSize: parentUsesSize);
  }

  /// [offset]是取自父节点的[BoxParentData], 所以设置[isRepaintBoundary]为true后不再有offset
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

  /// [performLayout]和[performResize]都是在[layout]中被调用的
  /// 如果[sizedByParent]为false则必须重写此方法, 否则红屏
  @override
  void performLayout() {
    size = constraints.constrain(Size(_starSize, _starSize));
  }

  /// 只有[sizedByParent]为true,即父布局size改变引起当前resize时, [performResize]才会被调用, 而[performLayout]是必定会被调用
  @override
  void performResize() {
    super.performResize();
  }

  @override
  bool get sizedByParent => false;

  /// onTap判断
  @override
  bool hitTest(BoxHitTestResult result, {@required Offset position}) {
    return super.hitTest(result, position: position);
  }

  /// Used by [hitTest]: 作为叶子widget, 想要监听onTap就必须return true
  /// 只影响GestureDetector的behavior是deferToChild方式的表现, 不影响HitTestBehavior.opaque
  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  /// Used by [hitTest]: 如果有child时需要重写
  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    return super.hitTestChildren(result, position: position);
  }
}
