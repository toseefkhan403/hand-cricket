class OverlayState {
  final bool showOverlay;
  final String? imagePath;
  final bool isGameOver;
  final bool isGameStart;
  final bool isDefend;

  OverlayState({
    this.showOverlay = false,
    this.imagePath = '',
    this.isGameOver = false,
    this.isDefend = false,
    this.isGameStart = false,
  });

  OverlayState copyWith({
    bool? showOverlay,
    String? imagePath,
    bool? isGameOver,
    bool? isDefend,
    bool? isGameStart,
  }) {
    return OverlayState(
      showOverlay: showOverlay ?? this.showOverlay,
      imagePath: imagePath ?? this.imagePath,
      isGameOver: isGameOver ?? this.isGameOver,
      isDefend: isDefend ?? this.isDefend,
      isGameStart: isGameStart ?? this.isGameStart,
    );
  }
}
