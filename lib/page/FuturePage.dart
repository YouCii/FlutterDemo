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

  /// Future把事件插入到EventQueue的末尾
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

    // 此Future没有延迟/耗时操作, 会立即放入event-queue最后;
    // 但是后面的代码已经存在于event中, 所以"正常流1","正常流2"都会先于此执行, 甚至_test方法后的"正常流3"也会先执行
    Future.value("no delay").then((value) {
      setState(() {
        _formatLogString(value);
      });
    });

    setState(() {
      _formatLogString("正常流1");
    });

    setState(() {
      _formatLogString("正常流2");
    });

    int result = await _doFuture(2);
    setState(() {
      _formatLogString("Then" + result.toString());
    });

    setState(() {
      _formatLogString(_doFuture(3).then((position) {
        setState(() {
          _formatLogString("Then" + position.toString());
          _isRunning = false;
        });
      }).toString());
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
            Expanded(
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(10),
                child: Text(_log),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: RaisedButton(
                child: Text("test"),
                onPressed: _isRunning
                    ? null
                    : () {
                        _test();
                        setState(() {
                          _formatLogString("正常流3");
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
