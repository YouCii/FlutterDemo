import 'package:flutter/material.dart';

/// 循环滑动动画 Widget
class SmoothAnimationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SmoothAnimationState();
  }
}

class _SmoothAnimationState extends State<SmoothAnimationWidget> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<BorderRadius> _borderAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _borderAnimation = BorderRadiusTween(
      begin: BorderRadius.circular(100),
      end: BorderRadius.circular(0),
    ).animate(_animationController);

    _animationController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        builder: (context, child) {
          return Container(
            child: FlutterLogo(size: 200),
            width: 350,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                colors: <Color>[
                  Colors.blueAccent,
                  Colors.redAccent,
                ],
              ),
              borderRadius: _borderAnimation.value,
            ),
          );
        },
        animation: _borderAnimation,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
