import 'package:flutter/material.dart';

class BoardCell {
  final String letter;
  final int x; // Fila
  final int y; // Columna
  bool isFound; // Parte de una palabra ya descubierta
  bool isSelected; // Marcada actualmente por el dedo del usuario

  BoardCell({
    required this.letter,
    required this.x,
    required this.y,
    this.isFound = false,
    this.isSelected = false,
  });
}

class WordTheme {
  final String name;
  final List<String> words;
  final Color color;
  final IconData icon;

  WordTheme({
    required this.name,
    required this.words,
    required this.color,
    required this.icon,
  });
}
