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
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
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
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  static const double gameWidth = 360;
  static const double gameHeight = 520;
  static const double gravity = 0.6;
  static const double jumpVelocity = -12;

  late final Ticker _ticker;
  late Player _player;
  double _velocityY = 0;

  GameSession get _session => widget.session;

  @override
  void initState() {
    super.initState();
    _player = Player(x: 40, y: 0);
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    setState(_updatePhysics);
  }

  void _updatePhysics() {
    _velocityY += gravity;
    _player.y += _velocityY;

    final groundY = gameHeight - _player.size;
    if (_player.y > groundY) {
      _player.y = groundY;
      _velocityY = 0;
    }
    if (_player.y < 0) {
      _player.y = 0;
      _velocityY = 0;
    }
  }

  void _jump() {
    setState(() {
      _velocityY = jumpVelocity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game')),
      body: Center(
        child: GestureDetector(
          onTap: _jump,
          child: SizedBox(
            width: gameWidth,
            height: gameHeight,
            child: ClipRect(
              child: Stack(
                children: [
                  const GameBackground(),
                  _player.build(),
                ],
              ),
            ),
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

/// The scrolling backdrop. DartPad can't read local asset files, so we load
/// artwork from a hosted URL instead.
class GameBackground extends StatelessWidget {
  const GameBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.network(
        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
        fit: BoxFit.cover,
      ),
    );
  }
}
