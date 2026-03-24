import 'package:flutter/material.dart';

class BoardCell {
  final String letter;
  final int x, y;
  bool isFound;
  bool isSelected;

  BoardCell({
    required this.letter,
    required this.x,
    required this.y,
    this.isFound = false,
    this.isSelected = false,
  });
}

class GameTheme {
  final String title;
  final List<String> words;
  final Color primaryColor; // Color fuerte (AppBar, Botones)
  final Color backgroundColor; // Color suave (Fondo de pantalla)
  final IconData icon;

  GameTheme({
    required this.title,
    required this.words,
    required this.primaryColor,
    required this.backgroundColor,
    required this.icon,
  });
}
