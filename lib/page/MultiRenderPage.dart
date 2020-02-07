import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/render/custompaint/SixStarPaint.dart';
import 'package:flutter_demo/widgets/render/leafrender/SixStarWidget.dart';
import 'dart:math';

import 'package:flutter_demo/widgets/render/multirender/RingWidget.dart';

class MultiRenderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MultiRenderState();
  }
}

class _MultiRenderState extends State<MultiRenderPage> {
  final _widgets = <Widget>[
    Container(
      width: 40,
      height: 40,
      color: Colors.blueAccent,
    ),
    Container(
      width: 40,
      height: 40,
      color: Colors.amber,
    ),
    Container(
      width: 40,
      height: 40,
      color: Colors.purple,
    ),
  ];

  Widget _createWidget() {
    return Container(
      width: 40,
      height: 40,
      color: Color(Random().nextInt(0xffffff) + 0xff000000),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("自定义MultiRenderObject"),
      ),
      body: Center(
        child: GestureDetector(
          child: RingWidget(children: _widgets),
          onTap: () {
            setState(() {
              _widgets.add(_createWidget());
            });
          },
          onDoubleTap: () {
            setState(() {
              _widgets.removeLast();
            });
          },
        ),
      ),
    );
  }
}
