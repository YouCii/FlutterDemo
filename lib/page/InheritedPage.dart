import 'package:flutter/material.dart';
import 'package:flutter_demo/base/BaseLifecycleState.dart';
import 'package:flutter_demo/widgets/MyInheritedWidget.dart';
import 'package:flutter_demo/widgets/UseInheritedWidget.dart';

class InheritedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InheritedState();
  }
}

class _InheritedState extends BaseLifecycleState<InheritedPage> {
  int _num = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inherited测试"),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MyInheritedWidget(
              data: _num,
              child: UseInheritedWidget(),
            ),
            RaisedButton(
              child: Text("点击修改"),
              onPressed: () {
                setState(() {
                  _num++;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
