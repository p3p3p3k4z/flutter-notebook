import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pingüino al hoyo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const GamePage(),
    );
  }
}

class StarObstacle {
  final double xF, yF, size;
  const StarObstacle({required this.xF, required this.yF, required this.size});
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  double _px = 0, _py = 0;
  double _ax = 0, _ay = 0;
  double _sw = 1, _sh = 1;
  String _status = 'playing';
  bool _started = false;

  static const double _pSize = 50.0;
  static const double _sSize = 38.0;
  static const double _hSize = 60.0;
  static const double _speed = 3.0;
  static const double _hxF = 0.75;
  static const double _hyF = 0.86;

  static const List<StarObstacle> _stars = [
    StarObstacle(xF: 0.15, yF: 0.10, size: _sSize),
    StarObstacle(xF: 0.68, yF: 0.21, size: _sSize),
    StarObstacle(xF: 0.22, yF: 0.43, size: _sSize),
    StarObstacle(xF: 0.72, yF: 0.56, size: _sSize),
    StarObstacle(xF: 0.14, yF: 0.73, size: _sSize),
  ];

  StreamSubscription<AccelerometerEvent>? _accelSub;
  Timer? _loop;

  @override
  void initState() {
    super.initState();
    _accelSub = accelerometerEventStream().listen((e) {
      _ax = e.x;
      _ay = e.y;
    });
  }

  @override
  void dispose() {
    _accelSub?.cancel();
    _loop?.cancel();
    super.dispose();
  }

  void _startGame() {
    _px = _sw * 0.50;
    _py = _sh * 0.14;
    _status = 'playing';
    _loop?.cancel();
    _loop = Timer.periodic(const Duration(milliseconds: 16), (_) => _tick());
  }

  /// Se ejecuta ~60 veces por segundo. Mueve, limita y detecta colisiones.
  void _tick() {
    if (_status != 'playing') return;

    setState(() {
      // 1. Mover con acelerómetro
      //
      // ZONA MUERTA: si la inclinación es menor a 0.8, no mover.
      // Evita que el pingüino se mueva solo por sostener el celular.
      // Piénsalo como: "solo muévete si de verdad estoy inclinando".
      const double deadZone = 0.8;

      final double moveX = _ax.abs() > deadZone ? -_ax * _speed : 0;
      // Y usa 0.20 (muy reducido) porque la gravedad base ya es ~9.8 en Y
      final double moveY = _ay.abs() > deadZone ? _ay * _speed * 0.20 : 0;

      _px += moveX;
      _py += moveY;

      // 2. Limitar dentro de pantalla — clamp(min, max)
      _px = _px.clamp(_pSize / 2, _sw - _pSize / 2);
      _py = _py.clamp(_pSize / 2, _sh - _pSize / 2);

      // 3. Colisión con estrellas (distancia euclidiana)
      for (final star in _stars) {
        final sx = star.xF * _sw;
        final sy = star.yF * _sh;
        final dist = sqrt(pow(_px - sx, 2) + pow(_py - sy, 2));
        final minD = (_pSize / 2 + star.size / 2) * 0.72;
        if (dist < minD) {
          _status = 'lost';
          _loop?.cancel();
          return;
        }
      }

      // 4. ¿Llegó al hoyo?
      final hx = _hxF * _sw;
      final hy = _hyF * _sh;
      final dist = sqrt(pow(_px - hx, 2) + pow(_py - hy, 2));
      final minH = (_pSize / 2 + _hSize / 2) * 0.80;
      if (dist < minH) {
        _status = 'won';
        _loop?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (ctx, constraints) {
          _sw = constraints.maxWidth;
          _sh = constraints.maxHeight;

          if (!_started && _sw > 1 && _sh > 1) {
            _started = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(_startGame);
            });
          }

          return Stack(
            children: [
              Container(color: const Color(0xFFFAF0BE)),

              for (final star in _stars)
                Positioned(
                  left: star.xF * _sw - star.size / 2,
                  top: star.yF * _sh - star.size / 2,
                  child: CustomPaint(
                    size: Size(star.size, star.size),
                    painter: _StarPainter(),
                  ),
                ),

              Positioned(
                left: _hxF * _sw - _hSize / 2,
                top: _hyF * _sh - _hSize / 2,
                child: Container(
                  width: _hSize,
                  height: _hSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black45, width: 2.5),
                  ),
                ),
              ),

              Positioned(
                left: _px - _pSize / 2,
                top: _py - _pSize / 2,
                child: const SizedBox(
                  width: 50,
                  height: 50,
                  child: Center(
                    child: Text('🐧', style: TextStyle(fontSize: 38)),
                  ),
                ),
              ),

              Positioned(
                top: 48,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '¡Inclina el dispositivo para mover al pingüino!',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),

              if (_status != 'playing') _buildOverlay(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverlay() {
    final won = _status == 'won';
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: won
                ? const Color(0xFF1B5E20).withOpacity(0.92)
                : const Color(0xFFB71C1C).withOpacity(0.92),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(won ? '🎉' : '💥', style: const TextStyle(fontSize: 64)),
              const SizedBox(height: 12),
              Text(
                won ? '¡Lo lograste!' : '¡Chocaste con una estrella!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => setState(_startGame),
                icon: const Icon(Icons.replay_rounded),
                label: const Text('Reintentar', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black45
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawPath(_starPath(size), paint);
  }

  Path _starPath(Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outer = size.width / 2;
    final inner = outer * 0.40;
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final oA = (i * 72 - 90) * pi / 180;
      final iA = ((i * 72 + 36) - 90) * pi / 180;
      final op = Offset(cx + outer * cos(oA), cy + outer * sin(oA));
      final ip = Offset(cx + inner * cos(iA), cy + inner * sin(iA));
      i == 0 ? path.moveTo(op.dx, op.dy) : path.lineTo(op.dx, op.dy);
      path.lineTo(ip.dx, ip.dy);
    }
    return path..close();
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
