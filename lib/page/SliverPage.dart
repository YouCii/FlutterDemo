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
  double _offset = 0.0;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset < 0) {
          setState(() {
            _offset = _scrollController.offset;
          });
        }
      });
  }

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
            expandedHeight: 180 - _offset,
            // 填充的UI
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Hero(
                tag: "FirstHero",
                transitionOnUserGestures: true,
                child: CacheImage(
                  fit: BoxFit.cover,
                  imageUrl: "https://flutter.dev/assets/homepage/carousel/slide_4-bg-1bcaa66df37e5707c5c58b38cbf8175902a544905d4c0e81aac5f19ee2caa6cd.jpg",
                ),
              ),
              title: Text('Sliver大家族'),
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              childAspectRatio: 1,
            ),
            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.all(10),
                child: CacheImage(
                  fit: BoxFit.fill,
                  imageUrl: index % 2 == 0
                      ? "http://5b0988e595225.cdn.sohucs.com/images/20180203/bb9208badf9e4fdd9a46e7a1243f9c46.jpeg"
                      : "https://flutter.dev/assets/homepage/carousel/slide_3-bg-8add601bda8d313eaef069c0bad40e4edee018e18777abaf79474f1ab783ca7d.jpg",
                ),
              );
            }, childCount: 4),
          ),
          SliverPersistentHeader(
            delegate: _SliverHeaderDelegate(200, 50),
            floating: false,
            pinned: true,
          ),
          SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                color: Colors.lightBlue[100 * (index % 9)],
                child: Text('list item $index'),
              );
            }, childCount: 15),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 80,
              color: Color(0xff551155),
              alignment: Alignment.center,
              child: Text(
                "可任意插入普通组件",
                style: TextStyle(color: Color(0xffffffff)),
              ),
            ),
          ),
        ],
        physics: BouncingScrollPhysics(),
        controller: _scrollController,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  double _maxExtent, _minExtent;

  _SliverHeaderDelegate(this._maxExtent, this._minExtent);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: overlapsContent ? Colors.red : Colors.lightBlue,
      child: Center(child: Text("$shrinkOffset")),
    );
  }

  @override
  double get maxExtent => _maxExtent;

  @override
  double get minExtent => _minExtent;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate != this || oldDelegate?.maxExtent != this.maxExtent || oldDelegate?.minExtent != this.minExtent;
  }
}
