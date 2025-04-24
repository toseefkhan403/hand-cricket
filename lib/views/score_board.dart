import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hand_cricket/models/game_state.dart';
import 'package:hand_cricket/models/play_state.dart';
import 'package:hand_cricket/utils/utils.dart';

class Scoreboard extends StatelessWidget {
  const Scoreboard({super.key, required this.gameState});

  final GameState gameState;

  Widget _buildScoreCircle(
    int? score, {
    required bool isBatting,
    required bool isPlayed,
  }) {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            isBatting
                ? (score != null && score > 0
                    ? Colors.green
                    : Colors.grey.shade600)
                : Colors.white,
        border: Border.all(color: Colors.grey, width: 1),
        image:
            !isBatting
                ? DecorationImage(
                  image: AssetImage(prefixAssetName('graphics/ball.png')),
                  fit: BoxFit.cover,
                  opacity: isPlayed ? 1.0 : 0.3,
                )
                : null,
      ),
      alignment: Alignment.center,
      child:
          isBatting && score != null && score > 0
              ? Text(
                '$score',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )
              : null,
    );
  }

  Widget _buildScoreGrid(List<int> scores, {required bool isBatting}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff30363d),
        borderRadius: BorderRadius.circular(12),
      ),
      width: 100,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: List.generate(2, (row) {
          return Row(
            children: List.generate(3, (col) {
              final index = row * 3 + col;
              final score = index < scores.length ? scores[index] : null;
              final isPlayed = index < gameState.ballsPlayed;
              return Opacity(
                opacity: isPlayed || isBatting ? 1.0 : 0.5,
                child: _buildScoreCircle(
                  score,
                  isBatting: isBatting,
                  isPlayed: isPlayed,
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userBatting = gameState.playState == PlayState.userBatting;
    final botBatting = gameState.playState == PlayState.botBatting;

    final toWinText = switch (gameState.playState) {
      PlayState.userBatting => 'Score: ${gameState.playerTotalScore}',
      PlayState.botBatting =>
        'To win: ${max(0, gameState.playerTotalScore - gameState.botTotalScore + 1)}',
      PlayState.botWon ||
      PlayState.userWon ||
      PlayState.gameOver => 'Game Over',
      _ => '',
    };

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Player
            _buildScoreGrid(gameState.playerScores, isBatting: userBatting),
            // Bot
            _buildScoreGrid(gameState.botScores, isBatting: botBatting),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Player', style: TextStyle(color: Colors.white)),
              Text('Bot', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        if (toWinText.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xffdeb150),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              toWinText,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
