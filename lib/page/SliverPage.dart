import 'package:flutter/material.dart';
import 'package:flutter_demo/base/BaseLifecycleState.dart';
import 'package:flutter_demo/widgets/CacheImage.dart';

/// 较为绚丽的层叠效果
class SliverPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SliverState();
  }
}

class _SliverState extends BaseLifecycleState<SliverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            // if true, 下滑时先显示appBar再展示list上部
            floating: false,
            // if true, 标题固定
            pinned: true,
            // if true, 顶部标题切换时没有中间态, 离手滑动
            snap: false,
            // 用于控制整体风格, 主要是调整状态栏的字体
            brightness: Brightness.dark,
            // 扩充时的最大高度
            expandedHeight: 180,
            // 填充的UI
            flexibleSpace: FlexibleSpaceBar(
              background: CacheImage(
                imageUrl: "https://flutter.dev/assets/homepage/carousel/slide_4-bg-1bcaa66df37e5707c5c58b38cbf8175902a544905d4c0e81aac5f19ee2caa6cd.jpg",
              ),
              title: Text('Sliver大家族'),
            ),
          ),
          SliverList(delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
            return Text('$index');
          }),),
        ],
      ),
    );
  }
}