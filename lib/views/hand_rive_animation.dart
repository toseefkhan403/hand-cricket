import 'package:flutter/material.dart';
import 'package:hand_cricket/utils/utils.dart';
import 'package:rive/rive.dart';

class HandRiveAnimation extends StatefulWidget {
  final String animationName;

  const HandRiveAnimation({super.key, required this.animationName});

  @override
  HandRiveAnimationState createState() => HandRiveAnimationState();
}

class HandRiveAnimationState extends State<HandRiveAnimation> {
  Artboard? _artboard;
  SimpleAnimation? _idleController;
  OneShotAnimation? _animationController;

  @override
  void initState() {
    super.initState();
    _idleController = SimpleAnimation('Idle', autoplay: true, mix: 1.0);
  }

  @override
  void didUpdateWidget(covariant HandRiveAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationName != widget.animationName && _artboard != null) {
      _animationController?.dispose();
      _animationController = OneShotAnimation(
        widget.animationName,
        autoplay: true,
        mix: 1.0,
        onStop: () {
          // idle should resume after one-shot animation
          if (_artboard != null) {
            _artboard!.removeController(_animationController!);
            _artboard!.addController(_idleController!);
          }
        },
      );
      // play the one-shot animation
      _artboard!.removeController(_idleController!);
      _artboard!.addController(_animationController!);
    }
  }

  @override
  void dispose() {
    _idleController?.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      prefixAssetName('graphics/hand_cricket.riv'),
      controllers: [_idleController!],
      fit: BoxFit.contain,
      onInit: (artboard) {
        setState(() {
          _artboard = artboard;
          _artboard!.addController(_idleController!);
        });
      },
    );
  }
}
