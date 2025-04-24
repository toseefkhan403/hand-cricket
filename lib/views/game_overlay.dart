import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hand_cricket/models/game_state.dart';
import 'package:hand_cricket/viewmodels/overlay_view_model.dart';
import '../viewmodels/game_view_model.dart';
import '../viewmodels/timer_provider.dart';

class GameOverlay extends ConsumerStatefulWidget {
  final GameState gameState;

  const GameOverlay({super.key, required this.gameState});

  @override
  ConsumerState<GameOverlay> createState() => _GameOverlayState();
}

class _GameOverlayState extends ConsumerState<GameOverlay> {
  GameState? _previousGameState;

  @override
  void didUpdateWidget(GameOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    // update overlay state when gameState changes
    ref
        .read(overlayStateProvider.notifier)
        .updateOverlay(widget.gameState, _previousGameState);
    _previousGameState = widget.gameState;
  }

  @override
  Widget build(BuildContext context) {
    final overlayState = ref.watch(overlayStateProvider);

    if (!overlayState.showOverlay || overlayState.imagePath == null) {
      return const SizedBox.shrink();
    }

    return Consumer(
      builder: (context, ref, child) {
        return Container(
          color: Colors.black54,
          child: Center(
            child:
                overlayState.isGameOver
                    ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            ref
                                .read(gameViewModelProvider.notifier)
                                .resetGame();
                            ref.read(timerProvider.notifier).startTimer(() {
                              ref
                                  .read(gameViewModelProvider.notifier)
                                  .timeExpired();
                            });
                            ref
                                .read(overlayStateProvider.notifier)
                                .hideOverlay();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow.shade800,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                          child: const Text(
                            'Play Again',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                    : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          overlayState.imagePath ?? '',
                          width: 300,
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                        if (overlayState.isDefend)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              '${widget.gameState.playerTotalScore}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
          ),
        );
      },
    );
  }
}
