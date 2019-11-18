# FlutterDemo

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/e17a4c59327e4a82b2ea64bfbacd50a2)](https://app.codacy.com/app/550341130/FlutterDemo?utm_source=github.com&utm_medium=referral&utm_content=YouCii/FlutterDemo&utm_campaign=Badge_Grade_Dashboard)

测试Demo

**遇到问题欢迎提Issue, 共同进步**

## 应用内用到的东西

#### Flutter调用原生的Plugin流程
###### Plugin部分
1. `Plugin`的`android/ios`的`MyFlutterPlugin:MethodCallHandler`提供原生方法, 并定义`ChannelName`:
   ```kotlin
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "统一的渠道名字")
            channel.setMethodCallHandler(MyFlutterPlugin(registrar.activity()))
        }
    }
   ```
2. `Plugin`的`flutter_plugin.dart`内获取到`android/ios`内部内定的`Channel`, 并暴露`Plugin`方法 ( 类似于代理原生方法, 其实这也是`plugin`的目的 ) :
   ```dart
    static const MethodChannel _channel = const MethodChannel('统一的渠道名字');
    
    static Future<String> get goToOtherApp async {
      final String result = await _channel.invokeMethod('goToOtherApp');
      return result;
    }
   ```
3. `Plugin`的`pubspec.yaml`文件标明此`Plugin`的信息, 以供主项目引用
   ```yaml
    flutter:
      plugin:
        androidPackage: com.youcii.flutter_plugin
        pluginClass: MyFlutterPlugin
   ```   
###### 主项目部分
1. 主项目的`pubspec.yaml`中引用`Plugin`, 名字可自定义:
   ```yaml
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
#### 生命周期全解析
1. `onCreate`: `initState`或者`didChangeDependencies`(后者更强大)
2. `onResume`: `didPush`(从前一页面进入时),`didPopNext`(从后一页面返回时)
3. `onPause`: `didPushNext`(进入到后一页面前),`didPop`(返回前一页面)
4. `onDestroy`: `dispose`
5. 前后台切换: `didChangeAppLifecycleState`
    
#### 构造方法相关
1. 不允许在`factory`中引用当前类的示例;
2. 可以定义别名构造方法, 例如:`SingleObject.create();`
3. 如果显示声明某种形式的构造方法, 则只允许使用显示声明的构造形式;   

#### `Sliver`家族:
1. `SliverAppBar`: 实现类似`Android#CollapsingToolbarLayout`的动画
2. `SliverGrid`: 组合Grid列表
3. `SliverPersistentHeader`: 可中间插入/固定在顶部/缩放的`Header`
4. `SliverFixedExtentList`: 比`SliverList`效果更高的组合列表(因为固定了item在主轴方向上的长度)

#### 代码执行顺序
同步代码 > `MicroTask Queue` > `Event Queue`, 其中`EventQueue`中的`Event`包括: 
1. dart产生的事件: Future, Timer, Isolate之间的消息等;
2. 系统产生的事件: I/O, 鼠标事件, 屏幕点击等;
  
#### 自定义叶子`RenderObject`的关键点
1. 继承`RenderObject`的子类`RenderBox`更简单, 它在父类的基础上实现了笛卡尔坐标系, 更易用; 
2. 必须重写`isRepaintBoundary`为true或者用`RepaintBoundary`包裹, 否则会出现offset偏移的问题; 
3. `paint`方法中需要刷新一下修改的参数, 才可以支持外部`setState`调用; 
4. 必须重写此方法修改下`size`, 否则红屏错误; 
     ```dart
     @override
     void performLayout() {
        size = constraints.constrain(Size(_starSize, _starSize));
     }
     ```
5. 如果想要监听onTap就必须重写`hitTestSelf`然后按情况返回, 作为叶子widget时直接返回true; 
6. 修改`RenderObject`的内部参数时, 记得在set方法中调用`markNeedsPaint`或者`markNeedsLayout`将其标为`dirty`状态, 否则`setState`不会更新它; 
7. 使用`RenderObject`的`LeafRenderObjectWidget`需要重写`updateRenderObject`修改下UI关心的参数, 否则`setState`不会更新这些参数; 
8. `CustomPaint`和`CustomPainter`也可以实现自定义效果, 但是细节有点差别; 