import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final timerProvider = StateNotifierProvider<TimerController, int>((ref) {
  return TimerController(ref);
});

class TimerController extends StateNotifier<int> {
  Timer? _timer;
  final Ref ref;

  TimerController(this.ref) : super(10);

  void startTimer(Function onTimeOut) {
    _timer?.cancel();
    state = 10;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state == 0) {
        cancel();
        onTimeOut();
      } else {
        state--;
      }
    });
  }

  void cancel() {
    _timer?.cancel();
  }
}
