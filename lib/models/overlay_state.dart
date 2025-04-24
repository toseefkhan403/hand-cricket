class OverlayState {
  final bool showOverlay;
  final String? imagePath;
  final bool isGameOver;
  final bool isDefend;

  OverlayState({
    this.showOverlay = false,
    this.imagePath = '',
    this.isGameOver = false,
    this.isDefend = false,
  });

  OverlayState copyWith({
    bool? showOverlay,
    String? imagePath,
    bool? isGameOver,
    bool? isDefend,
  }) {
    return OverlayState(
      showOverlay: showOverlay ?? this.showOverlay,
      imagePath: imagePath ?? this.imagePath,
      isGameOver: isGameOver ?? this.isGameOver,
      isDefend: isDefend ?? this.isDefend,
    );
  }
}
