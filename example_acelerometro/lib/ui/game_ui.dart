// ════════════════════════════════════════════════════════════════════
//  CAPA 5 — INTERFAZ (UI)
//  lib/ui/game_ui.dart
//  Convierte el estado en widgets visuales en pantalla.
// ════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../state/game_state.dart'; // sube y entra a state/
import '../logic/game_logic.dart'; // sube y entra a logic/
import '../helpers/star_painter.dart';

extension GameUI<T extends StatefulWidget> on GameState<T> {
  Widget buildUI(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext ctx, BoxConstraints constraints) {
          sw = constraints.maxWidth;
          sh = constraints.maxHeight;

          if (!ready) {
            ready = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              (this as GameLogicMixin).initGame();
            });
          }

          return Stack(
            children: [
              // ── Capa 0: Fondo ───────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF0BE),
                  border: Border.all(color: const Color(0xFFB0A070), width: 3),
                ),
              ),

              // ── Capa 1: Estrellas (obstáculos) ─────────────────────
              ...GameState.stars.map((StarObstacle star) {
                return Positioned(
                  left: star.xF * sw - star.size / 2,
                  top: star.yF * sh - star.size / 2,
                  child: CustomPaint(
                    size: Size(star.size, star.size),
                    painter: StarPainter(),
                  ),
                );
              }),

              // ── Capa 2: Hoyo (meta) ─────────────────────────────────
              Positioned(
                left: GameState.hxF * sw - GameState.hSize / 2,
                top: GameState.hyF * sh - GameState.hSize / 2,
                child: Container(
                  width: GameState.hSize,
                  height: GameState.hSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black38, width: 2.5),
                  ),
                ),
              ),

              // ── Capa 3: Pingüino ────────────────────────────────────
              Positioned(
                left: px - GameState.pSize / 2,
                top: py - GameState.pSize / 2,
                child: const Text('🐧', style: TextStyle(fontSize: 42)),
              ),

              // ── Capa 4: HUD ─────────────────────────────────────────
              Positioned(
                top: 40,
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

              // ── Capa 5: Overlay de fin de juego ─────────────────────
              if (gameStatus != 'playing') _buildOverlay(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final bool isWon = gameStatus == 'won';
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: isWon
                ? const Color(0xFF1B5E20).withOpacity(0.9)
                : const Color(0xFFB71C1C).withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(isWon ? '🎉' : '💥', style: const TextStyle(fontSize: 60)),
              const SizedBox(height: 12),
              Text(
                isWon ? '¡Lo lograste!' : '¡Chocaste con una estrella!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: (this as GameLogicMixin).restart,
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
