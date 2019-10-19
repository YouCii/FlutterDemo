import 'package:flutter/material.dart';

class FuturePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FutureState();
  }
}

class _FutureState extends State<FuturePage> {
  String _log = "";
  bool _isRunning = false;

  /// Future把事件插入到EventQueue的末尾.
  /// 同步代码先执行, 然后才是MicroTask以及EventLoop, 所以"Before"和"After"会先于任何一个Future执行
  void _test() async {
    setState(() {
      _isRunning = true;
    });
    _log += "\n";

    _doFuture(1).then((position) {
      setState(() {
        _formatLogString("Then" + position.toString());
      });
    });

    // 此Future没有延迟/耗时操作, 所以Then会比后面的代码插入的Event较先执行到
    Future.value("no delay").then((value) {
      setState(() {
        _formatLogString(value);
      });
    });

    setState(() {
      _formatLogString(_doFuture(2).then((position) {
        setState(() {
          _formatLogString("Then" + position.toString());
        });
      }).toString());
    });

    int result = await _doFuture(3);
    setState(() {
      _formatLogString("Then" + result.toString());
      _isRunning = false;
    });
  }

  Future<int> _doFuture(int position) async {
    return await Future.delayed(Duration(seconds: 5), () {
      print(position);
      return position;
    });
  }

  void _formatLogString(String old) {
    _log += "\n" + old + ":" + DateTime.now().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Future Await")),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(child: Text(_log)),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: RaisedButton(
                child: Text("test"),
                onPressed: _isRunning
                    ? null
                    : () {
                        setState(() {
                          _formatLogString("Before");
                        });
                        _test();
                        setState(() {
                          _formatLogString("After");
                        });
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
