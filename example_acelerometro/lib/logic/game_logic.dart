// ════════════════════════════════════════════════════════════════════
//  CAPA 4 — LÓGICA
//  lib/logic/game_logic.dart
//  Motor del juego: acelerómetro, movimiento y colisiones.
// ════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../state/game_state.dart'; // sube y entra a state/
import '../helpers/star_painter.dart';

mixin GameLogicMixin<T extends StatefulWidget> on GameState<T> {
  // ── initState: suscribirse al acelerómetro ────────────────────────
  @override
  void initState() {
    super.initState();
    accelSub = accelerometerEventStream().listen((AccelerometerEvent e) {
      ax = e.x;
      ay = e.y;
    });
  }

  // ── dispose: liberar recursos para evitar memory leaks ───────────
  @override
  void dispose() {
    accelSub?.cancel();
    loop?.cancel();
    super.dispose();
  }

  // ── initGame: coloca el pingüino y arranca el loop de 60fps ──────
  void initGame() {
    px = sw * 0.50;
    py = sh * 0.14;
    gameStatus = 'playing';

    loop?.cancel();
    loop = Timer.periodic(const Duration(milliseconds: 16), (_) => tick());
  }

  // ── tick: se ejecuta ~60 veces por segundo ────────────────────────
  void tick() {
    if (gameStatus != 'playing') return;

    setState(() {
      // 1. Movimiento con acelerómetro
      px += -ax * GameState.speed;
      py += ay * GameState.speed * 0.45;

      // 2. Limitar dentro de pantalla
      px = px.clamp(GameState.pSize / 2, sw - GameState.pSize / 2);
      py = py.clamp(GameState.pSize / 2, sh - GameState.pSize / 2);

      // 3. Colisión con estrellas → perder
      for (final StarObstacle star in GameState.stars) {
        final double sx = star.xF * sw;
        final double sy = star.yF * sh;
        final double dist = sqrt(pow(px - sx, 2) + pow(py - sy, 2));
        final double min = (GameState.pSize / 2 + star.size / 2) * 0.72;
        if (dist < min) {
          gameStatus = 'lost';
          loop?.cancel();
          return;
        }
      }

      // 4. Llegó al hoyo → ganar
      final double hx = GameState.hxF * sw;
      final double hy = GameState.hyF * sh;
      final double dist = sqrt(pow(px - hx, 2) + pow(py - hy, 2));
      final double min = (GameState.pSize / 2 + GameState.hSize / 2) * 0.80;
      if (dist < min) {
        gameStatus = 'won';
        loop?.cancel();
      }
    });
  }

  // ── restart: reinicia desde el botón "Reintentar" ─────────────────
  void restart() {
    loop?.cancel();
    setState(initGame);
  }
}
