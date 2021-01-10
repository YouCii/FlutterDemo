import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/render/leafrender/SixStarElement.dart';
import 'package:flutter_demo/widgets/render/leafrender/SixStarRenderObject.dart';

/// 使用自定义RenderObject的Widget
/// 因为我们没有修改Element, 所以其实可以直接继承[LeafRenderObjectWidget]
class SixStarWidget extends RenderObjectWidget {
  final Color _paintColor;
  final double _starSize;

  SixStarWidget(this._paintColor, this._starSize);

  /// 在其父Widget对应的Element的updateChild方法中调用
  @override
  SixStarElement createElement() {
    return SixStarElement(this);
  }

  /// 在mount方法中调用
  @override
  RenderObject createRenderObject(BuildContext context) {
    return SixStarRenderObject(_paintColor, _starSize);
  }

  /// 在widget重建时会执行此方法
  /// 这里的renderObject是复用的，如果这里不更新RenderObject, 那么UI不会改变
  @override
  void updateRenderObject(BuildContext context, SixStarRenderObject renderObject) {
    renderObject
      ..paintColor = _paintColor
      ..starSize = _starSize;
  }
}
