import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class PlayOneShotAnimation extends StatefulWidget {
  final String animationName;

  const PlayOneShotAnimation({super.key, required this.animationName});

  @override
  PlayOneShotAnimationState createState() => PlayOneShotAnimationState();
}

class PlayOneShotAnimationState extends State<PlayOneShotAnimation> {
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
  void didUpdateWidget(covariant PlayOneShotAnimation oldWidget) {
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
      'graphics/hand_cricket.riv',
      controllers: [_controller],
      fit: BoxFit.contain,
    );
  }
}
