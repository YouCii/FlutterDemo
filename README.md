# FlutterDemo

测试Demo

# 应用内用到的东西:

- `Flutter` 调用原生的 `Plugin`, 调用运转流程如下:
    1. `Plugin` 部分
        - `Plugin` 的 `android/ios` 的 `MyFlutterPlugin:MethodCallHandler` 提供原生方法, 并定义 `ChannelName`:
            ```kotlin
            companion object {
                @JvmStatic
                fun registerWith(registrar: Registrar) {
                    val channel = MethodChannel(registrar.messenger(), "统一的渠道名字")
                    channel.setMethodCallHandler(MyFlutterPlugin(registrar.activity()))
                }
            }
            ```
        - `Plugin` 的 `flutter_plugin.dart` 内获取到 `android/ios` 内部内定的 `Channel`, 并暴露 `Plugin` 方法 ( 类似于代理原生方法, 其实这也是`plugin`的目的 ) :
            ```dart
            static const MethodChannel _channel = const MethodChannel('统一的渠道名字');
            
            static Future<String> get goToOtherApp async {
              final String result = await _channel.invokeMethod('goToOtherApp');
              return result;
            }
            ```
        - `Plugin` 的 `pubspec.yaml` 文件标明此 `Plugin` 的信息, 以供主项目引用
            ```
            flutter:
              plugin:
                androidPackage: com.youcii.flutter_plugin
                pluginClass: MyFlutterPlugin
            ```    
    2. 主项目部分:
        - 主项目的`pubspec.yaml`中引用`Plugin`, 名字可自定义:
            ```
            dev_dependencies:
              flutter_plugin:
                path: flutter_plugin
            ```
        - 主项目的`android/ios`自动依赖到`Plugin`的`android/ios`( 通过主项目`build.gradle`的`merge`操作 ), 自动编译注册`MyFlutterPlugin`(这一层无需任何手动操作):
            ```java
            MyFlutterPlugin.registerWith(registry.registrarFor("com.youcii.flutter_plugin.MyFlutterPlugin"));
            ```
        - 主项目调用`Plugin`内的原生方法时, 只需要以下操作:
            ```dart
            import 'package:flutter_plugin/flutter_plugin.dart';
            // 必须异步调用
            Future<void> _initPlatformState() async {
              try {
                _result = await FlutterPlugin.goToOtherApp;
              } on PlatformException {
                _result = 'Failed to get platform version.';
              }
              setState(() {
                _result = _result;
              });
            }
            ```