import 'package:flutter/material.dart';
import 'package:flutter_demo/page/FuturePage.dart';
import 'package:flutter_demo/page/IsolatePage.dart';

class TestListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(title: Text("测试列表")),
          SliverToBoxAdapter(
            child: RaisedButton(
              child: Text("Future"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return FuturePage();
                }));
              },
            ),
          ),
          SliverToBoxAdapter(
            child: RaisedButton(
              child: Text("Isolute"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return IsolatePage();
                }));
              },
            ),
          ),
        ],
      ),
    );
  }
}
