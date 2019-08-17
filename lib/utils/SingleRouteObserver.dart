import 'package:flutter/material.dart';

/// 界面的生命周期监听
class SingleRouteObserver extends RouteObserver<PageRoute> {
  static SingleRouteObserver _instance;

  SingleRouteObserver._();

  static SingleRouteObserver getInstance() {
    if (_instance == null) {
      _instance = SingleRouteObserver._();
    }
    return _instance;
  }
}
