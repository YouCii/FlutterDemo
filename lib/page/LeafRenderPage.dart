import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/render/custompaint/SixStarPaint.dart';
import 'package:flutter_demo/widgets/render/leafrender/SixStarWidget.dart';
import 'dart:math';

class LeafRenderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LeafRenderState();
  }
}

class _LeafRenderState extends State<LeafRenderPage> {
  Color _color1 = Colors.deepOrange;
  Color _color2 = Colors.greenAccent;
  double _size1 = 0xbb;
  double _size2 = 0xbb;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("自定义LeafRenderObject"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _decorate(SixStarWidget(_color1, _size1), () {
            _color1 = Color(Random().nextInt(0xffffff) + 0xff000000);
            _size1 = Random().nextInt(0x88) + 0x88.toDouble();
          }),
          _decorate(SixStarPaint(_color2, _size2), () {
            _color2 = Color(Random().nextInt(0xffffff) + 0xff000000);
            _size2 = Random().nextInt(0x88) + 0x88.toDouble();
          }),
        ],
      ),
    );
  }

  /// 抽出重复代码
  Widget _decorate(Widget toShow, Function onTap) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onTap: () {
          setState(() {
            onTap();
          });
        },
        child: Align(
          alignment: Alignment.center,
          child: toShow,
        ),
      ),
    );
  }
}
