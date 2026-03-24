// ════════════════════════════════════════════════════════════════════
//  CAPA 2 — ESTRUCTURA
//  lib/pages/game_page.dart
//  Define la pantalla principal del juego.
// ════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import '../state/game_state.dart'; // sube un nivel con ".." y entra a state/
import '../logic/game_logic.dart'; // sube un nivel con ".." y entra a logic/
import '../ui/game_ui.dart'; // sube un nivel con ".." y entra a ui/

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

// Hereda el estado (Capa 3) y mezcla la lógica (Capa 4)
// El método build() viene de la extensión GameUI (Capa 5)
class _GamePageState extends GameState<GamePage> with GameLogicMixin {
  @override
  Widget build(BuildContext context) => buildUI(context);
}
