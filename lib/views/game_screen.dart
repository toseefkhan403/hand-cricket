import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hand_cricket/models/play_state.dart';
import 'package:hand_cricket/utils/utils.dart';
import 'package:hand_cricket/views/game_overlay.dart';
import 'package:hand_cricket/views/rive_animation.dart';
import 'package:hand_cricket/views/score_board.dart';
import '../viewmodels/game_view_model.dart';
import '../viewmodels/timer_provider.dart';
import 'hand_selector.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(timerProvider.notifier).startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameViewModelProvider);
    final timer = ref.watch(timerProvider);
    final gameController = ref.read(gameViewModelProvider.notifier);

    void handleMove(int move) {
      ref.read(timerProvider.notifier).cancel();
      gameController.userPlays(move);

      final newState = ref.read(gameViewModelProvider);
      if (newState.playState == PlayState.userBatting ||
          newState.playState == PlayState.botBatting) {
        ref.read(timerProvider.notifier).startTimer();
      }
    }

    // trigger bot innings automatically when user is out or 6 balls are over
    if (gameState.playState == PlayState.userOut) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        ref.read(gameViewModelProvider.notifier).startBotInnings();
        ref.read(timerProvider.notifier).startTimer();
      });
    }

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              prefixAssetName('graphics/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width > 800 ? size.width * 0.25 + 20 : 10,
                vertical: 10,
              ),
              child: Column(
                children: [
                  Scoreboard(gameState: gameState),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.yellow.shade800),
                    ),
                    width: size.width - 40,
                    height: size.height * 0.3,
                    child: Row(
                      children: [
                        Expanded(
                          child: Transform.flip(
                            flipX: true,
                            child: PlayRiveAnimation(
                              animationName: getAnimationNameFromMove(
                                gameState.playerMove,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: PlayRiveAnimation(
                            animationName: getAnimationNameFromMove(
                              gameState.botMove,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (gameState.playState == PlayState.userBatting ||
                      gameState.playState == PlayState.botBatting) ...[
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipOval(
                          child: Container(
                            width: 60,
                            height: 60,
                            color: Colors.black26,
                            child: CircularProgressIndicator(
                              value: timer / 10,
                              strokeWidth: 2,
                              backgroundColor: Colors.black87,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.red.shade900,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          '$timer',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Pick a number before the timer runs out",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    HandSelector(onSelected: handleMove),
                    const SizedBox(height: 16),
                  ] else
                    const SizedBox.shrink(),
                ],
              ),
            ),
          ),
          GameOverlay(gameState: gameState),
        ],
      ),
    );
  }

  String getAnimationNameFromMove(int move) {
    return switch (move) {
      1 => 'One',
      2 => 'Two',
      3 => 'Three',
      4 => 'Four',
      5 => 'Five',
      6 => 'Six',
      _ => 'Idle',
    };
  }
}
