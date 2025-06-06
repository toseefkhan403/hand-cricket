import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hand_cricket/models/play_state.dart';
import '../models/game_state.dart';

class GameViewModel extends StateNotifier<GameState> {
  GameViewModel() : super(GameState.initial());

  bool _isProcessingMove = false;

  void userPlays(int move) {
    if (_isProcessingMove) {
      return;
    }

    _isProcessingMove = true;

    final botMove = _randomMove();

    state = state.copyWith(playerMove: move, botMove: botMove);

    // 1-second pause for animation
    Future.delayed(const Duration(seconds: 1), () {
      if (state.playState == PlayState.userBatting) {
        _handleUserBatting(move, botMove);
      } else if (state.playState == PlayState.botBatting) {
        _handleBotBatting(move, botMove);
      }

      // Reset moves to 0 (Idle) after processing
      state = state.copyWith(playerMove: 0, botMove: 0);

      _isProcessingMove = false;
    });
  }

  void _handleUserBatting(int userMove, int botMove) {
    final updatedScores = [...state.playerScores];
    final currentBall = state.ballsPlayed;

    if (userMove == botMove) {
      updatedScores[currentBall] = userMove;
      // Exclude the current ball's score from total since player is out
      final totalScore = updatedScores
          .take(currentBall)
          .fold(0, (sum, score) => sum + score);
      state = state.copyWith(
        playerScores: updatedScores,
        ballsPlayed: currentBall + 1,
        playState: PlayState.userOut,
        playerTotalScore: totalScore,
      );
      return;
    }

    updatedScores[currentBall] = userMove;
    final newBallsPlayed = currentBall + 1;
    final totalScore = updatedScores
        .take(newBallsPlayed)
        .fold(0, (sum, score) => sum + score);
    final newState =
        newBallsPlayed >= 6
            ? state.copyWith(
              playerScores: updatedScores,
              ballsPlayed: 0, // Reset for bot innings
              playState: PlayState.botBatting,
              playerTotalScore: totalScore,
              botScores: List.filled(6, 0), // Initialize bot scores
            )
            : state.copyWith(
              playerScores: updatedScores,
              ballsPlayed: newBallsPlayed,
              playerTotalScore: totalScore,
            );

    state = newState;
  }

  void _handleBotBatting(int userMove, int botMove) {
    final updatedScores = [...state.botScores];
    final currentBall = state.ballsPlayed;

    if (userMove == botMove) {
      updatedScores[currentBall] = botMove;
      // Exclude the current ball's score from total since bot is out
      final totalScore = updatedScores
          .take(currentBall)
          .fold(0, (sum, score) => sum + score);
      state = state.copyWith(
        botScores: updatedScores,
        ballsPlayed: currentBall + 1,
        playState: PlayState.userWon,
        botTotalScore: totalScore,
      );
      _endGame();
      return;
    }

    updatedScores[currentBall] = botMove;
    final newBallsPlayed = currentBall + 1;
    final totalScore = updatedScores
        .take(newBallsPlayed)
        .fold(0, (sum, score) => sum + score);

    if (totalScore > state.playerTotalScore) {
      state = state.copyWith(
        botScores: updatedScores,
        ballsPlayed: newBallsPlayed,
        playState: PlayState.botWon,
        botTotalScore: totalScore,
      );
      _endGame();
      return;
    }

    final newState =
        newBallsPlayed >= 6
            ? state.copyWith(
              botScores: updatedScores,
              ballsPlayed: newBallsPlayed,
              playState: PlayState.botWon,
              botTotalScore: totalScore,
            )
            : state.copyWith(
              botScores: updatedScores,
              ballsPlayed: newBallsPlayed,
              botTotalScore: totalScore,
            );

    state = newState;
    if (newState.playState == PlayState.botWon) {
      _endGame();
    }
  }

  void startBotInnings() {
    state = state.copyWith(
      playState: PlayState.botBatting,
      ballsPlayed: 0,
      botScores: List.filled(6, 0),
    );
  }

  void resetGame() {
    state = GameState.initial();
    _isProcessingMove = false;
  }

  void timeExpired() {
    if (state.playState != PlayState.gameOver) {
      state = state.copyWith(playState: PlayState.gameOver, isTimeOver: true);
    }
  }

  void _endGame() {
    state = state.copyWith(playState: PlayState.gameOver);
  }

  int _randomMove() => Random().nextInt(6) + 1;
}

final gameViewModelProvider = StateNotifierProvider<GameViewModel, GameState>(
  (ref) => GameViewModel(),
);
