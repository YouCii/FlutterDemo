import 'package:flutter/material.dart';

class RenderTreePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RenderTreeState();
  }
}

class _RenderTreeState extends State<RenderTreePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RenderObject理解"),
      ),
      body: Opacity(
        child: Text('透明测试'),
        opacity: 1,
      ),
    );
  }
}
