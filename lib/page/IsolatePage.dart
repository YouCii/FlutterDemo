import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/widgets/SmoothAnimationWidget.dart';

class IsolatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IsolateState();
  }
}

class _IsolateState extends State<IsolatePage> {
  int _calNum = 40;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Isolute"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SmoothAnimationWidget(),
          RaisedButton(
            child: Text("Compute on future"),
            onPressed: _isRunning
                ? null
                : () {
                    setState(() {
                      _isRunning = true;
                    });
                    Future.value(fibonacci(_calNum)).then((value) {
                      setState(() {
                        _isRunning = false;
                      });
                    });
                  },
          ),
          RaisedButton(
            child: Text("Compute on isolate"),
            onPressed: _isRunning
                ? null
                : () {
                    setState(() {
                      _isRunning = true;
                    });
                    compute(fibonacci, _calNum).then((value) {
                      setState(() {
                        _isRunning = false;
                      });
                    });
                  },
          ),
        ],
      ),
    );
  }
}

/// 递归的斐波那契数列计算, 非常耗时
int fibonacci(int n) {
  switch (n) {
    case 0:
      return 0;
    case 1:
      return 1;
    default:
      return fibonacci(n - 1) + fibonacci(n - 2);
  }
}
