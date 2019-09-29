import 'package:flutter/material.dart';
import 'package:flutter_demo/page/FuturePage.dart';

class TestListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(title: Text("测试列表")),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return RaisedButton(
                  child: Text("Future, await"),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return FuturePage();
                    }));
                  },
                );
              },
              childCount: 1,
            ),
          )
        ],
      ),
    );
  }
}
