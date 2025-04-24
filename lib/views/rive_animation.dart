import 'package:flutter/material.dart';
import 'package:hand_cricket/utils/utils.dart';
import 'package:rive/rive.dart';

class PlayRiveAnimation extends StatefulWidget {
  final String animationName;

  const PlayRiveAnimation({super.key, required this.animationName});

  @override
  PlayRiveAnimationState createState() => PlayRiveAnimationState();
}

class PlayRiveAnimationState extends State<PlayRiveAnimation> {
  late OneShotAnimation _controller;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  void _initAnimation() {
    _controller = OneShotAnimation(widget.animationName, autoplay: true);
  }

  @override
  void didUpdateWidget(covariant PlayRiveAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationName != widget.animationName) {
      setState(() {
        _initAnimation();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      prefixAssetName('graphics/hand_cricket.riv'),
      controllers: [_controller],
      fit: BoxFit.contain,
    );
  }
}
