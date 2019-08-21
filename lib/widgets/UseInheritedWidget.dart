import 'package:flutter/material.dart';

import 'MyInheritedWidget.dart';

class UseInheritedWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UseInheritedState();
  }
}

class _UseInheritedState extends State<UseInheritedWidget> {
  _UseInheritedState();

  @override
  void didChangeDependencies() {
    // 回调条件:
    // 1. 父级组件有InheritedWidget
    // 2. 父级InheritedWidget的updateShouldNotify返回了true
    // 3. 本widget的build方法中依赖了context.inheritFromWidgetOfExactType(InheritedWidget类型);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Inherited Data: ${MyInheritedWidget.of(context).data.toString()}',
    );
  }
}
