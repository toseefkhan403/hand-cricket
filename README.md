# Hand Cricket
A Flutter-based game simulating the classic hand cricket game where players choose numbers (1–6) to score runs.

## Gameplay
![Demo Gif 1](assets/demo/hand_cricket_demo_1.gif)
![Demo Gif 2](assets/demo/hand_cricket_demo_2.gif)

## Tech Stack
- Flutter & Dart: Core development.
- Riverpod: State management for game and overlay states.
- Rive: Hand animations for moves.

## Setup and Running Locally

1. Clone the Repository:
```
git clone https://github.com/toseefkhan403/hand-cricket.git
cd hand-cricket
```

2. Install Dependencies:
```
flutter pub get
```

3. Run the App:
```
flutter run
```

The app can run on all the Flutter supported platforms.

## Project Structure
Using the MVVM architecture with declarative code for UI and state updates.

- ***lib/models/***: Data models (GameState, PlayState, OverlayState).
- ***lib/viewmodels/***: Riverpod state management (GameViewModel, OverlayViewModel).
- ***lib/views/***: UI components (GameScreen, GameOverlay, Scoreboard, HandSelector, RiveAnimation).
- ***assets/***: Rive animations and images.

### Design Decisions
- **Modular Design**: Separated game logic (GameViewModel), overlay management (OverlayViewModel), and UI (GameScreen, GameOverlay) for maintainability.
- **Riverpod**: Chosen for reactive state management, enabling seamless updates across widgets (e.g., score, overlays) without direct widget coupling.
- **Rive Animations**: Used for hand move visuals, triggered by playerMove and botMove states.
- **Overlays**: Implemented as a state-driven system to guide users through game phases (sixers, innings transitions, out, game over).

### Additional Considerations

- **Spam Protection**: Added a move-processing lock (_isProcessingMove) to prevent rapid submissions, ensuring animations and state updates complete.
- **Score Display**: Visual distinction for batting (green circles with scores) and bowling (ball images), with greyed-out zero scores and faded unplayed balls.
- **Overlay Persistence**: Game over overlays persist until user action (button click), while others auto-dismiss for smooth flow.
