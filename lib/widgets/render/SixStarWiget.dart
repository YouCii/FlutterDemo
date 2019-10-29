import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/render/SixStarElement.dart';
import 'package:flutter_demo/widgets/render/SixStarObject.dart';

/// 自定义RenderObject
class SixStarWidget extends LeafRenderObjectWidget {
  final Color _paintColor;
  final double _starSize;

  SixStarWidget(this._paintColor, this._starSize);

  @override
  LeafRenderObjectElement createElement() {
    return SixStarElement(this);
  }

  @override
  RenderObject createRenderObject(BuildContext context) {
    return SixStarObject(_paintColor, _starSize);
  }

  @override
  void updateRenderObject(BuildContext context, SixStarObject renderObject) {
    renderObject
      ..paintColor = _paintColor
      ..starSize = _starSize;
  }
}
