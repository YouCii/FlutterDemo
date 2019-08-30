import 'dart:async';

import 'package:flutter/services.dart';

class FlutterPlugin {
  static const MethodChannel _channel = const MethodChannel('my_flutter_plugin');

  static Future<String> invokeNative(int param) async {
    final String result = await _channel.invokeMethod('invokeNative', param);
    return result;
  }
}
