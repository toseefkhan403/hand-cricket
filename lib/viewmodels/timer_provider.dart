import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hand_cricket/viewmodels/game_view_model.dart';

final timerProvider = StateNotifierProvider<TimerController, int>((ref) {
  return TimerController(ref);
});

class TimerController extends StateNotifier<int> {
  Timer? _timer;
  final Ref ref;

  TimerController(this.ref) : super(10);

  void startTimer() {
    _timer?.cancel();
    state = 10;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state == 0) {
        cancel();
        ref.read(gameViewModelProvider.notifier).timeExpired();
      } else {
        state--;
      }
    });
  }

  void cancel() {
    _timer?.cancel();
  }
}
