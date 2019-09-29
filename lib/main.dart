import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/utils/SingleRouteObserver.dart';
import 'package:flutter_demo/page/HomePage.dart';

/// main方法和普通方法内的Future表现一致, 但是Main方法里的MicroTask方法不会优先执行,
/// Dart事件执行顺序: Main > MicroTask Queue -> Event Queue
Future main() async {
  // 固定竖屏
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // 设置透明状态栏
  // if (Platform.isAndroid) {
  //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  // }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo Home Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        platform: TargetPlatform.iOS,
      ),
      home: HomePage(title: 'Flutter Demo Home Page'),
      navigatorObservers: [SingleRouteObserver.getInstance()],
    );
  }
}
