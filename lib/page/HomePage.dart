import 'package:flutter/material.dart';
import 'package:flutter_demo/base/BaseLifecycleState.dart';
import 'package:flutter_demo/page/InheritedPage.dart';
import 'package:flutter_demo/page/LifecyclePage.dart';
import 'package:flutter_demo/page/SliverPage.dart';
import 'package:flutter_demo/utils/ToastUtils.dart';
import 'package:flutter_plugin/flutter_plugin.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BaseLifecycleState<HomePage> {

  Future<void> _toOtherApp() async {
    try {
      await FlutterPlugin.goToOtherApp;
    } on PlatformException {
      ToastUtils.showToast('跳转LearnApp失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RaisedButton(
              child: Text("LifecyclePage"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LifecyclePage();
                }));
              },
            ),
            RaisedButton(
              child: Text("SliverPage"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SliverPage();
                }));
              },
            ),
            RaisedButton(
              child: Text("InheritedPage"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return InheritedPage();
                }));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toOtherApp,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
