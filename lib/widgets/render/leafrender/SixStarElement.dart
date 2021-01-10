import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/render/leafrender/SixStarWidget.dart';
import 'package:flutter_demo/widgets/render/multirender/RingElement.dart';

/// 复制自[LeafRenderObjectElement], 没有做逻辑上的修改
class SixStarElement extends RenderObjectElement {
  SixStarElement(SixStarWidget widget) : super(widget);

  @override
  void insertChildRenderObject(RenderObject child, dynamic slot) {
    assert(false);
  }

  @override
  void moveChildRenderObject(RenderObject child, dynamic slot) {
    assert(false);
  }

  @override
  void removeChildRenderObject(RenderObject child) {
    assert(false);
  }

  @override
  void forgetChild(Element child) {
    assert(false);
  }

  /// 什么都不改, 只是为了与[RingElement]作对比
  @override
  void visitChildren(visitor) {
    super.visitChildren(visitor);
  }

  /// 什么都不改, 只是为了与[RingElement]作对比
  @override
  void mount(Element parent, newSlot) {
    super.mount(parent, newSlot);
  }

  /// 什么都不改, 只是为了与[RingElement]作对比
  @override
  void update(RenderObjectWidget newWidget) {
    super.update(newWidget);
  }

}
