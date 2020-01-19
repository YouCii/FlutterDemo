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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("自定义MultiRenderObject"),
      ),
      body: Center(
        child: RingWidget(
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              color: Colors.deepOrange,
            ),
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
            Container(
              width: 40,
              height: 40,
              color: Colors.greenAccent,
            ),
          ],
        ),
      ),
    );
  }
}
