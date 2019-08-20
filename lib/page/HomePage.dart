import 'package:flutter/material.dart';
import 'package:flutter_demo/base/BasePage.dart';
import 'package:flutter_demo/page/LifecyclePage.dart';
import 'package:flutter_plugin/flutter_plugin.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BasePageState<HomePage> {
  String _result = "暂未执行";

  Future<void> _initPlatformState() async {
    try {
      _result = await FlutterPlugin.goToOtherApp;
    } on PlatformException {
      _result = 'Failed to get platform version.';
    }
    setState(() {
      _result = _result;
    });
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
            Text(
              'From plugin: ' + _result,
            ),
            RaisedButton(
              child: Text("LifecyclePage"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LifecyclePage();
                }));
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _initPlatformState,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
