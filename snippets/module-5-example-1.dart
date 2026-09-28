import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const GameMenuApp());
}

/// Holds the game's data and rules — no widgets, no UI, just logic.
class GameSession {
  int _score = 0;
  int _lives = 3;

  int get score => _score;
  int get lives => _lives;
  bool get isGameOver => _lives <= 0;

  void addPoint() {
    _score++;
  }

  void loseLife() {
    if (_lives > 0) {
      _lives--;
    }
  }
}

class GameMenuApp extends StatelessWidget {
  const GameMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Menu',
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.indigo),
      home: const MenuScreen(),
    );
  }
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State <MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State <MenuScreen> {
  final GameSession _session = GameSession();

  void _addPoint() {
    setState(() {
      _session.addPoint();
    });
  }

  void _openGameScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameScreen(session: _session)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sky Runner')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Welcome, Player!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.favorite, color: Colors.red),
                  const SizedBox(width: 8),
                  Text('Lives: ${_session.lives}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 24),
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text('Score: ${_session.score}', style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _addPoint,
              child: const Text('Tap to score a point!'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: _openGameScreen,
              child: const Text('Play'),
            ),
          ],
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  final GameSession session;

  const GameScreen({super.key, required this.session});

  @override
  State <GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State <GameScreen>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    setState(() {
      _elapsed = elapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game')),
      body: Center(
        child: Text(
          'Running for ${_elapsed.inSeconds}s',
          style: const TextStyle(fontSize: 28),
        ),
      ),
    );
  }
}
