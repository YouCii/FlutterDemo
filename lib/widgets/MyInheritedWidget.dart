import 'package:flutter/material.dart';

class MyInheritedWidget extends InheritedWidget {
  final int data;

  MyInheritedWidget({@required this.data, Widget child}) : super(child: child);

  static MyInheritedWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(MyInheritedWidget);
  }

  @override
  bool updateShouldNotify(MyInheritedWidget oldWidget) {
    return this.data != oldWidget.data;
  }
}
