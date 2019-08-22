import 'package:flutter/material.dart';
import 'package:flutter_demo/utils/SingleRouteObserver.dart';

/// 实现共有逻辑: 更强大的生命周期
abstract class BaseLifecycleState<T extends StatefulWidget> extends State<T> with WidgetsBindingObserver, RouteAware {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 注册navigatorObservers监听, 放在这里使用可以获取到context, 在initState中不可以
    SingleRouteObserver.getInstance().subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    SingleRouteObserver.getInstance().unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// 桌面切换回调(再次测试发现并不与RouteAware冲突)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  /// 暂未测试到如何回调, 可能是与原生交互相关
  @override
  Future<bool> didPopRoute() {
    return super.didPopRoute();
  }

  /// 暂未测试到如何回调, 可能是与原生交互相关
  @override
  Future<bool> didPushRoute(String route) {
    return super.didPushRoute(route);
  }


  /// Called when the current route has been pushed.
  /// 从前一页面进入时, 当前页面展示之前
  @override
  void didPush() {
  }

  /// Called when the current route has been popped off.
  /// 返回前一页面时, 当前页面消失之前
  @override
  void didPop() {
  }

  /// Called when a new route has been pushed, and the current route is no longer visible.
  /// 进入到后一页面时, 当前页面消失之前
  @override
  void didPushNext() {
  }

  /// Called when the top route has been popped off, and the current route shows up.
  /// 从后一页面返回时, 当前页面展示之前
  @override
  void didPopNext() {
  }
}
