import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 实现目标:
/// 1. 所有child按角度平均分布到一个圆环上, 以圆环最高点为起点, 顺时针排列
/// 2. 保证所有的child不能重叠
/// 3. 以子View中最大的宽高为标准计算ViewGroup宽高, 即较小子view的宽高也按照子View中最大的宽高计算
///
/// ps: 也可以不使用[RenderBox], 使用[RenderCustomMultiChildLayoutBox]实现, 它通过[MultiChildLayoutDelegate]实现, 与[CustomPaint]的设计思路差不多
class RingRenderObject extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>, RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  /// 画笔
  final Paint _paint = Paint()
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke // 画线, 不填充包裹路径
    ..isAntiAlias = true // 抗锯齿
    ..strokeCap = StrokeCap.round // 线条端点样式
    ..strokeJoin = StrokeJoin.round // 线条交汇处样式
    ..color = Colors.red; // 颜色

  RingRenderObject({List<RenderBox> children}) {
    addAll(children);
  }

  /// [RenderCustomMultiChildLayoutBox]和[Flex]均重写, 判断了自定义的[ParentData]
  /// [ParentData]中存储了父布局提供给当前节点的参数, 包括偏移量以及下一个节点等
  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  /// [RenderCustomMultiChildLayoutBox]和[Flex]均使用了[RenderBoxContainerDefaultsMixin]的[defaultPaint]方法
  /// 其中[Flex]在[overflow]设置特殊值时进行了其他策略, 没有特殊要求前我们先直接使用[defaultPaint]
  @override
  void paint(PaintingContext context, Offset offset) {
    double radius = _getRadius();
    context.canvas
      ..translate(offset.dx, offset.dy)
      ..drawCircle(_getCircleCenter(radius), radius, _paint);
    defaultPaint(context, offset);
  }

  /// 根据父类方法中的注释，子类不应该重写此方法，
  /// 子类应该通过重写会在此方法中被调用的performResize()和performLayout()来完成具体的layout操作
  @override
  void layout(Constraints constraints, {bool parentUsesSize = false}) {
    super.layout(constraints, parentUsesSize: parentUsesSize);
  }

  @override
  void performLayout() {
    _layoutChild();

    double radius = _getRadius();
    Offset circleCenter = _getCircleCenter(radius);
    size = constraints.constrain(Size(circleCenter.dx * 2, circleCenter.dx * 2));
    _positionChild(radius, circleCenter);
  }

  /// 遍历调用child.layout
  void _layoutChild() {
    RenderBox child = firstChild;
    while (child != null) {
      BoxConstraints innerConstraints = BoxConstraints(
        maxWidth: constraints.maxWidth,
        minWidth: constraints.minWidth,
        maxHeight: constraints.maxHeight,
        minHeight: constraints.minHeight,
      );
      // parentUsesSize表示child的layout变化影响this
      child.layout(innerConstraints, parentUsesSize: true);

      final MultiChildLayoutParentData childParentData = child.parentData;
      child = childParentData.nextSibling;
    }
  }

  /// 遍历把child放在各自偏移量上
  /// 注意, sin和cos的入参都是弧度, 不是角度
  void _positionChild(double radius, Offset circleCenter) {
    double angelLevel = 2 * pi / childCount;

    RenderBox child = firstChild;
    int index = 0;
    double angle = 0;
    double positionDx = 0;
    double positionDy = 0;

    while (child != null) {
      final MultiChildLayoutParentData childParentData = child.parentData;
      positionDx = circleCenter.dx + radius * sin(angle);
      positionDy = circleCenter.dy - radius * cos(angle);
      childParentData.offset = Offset(positionDx - child.size.width / 2, positionDy - child.size.height / 2);

      // 下一个child数据
      child = childParentData.nextSibling;
      index++;
      angle = angelLevel * index;
    }
  }

  /// 获取布局圆环圆心
  Offset _getCircleCenter(double radius) {
    double sizeOfWidget = radius / _indexOfBottom;
    return Offset(radius + sizeOfWidget / 2, radius + sizeOfWidget / 2);
  }

  /// 获取布局圆环半径 TODO 循环耗时待优化, 加缓存
  /// 注意, 获取child.size之前必须要执行过[child.layout]才可以
  double _getRadius() {
    double maxWidth = _getMaxSizeOfChildren(0, (RenderBox child, double extent) {
      return child.size.width;
    });
    double maxHeight = _getMaxSizeOfChildren(0, (RenderBox child, double extent) {
      return child.size.height;
    });
    double adaptSize = max(maxHeight, maxWidth);
    // index+1表示总个数, 直径/2返回半径
    return (_indexOfBottom + 1) * adaptSize / 2;
  }

  /// [sizedByParent]为false的话, 此方法不用重写
  @override
  void performResize() {
    super.performResize();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  bool get sizedByParent => false;

  /// 计算固有最大高度 TODO width为什么可以传给子View计算?
  @override
  double computeMaxIntrinsicHeight(double width) {
    return (_indexOfBottom + 1) *
        _getMaxSizeOfChildren(width, (RenderBox child, double extent) {
          return child.getMaxIntrinsicHeight(extent);
        });
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return (_indexOfBottom + 1) *
        _getMaxSizeOfChildren(height, (RenderBox child, double extent) {
          return child.getMaxIntrinsicWidth(extent);
        });
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return (_indexOfBottom + 1) *
        _getMaxSizeOfChildren(width, (RenderBox child, double extent) {
          return child.getMinIntrinsicHeight(extent);
        });
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return (_indexOfBottom + 1) *
        _getMaxSizeOfChildren(height, (RenderBox child, double extent) {
          return child.getMinIntrinsicWidth(extent);
        });
  }

  /// 根据childSize计算对应宽高: 返回children中最大的childSize
  double _getMaxSizeOfChildren(double extend, Function(RenderBox child, double extent) childSize) {
    double maxSize = 0.0;
    MultiChildLayoutParentData childParentData;
    RenderBox current = firstChild;
    while (current != null) {
      maxSize = max(maxSize, childSize(current, extend));
      childParentData = current.parentData;
      current = childParentData.nextSibling;
    }
    return maxSize;
  }

  /// 获取最下方index, ~/为向下取整
  int get _indexOfBottom => childCount ~/ 2;

  /// 内部 hitTestChildren || hitTestSelf
  @override
  bool hitTest(BoxHitTestResult result, {Offset position}) {
    return super.hitTest(result, position: position);
  }

  /// 在[hitTest]内部判断时优先判断[hitTestChildren], 所以此方法返回true只会在未点击到child时生效
  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  /// [RenderCustomMultiChildLayoutBox]和[Flex]均使用了[RenderBoxContainerDefaultsMixin.defaultHitTestChildren]方法
  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
