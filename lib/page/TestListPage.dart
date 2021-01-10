import 'package:flutter/material.dart';
import 'FuturePage.dart';
import 'IsolatePage.dart';
import 'LeafRenderPage.dart';
import 'MultiRenderPage.dart';

class TestListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(title: Text("测试列表")),
          _getItemView(context, "Future", FuturePage()),
          _getItemView(context, "Isolute", IsolatePage()),
          _getItemView(context, "LeafRenderObject", LeafRenderPage()),
          _getItemView(context, "MultiRenderObject", MultiRenderPage()),
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
