import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_demo/widgets/render/multirender/RingElement.dart';
import 'package:flutter_demo/widgets/render/multirender/RingRenderObject.dart';

/// 其实绝大部分是复制了系统提供的[CustomMultiChildLayout]及其父类[MultiChildRenderObjectWidget]
/// 全部复制出来可以更清晰的把握内部原理
/// PS: [Row] 和 [Column] 均继承自 [MultiChildRenderObjectWidget]
class RingWidget extends RenderObjectWidget {
  /// If this list is going to be mutated, it is usually wise to put [Key]s on
  /// the widgets, so that the framework can match old configurations to new
  /// configurations and maintain the underlying render objects.
  final List<Widget> children;

  /// childrenList没有重写
  RingWidget({Key key, this.children = const <Widget>[]})
      : assert(children != null),
        assert(() {
          final int index = children.indexOf(null);
          if (index >= 0) {
            throw FlutterError("$runtimeType的子View不能包含null, 但下标$index处是null了, 快tm检查一下吧!");
          }
          return true;
        }()),
        super(key: key);

  @override
  RingElement createElement() => RingElement(this);

  @override
  RingRenderObject createRenderObject(BuildContext context) {
    return RingRenderObject();
  }

  @override
  void updateRenderObject(BuildContext context, RingRenderObject renderObject) {
    // TODO
  }
}
