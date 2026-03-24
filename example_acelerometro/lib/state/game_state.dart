// ════════════════════════════════════════════════════════════════════
//  CAPA 3 — ESTADO
//  lib/state/game_state.dart
//  Todas las variables que pueden cambiar durante el juego.
// ════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'package:flutter/material.dart';
import '../helpers/star_painter.dart'; // modelo StarObstacle

abstract class GameState<T extends StatefulWidget> extends State<T> {
  // ── Posición del pingüino (píxeles absolutos) ─────────────────────
  double px = 0;
  double py = 0;

  // ── Datos del acelerómetro ────────────────────────────────────────
  double ax = 0;
  double ay = 0;

  // ── Tamaño de pantalla (se llenan en build) ───────────────────────
  double sw = 1;
  double sh = 1;
  bool ready = false;

  // ── Estado del juego: 'playing' | 'won' | 'lost' ─────────────────
  String gameStatus = 'playing';

  // ── Constantes (nunca cambian) ────────────────────────────────────
  static const double pSize = 50.0;
  static const double sSize = 38.0;
  static const double hSize = 60.0;
  static const double speed = 2.8;
  static const double hxF = 0.75;
  static const double hyF = 0.86;

  // ── Obstáculos ────────────────────────────────────────────────────
  static const List<StarObstacle> stars = [
    StarObstacle(xF: 0.15, yF: 0.10, size: sSize),
    StarObstacle(xF: 0.68, yF: 0.21, size: sSize),
    StarObstacle(xF: 0.22, yF: 0.43, size: sSize),
    StarObstacle(xF: 0.72, yF: 0.56, size: sSize),
    StarObstacle(xF: 0.14, yF: 0.73, size: sSize),
  ];

  // ── Recursos que hay que liberar en dispose() ─────────────────────
  StreamSubscription<dynamic>? accelSub;
  Timer? loop;
}
