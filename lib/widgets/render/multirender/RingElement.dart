import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_demo/widgets/render/multirender/RingWidget.dart';
import 'package:flutter_demo/widgets/render/leafrender/SixStarElement.dart';

/// 复制自[MultiChildRenderObjectElement], 没有做逻辑上的修改
class RingElement extends RenderObjectElement {
  RingElement(RingWidget widget)
      : assert(!debugChildrenHaveDuplicateKeys(widget, widget.children)),
        super(widget);

  @override
  RingWidget get widget => super.widget;

  /// The current list of children of this element.
  ///
  /// This list is filtered to hide elements that have been forgotten (using
  /// [forgetChild]).
  @protected
  @visibleForTesting
  Iterable<Element> get children => _children.where((Element child) => !_forgottenChildren.contains(child));

  List<Element> _children;

  // We keep a set of forgotten children to avoid O(n^2) work walking _children
  // repeatedly to remove children.
  final Set<Element> _forgottenChildren = HashSet<Element>();

  /// attachRenderObject时调用 <= updateChild 中 inflateWidget
  @override
  void insertChildRenderObject(RenderObject child, Element slot) {
    final ContainerRenderObjectMixin<RenderObject, ContainerParentDataMixin<RenderObject>> renderObject = this.renderObject;
    assert(renderObject.debugValidateChild(child));
    // 代替了Widget.updateRenderObject
    renderObject.insert(child, after: slot?.renderObject);
    assert(renderObject == this.renderObject);
  }

  /// _updateSlot时调用 <= updateChild 中 updateSlotForChild
  @override
  void moveChildRenderObject(RenderObject child, dynamic slot) {
    final ContainerRenderObjectMixin<RenderObject, ContainerParentDataMixin<RenderObject>> renderObject = this.renderObject;
    assert(child.parent == renderObject);
    // 代替了Widget.updateRenderObject
    renderObject.move(child, after: slot?.renderObject);
    assert(renderObject == this.renderObject);
  }

  /// detachRenderObject时调用 <= updateChild 中 deactivateChild
  @override
  void removeChildRenderObject(RenderObject child) {
    final ContainerRenderObjectMixin<RenderObject, ContainerParentDataMixin<RenderObject>> renderObject = this.renderObject;
    assert(child.parent == renderObject);
    // 代替了Widget.updateRenderObject
    renderObject.remove(child);
    assert(renderObject == this.renderObject);
  }

  /// TODO 暂时未搞清楚具体意图, 初步看是与设定GlobalKey的Widget的缓存复用有关
  @override
  void forgetChild(Element child) {
    assert(_children.contains(child));
    assert(!_forgottenChildren.contains(child));
    _forgottenChildren.add(child);
  }

  /// 提供遍历children方法给framework类update时调用
  @override
  void visitChildren(ElementVisitor visitor) {
    for (Element child in _children) {
      if (!_forgottenChildren.contains(child)) visitor(child);
    }
  }

  /// 新创建Element时调用
  @override
  void mount(Element parent, dynamic newSlot) {
    super.mount(parent, newSlot);
    _children = List<Element>(widget.children.length);
    Element previousChild;
    for (int i = 0; i < _children.length; i += 1) {
      // 可能包含diff方法: updateChild
      final Element newChild = inflateWidget(widget.children[i], previousChild);
      _children[i] = newChild;
      previousChild = newChild;
    }
  }

  @override
  void update(RingWidget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    // 对于LeafRenderObjectElement, 这里是updateChild;
    // 在MultiChildRenderObjectElement里, 是updateChildren
    _children = updateChildren(_children, widget.children, forgottenChildren: _forgottenChildren);
    _forgottenChildren.clear();
  }

  /// 什么都不改, 只是为了与[SixStarElement]作对比
  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    return super.debugDescribeChildren();
  }
}
