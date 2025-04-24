import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hand_cricket/models/game_state.dart';
import 'package:hand_cricket/models/overlay_state.dart';
import 'package:hand_cricket/models/play_state.dart';
import 'package:hand_cricket/utils/utils.dart';

class OverlayViewModel extends StateNotifier<OverlayState> {
  OverlayViewModel() : super(OverlayState());

  bool _isInitialBatting = true;

  void updateOverlay(GameState gameState, GameState? oldGameState) {
    if (gameState.playState == PlayState.userBatting &&
        gameState.playerMove != gameState.botMove &&
        gameState.playerMove == 6 &&
        (oldGameState == null ||
            gameState.playerMove != oldGameState.playerMove)) {
      _showSixerOverlay();
      return;
    }

    if (oldGameState == null || gameState.playState != oldGameState.playState) {
      _updateOverlayImage(gameState);
    }
  }

  void _showSixerOverlay() {
    final imagePath = prefixAssetName('graphics/sixer.png');
    Future.delayed(const Duration(milliseconds: 100), () {
      state = OverlayState(
        showOverlay: true,
        imagePath: imagePath,
        isGameOver: false,
        isDefend: false,
      );
    });
    Future.delayed(const Duration(seconds: 2), () {
      state = OverlayState();
    });
  }

  void _updateOverlayImage(GameState gameState) {
    String? imagePath;
    bool isGameOver = false;
    bool isDefend = false;

    switch (gameState.playState) {
      case PlayState.userBatting:
        if (_isInitialBatting) {
          imagePath = 'graphics/batting.png';
          _isInitialBatting = false;
        }
        break;
      case PlayState.botBatting:
        imagePath = 'graphics/game_defend.webp';
        isDefend = true;
        _isInitialBatting = true;
        break;
      case PlayState.userOut:
        imagePath = 'graphics/out.png';
        break;
      case PlayState.gameOver:
        imagePath = 'graphics/game_over.png';
        isGameOver = true;
        break;
      default:
        imagePath = null;
    }

    if (imagePath != null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        state = OverlayState(
          showOverlay: true,
          imagePath: prefixAssetName(imagePath!),
          isGameOver: isGameOver,
          isDefend: isDefend,
        );
      });
      if (!isGameOver) {
        Future.delayed(const Duration(seconds: 2), () {
          state = OverlayState();
        });
      }
    } else {
      state = OverlayState();
      _isInitialBatting = gameState.playState != PlayState.userBatting;
    }
  }

  void hideOverlay() {
    state = OverlayState();
    _isInitialBatting = true;
  }
}

final overlayStateProvider =
    StateNotifierProvider<OverlayViewModel, OverlayState>(
      (ref) => OverlayViewModel(),
    );
