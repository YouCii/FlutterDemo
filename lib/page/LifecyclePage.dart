import 'package:flutter/material.dart';
import 'package:flutter_demo/base/BaseLifecycleState.dart';

class LifecyclePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LifecyclePageState();
  }
}

class _LifecyclePageState extends BaseLifecycleState<LifecyclePage> {
  int _num = 0;

  _LifecyclePageState() {
    print("constructor"); // create1 仅执行一次
  }

  @override
  void initState() {
    super.initState(); // create2 仅执行一次
  }

  @override
  void didChangeDependencies() {
    // 回调条件:
    // 1. 父级组件有InheritedWidget
    // 2. 父级InheritedWidget的updateShouldNotify返回了true
    // 3. 本widget的build方法中依赖了context.inheritFromWidgetOfExactType(InheritedWidget类型);
    super.didChangeDependencies(); // create3, 添加RouteAware后在deactivate后执行两遍
  }

  @override
  void reassemble() {
    super.reassemble(); // 热更新1
  }

  /// 当此State被插入到其他的widget时调用, 例如 祖先节点rebuild widget时可能会调用
  @override
  void didUpdateWidget(LifecyclePage oldWidget) {
    super.didUpdateWidget(oldWidget); // 热更新2
  }

  @override
  Widget build(BuildContext context) {
    // didChangeDependencies, didUpdateWidget, setState, deactivate 后均会执行
    return Scaffold(
      appBar: AppBar(
        title: Text("Lifecycle测试"),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '''
1. `onCreate` : `initState`或者`didChangeDependencies`(后者更强大)

2. `onResume` : `didPush`(从前一页面进入时), `didPopNext`(从后一页面返回时)

3. `onPause`  : `didPushNext`(进入到后一页面前), `didPop`(返回前一页面)

4. `onDestroy`: `dispose`

5. 前后台切换 : `didChangeAppLifecycleState`
              '''
            ),

            RaisedButton(
              child: Text("setState:$_num"),
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

  /// State对应的Element被从树中移除后调用, 可能是暂时移除
  @override
  void deactivate() {
    super.deactivate(); // 界面显隐时1: 只有第一次创建不会执行, 其余类比onResume/onPause
  }

  /// State对应的Element被永久移除后调用
  @override
  void dispose() {
    super.dispose(); // destroy2: 类比onDestroy
  }
}
