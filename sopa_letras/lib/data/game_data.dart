import 'package:flutter/material.dart';
import '../models/game_models.dart';

final List<GameTheme> appThemes = [
  GameTheme(
    title: "Espacio",
    words: ["PLANETA", "ASTEROIDE", "SOL", "GALAXIA", "NASA"],
    primaryColor: Colors.indigo,
    backgroundColor: const Color(0xFFE8EAF6), // Indigo muy claro
    icon: Icons.rocket_launch,
  ),
  GameTheme(
    title: "Frutas",
    words: ["MANZANA", "PERA", "PLATANO", "SANDIA", "UVA"],
    primaryColor: Colors.orange,
    backgroundColor: const Color(0xFFFFF3E0), // Naranja claro
    icon: Icons.apple,
  ),
  GameTheme(
    title: "Código",
    words: ["FLUTTER", "DART", "WIDGET", "DEBUG", "APP"],
    primaryColor: Colors.teal,
    backgroundColor: const Color(0xFFE0F2F1),
    icon: Icons.code,
  ),
  GameTheme(
    title: "Animales",
    words: ["TIGRE", "CEBRA", "DELFIN", "AGUILA", "COBRA"],
    primaryColor: Colors.brown,
    backgroundColor: const Color(0xFFEFEBE9),
    icon: Icons.pets,
  ),
  GameTheme(
    title: "Países",
    words: ["MEXICO", "ESPAÑA", "JAPON", "ITALIA", "EGIPTO"],
    primaryColor: Colors.redAccent,
    backgroundColor: const Color(0xFFFFEBEE),
    icon: Icons.public,
  ),
  GameTheme(
    title: "Deportes",
    words: ["FUTBOL", "TENIS", "BOXEO", "NATACION", "GOLF"],
    primaryColor: Colors.green,
    backgroundColor: const Color(0xFFE8F5E9),
    icon: Icons.sports_soccer,
  ),
  GameTheme(
    title: "Colores",
    words: ["AMARILLO", "MORADO", "BLANCO", "NEGRO", "ROSADO"],
    primaryColor: Colors.pinkAccent,
    backgroundColor: const Color(0xFFFCE4EC),
    icon: Icons.palette,
  ),
  GameTheme(
    title: "Música",
    words: ["PIANO", "GUITARRA", "FLAUTA", "VIOLIN", "RITMO"],
    primaryColor: Colors.deepPurple,
    backgroundColor: const Color(0xFFF3E5F5),
    icon: Icons.music_note,
  ),
  GameTheme(
    title: "Naturaleza",
    words: ["BOSQUE", "OCEANO", "MONTAÑA", "LLUVIA", "VIENTO"],
    primaryColor: Colors.lightGreen,
    backgroundColor: const Color(0xFFF1F8E9),
    icon: Icons.terrain,
  ),
];
