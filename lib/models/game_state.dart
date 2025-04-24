import 'package:hand_cricket/models/play_state.dart';

class GameState {
  final PlayState playState;
  final int ballsPlayed;
  final List<int> playerScores;
  final List<int> botScores;
  final int playerMove;
  final int botMove;
  final int playerTotalScore;
  final int botTotalScore;
  final bool isTimeOver;

  GameState({
    required this.playState,
    required this.ballsPlayed,
    required this.playerScores,
    required this.botScores,
    required this.playerMove,
    required this.botMove,
    required this.playerTotalScore,
    required this.botTotalScore,
    this.isTimeOver = false,
  });

  factory GameState.initial() {
    return GameState(
      playState: PlayState.userBatting,
      ballsPlayed: 0,
      playerScores: List.filled(6, 0),
      botScores: List.filled(6, 0),
      playerMove: 0,
      botMove: 0,
      playerTotalScore: 0,
      botTotalScore: 0,
      isTimeOver: false,
    );
  }

  GameState copyWith({
    PlayState? playState,
    int? ballsPlayed,
    List<int>? playerScores,
    List<int>? botScores,
    int? playerMove,
    int? botMove,
    int? playerTotalScore,
    int? botTotalScore,
    bool? isTimeOver,
  }) {
    return GameState(
      playState: playState ?? this.playState,
      ballsPlayed: ballsPlayed ?? this.ballsPlayed,
      playerScores: playerScores ?? this.playerScores,
      botScores: botScores ?? this.botScores,
      playerMove: playerMove ?? this.playerMove,
      botMove: botMove ?? this.botMove,
      playerTotalScore: playerTotalScore ?? this.playerTotalScore,
      botTotalScore: botTotalScore ?? this.botTotalScore,
      isTimeOver: isTimeOver ?? this.isTimeOver,
    );
  }
}
