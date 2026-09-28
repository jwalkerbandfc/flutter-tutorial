import 'package:flutter/material.dart';

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

class GameScreen extends StatelessWidget {
  final GameSession session;

  const GameScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final player = Player(x: 40, y: 240);
    final obstacle = Obstacle(x: 260);

    return Scaffold(
      appBar: AppBar(title: const Text('Game')),
      body: SizedBox.expand(
        child: Container(
          color: Colors.lightBlue.shade200,
          child: Stack(
            children: [
              obstacle.build(),
              player.build(),
            ],
          ),
        ),
      ),
    );
  }
}

/// The player character — an entity with a position and a way to draw itself.
class Player {
  double x;
  double y;
  final double size;

  Player({required this.x, required this.y, this.size = 50});

  Widget build() {
    return Positioned(
      left: x,
      top: y,
      child: CustomPaint(
        size: Size(size, size),
        painter: _PlayerPainter(),
      ),
    );
  }
}

class _PlayerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final body = Paint()..color = Colors.orange;
    canvas.drawOval(Rect.fromLTWH(0, 0, size.width, size.height), body);

    final eye = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(size.width * 0.68, size.height * 0.35), 4, eye);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// An obstacle the player has to avoid — same entity pattern as Player.
class Obstacle {
  double x;
  final double width;
  final double height;

  Obstacle({required this.x, this.width = 40, this.height = 140});

  Widget build() {
    return Positioned(
      left: x,
      bottom: 0,
      child: CustomPaint(
        size: Size(width, height),
        painter: _ObstaclePainter(),
      ),
    );
  }
}

class _ObstaclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.green.shade700;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
