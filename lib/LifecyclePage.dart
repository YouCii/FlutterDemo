import 'package:flutter/material.dart';
import 'package:flutter_demo/ListPage.dart';
import 'package:flutter_demo/utils/SingleRouteObserver.dart';

class LifecyclePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LifecyclePageState();
  }
}

class _LifecyclePageState extends State<LifecyclePage> with WidgetsBindingObserver, RouteAware {
  int _num = 0;

  _LifecyclePageState() {
    print("constructor"); // create1 仅执行一次
  }

  @override
  void initState() {
    super.initState(); // create2 仅执行一次
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    // 回调条件:
    // 1. 父级组件有InheritedWidget
    // 2. 父级InheritedWidget的updateShouldNotify返回了true
    // 3. 本widget的build方法中依赖了context.inheritFromWidgetOfExactType(InheritedWidget类型);
    super.didChangeDependencies(); // create3, 添加RouteAware后在deactivate后执行两遍
    // 注册navigatorObservers监听, 放在这里使用可以获取到context, 在initState中不可以
    SingleRouteObserver.getInstance().subscribe(this, ModalRoute.of(context));
  }

  @override
  void reassemble() {
    super.reassemble(); // 热更新1
  }

  @override
  void didUpdateWidget(LifecyclePage oldWidget) {
    super.didUpdateWidget(oldWidget); // 热更新2 ( 祖先节点rebuild widget时调用 )
  }

  @override
  Widget build(BuildContext context) {
    // didChangeDependencies, didUpdateWidget, setState, deactivate 后均会执行
    return Scaffold(
      appBar: AppBar(
        title: Text("Lifecycle测试"),
      ),
      body: Column(
        children: <Widget>[
          MaterialButton(
            child: Text("setState:$_num"),
            onPressed: () {
              setState(() {
                _num++;
              });
            },
          ),
          MaterialButton(
            child: Text("下一个页面"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ListPage();
              }));
            },
          )
        ],
      ),
    );
  }

  @override
  void deactivate() {
    super.deactivate(); // 界面显隐时1: 只有第一次创建不会执行, 其余类比onResume/onPause
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // destroy2: 类比onDestroy
    SingleRouteObserver.getInstance().unsubscribe(this);
    super.dispose();
  }

  /// Called when the system puts the app in the background or returns he app to the foreground.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  /// Called when the top route has been popped off, and the current route shows up.
  @override
  void didPopNext() {
    print("didPopNext"); // 从后一页面返回时
  }

  /// Called when the current route has been popped off.
  @override
  void didPop() {
    print("didPop"); // 返回前一页面之前会调用
  }

  /// Called when the current route has been pushed.
  @override
  void didPush() {
    print("didPush"); // 从前一页面进入时
  }

  /// Called when a new route has been pushed, and the current route is no
  /// longer visible.
  @override
  void didPushNext() {
    print("didPushNext"); // 进入到后一页面前首先调用
  }
}
