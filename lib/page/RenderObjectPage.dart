import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/render/SixStarPaint.dart';
import 'package:flutter_demo/widgets/render/SixStarWiget.dart';
import 'dart:math';

class RenderObjectPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RenderObjectState();
  }
}

class RenderObjectState extends State<RenderObjectPage> {
  Color _color1 = Colors.deepOrange;
  Color _color2 = Colors.greenAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("自定义RenderObject"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                _color1 = Color(Random().nextInt(0xffffffff) & 0xffffffff);
              });
            },
            child: Container(
              width: double.maxFinite,
              alignment: Alignment.center,
              child: SixStarWidget(_color1, 200),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _color2 = Color(Random().nextInt(0xffffffff) & 0xffffffff);
              });
            },
            child: Container(
              width: double.maxFinite,
              alignment: Alignment.center,
              child: SixStarPaint(_color2, 200),
            ),
          ),
        ],
      ),
    );
  }
}
