import 'package:flutter/material.dart';
import 'package:flutter_demo/page/FuturePage.dart';
import 'package:flutter_demo/page/IsolatePage.dart';
import 'package:flutter_demo/page/RenderObjectPage.dart';

class TestListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(title: Text("测试列表")),
          _getItemView(context, "Future", FuturePage()),
          _getItemView(context, "Isolute", IsolatePage()),
          _getItemView(context, "RenderObject", RenderObjectPage()),
        ],
      ),
    );
  }

  Widget _getItemView(BuildContext context, String title, Widget nextPage) {
    return SliverToBoxAdapter(
      child: RaisedButton(
        child: Text(title),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return nextPage;
          }));
        },
      ),
    );
  }
}
