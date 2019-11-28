import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/render/SixStarElement.dart';
import 'package:flutter_demo/widgets/render/SixStarObject.dart';

/// 自定义RenderObject
class SixStarWidget extends LeafRenderObjectWidget {
  final Color _paintColor;
  final double _starSize;

  SixStarWidget(this._paintColor, this._starSize);

  /// 在其父Widget对应的Element的updateChild方法中调用
  @override
  LeafRenderObjectElement createElement() {
    return SixStarElement(this);
  }

  /// 在mount方法中调用
  @override
  RenderObject createRenderObject(BuildContext context) {
    return SixStarObject(_paintColor, _starSize);
  }

  /// 在widget重建时会执行此方法
  /// 这里的renderObject是复用的，如果这里不更新RenderObject, 那么UI不会改变
  @override
  void updateRenderObject(BuildContext context, SixStarObject renderObject) {
    renderObject
      ..paintColor = _paintColor
      ..starSize = _starSize;
  }
}
