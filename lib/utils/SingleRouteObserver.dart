import 'package:flutter/material.dart';

/// 界面的生命周期监听, 单例
class SingleRouteObserver extends RouteObserver<PageRoute> {
  static SingleRouteObserver _instance;

  SingleRouteObserver._();

  static SingleRouteObserver getInstance() {
    // if(_instance == null) initial
    _instance ??= SingleRouteObserver._();
    return _instance;
  }

}
