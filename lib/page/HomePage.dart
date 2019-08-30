import 'package:flutter/material.dart';
import 'package:flutter_demo/base/BaseLifecycleState.dart';
import 'package:flutter_demo/page/InheritedPage.dart';
import 'package:flutter_demo/page/LifecyclePage.dart';
import 'package:flutter_demo/page/SliverPage.dart';
import 'package:flutter_demo/utils/ToastUtils.dart';
import 'package:flutter_demo/widgets/CacheImage.dart';
import 'package:flutter_plugin/flutter_plugin.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BaseLifecycleState<HomePage> {
  Future<void> _invokeNativeFunction() async {
    try {
      await FlutterPlugin.invokeNative(123);
    } on PlatformException {
      ToastUtils.showToast('跳转LearnApp失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: GestureDetector(
          child: Container(
            height: 100,
            child: Hero(
              tag: "FirstHero",
              transitionOnUserGestures: true,
              child: CacheImage(
                fit: BoxFit.cover,
                imageUrl: "https://flutter.dev/assets/homepage/carousel/slide_4-bg-1bcaa66df37e5707c5c58b38cbf8175902a544905d4c0e81aac5f19ee2caa6cd.jpg",
              ),
            ),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SliverPage();
            }));
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LifecyclePage();
                }));
              },
            ),
            SizedBox(height: 50),
            IconButton(
              icon: Icon(Icons.business),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return InheritedPage();
                }));
              },
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _invokeNativeFunction,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
