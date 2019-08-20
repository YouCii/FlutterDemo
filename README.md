# FlutterDemo

测试Demo

**遇到问题欢迎提Issue, 共同进步**

# 应用内用到的东西:

- `Flutter` 调用原生的 `Plugin`, 调用运转流程如下:
    1. `Plugin` 部分
        1. `Plugin` 的 `android/ios` 的 `MyFlutterPlugin:MethodCallHandler` 提供原生方法, 并定义 `ChannelName`:
            ```kotlin
            companion object {
                @JvmStatic
                fun registerWith(registrar: Registrar) {
                    val channel = MethodChannel(registrar.messenger(), "统一的渠道名字")
                    channel.setMethodCallHandler(MyFlutterPlugin(registrar.activity()))
                }
            }
            ```
        2. `Plugin` 的 `flutter_plugin.dart` 内获取到 `android/ios` 内部内定的 `Channel`, 并暴露 `Plugin` 方法 ( 类似于代理原生方法, 其实这也是`plugin`的目的 ) :
            ```dart
            static const MethodChannel _channel = const MethodChannel('统一的渠道名字');
            
            static Future<String> get goToOtherApp async {
              final String result = await _channel.invokeMethod('goToOtherApp');
              return result;
            }
            ```
        3. `Plugin` 的 `pubspec.yaml` 文件标明此 `Plugin` 的信息, 以供主项目引用
            ```
            flutter:
              plugin:
                androidPackage: com.youcii.flutter_plugin
                pluginClass: MyFlutterPlugin
            ```    
    2. 主项目部分:
        1. 主项目的`pubspec.yaml`中引用`Plugin`, 名字可自定义:
            ```
            dev_dependencies:
              flutter_plugin:
                path: flutter_plugin
            ```
        2. 主项目的`android/ios`自动依赖到`Plugin`的`android/ios`( 通过主项目`build.gradle`的`merge`操作 ), 自动编译注册`MyFlutterPlugin`(这一层无需任何手动操作):
            ```java
            MyFlutterPlugin.registerWith(registry.registrarFor("com.youcii.flutter_plugin.MyFlutterPlugin"));
            ```
        3. 主项目调用`Plugin`内的原生方法时, 只需要以下操作:
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
- 生命周期全解析
    1. onCreate : initState或者didChangeDependencies(后者更强大)
    2. onResume : didPush(从前一页面进入时), didPopNext(从后一页面返回时)
    3. onPause  : didPushNext(进入到后一页面前), didPop(返回前一页面)
    4. onDestroy: dispose
    5. 前后台切换 : didChangeAppLifecycleState
- 布局View层级三要素: Widget(静态不可变), Element(同时持有Widget和RenderObject, 通过dirty->performRebuild更新), RenderObject
    1. StatelessWidget     ---(createElement)---> StatelessElement     -> element创建后, 每次element更新都会重建widget
    2. StatefulWidget      ---(createElement)---> StatefulElement      -> element创建后, 后面根据情况update state或者create state   
    3. RenderObjectWidget  ---(createElement)---> RenderObjectElement  -> element通过mount方法调用widget.getRenderObject, 构建出RenderObjectTree
- 刷新UI流程
    1. 应用构建时:
        1. runApp -> RenderObjectToWidgetAdapter.attachToRenderTree
        2. 如果renderViewElement==null: RenderObjectToWidgetAdapter通过createElement创建renderViewElement -> BuildOwner.buildScope -> renderViewElement.mount -> element.rebuild(见下方)
        3. 如果renderViewElement!=null: renderViewElement.markNeedsBuild(见下方)
    2. setState时: _element.markNeedsBuild(见下方) 
    3. element.markNeedsBuild, 会把element标记为dirty, 添加到dirtyList中 -> 等待BuildOwner.buildScope被vsync调起, 执行element.rebuild
    5. rebuild -> performRebuild -> updateChild(NormalElement) 或者 widget.updateRenderObject(RenderObjectElement)
       