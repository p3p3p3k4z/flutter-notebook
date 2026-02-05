import 'dart:math';
import 'package:flutter/material.dart' hide Card;

import '../models/card_model.dart';

// funcion para crear la baraja del juego
List<Card> generateCards() {
  // lista con los nombres de los archivos de imagen
  final List<String> images = [
    "assets/images/img01.png",
    "assets/images/img02.png",
    "assets/images/img03.png",
    "assets/images/img04.png",
  ];

  // lista vacia para guardar los objetos tipo carta
  List<Card> cards = [];

  // ciclo para crear las parejas necesarias
  for (int i = 0; i < images.length; i++) {
    // añade la primera carta de la pareja
    cards.add(Card(id: i, imagePath: images[i]));
    // añade la segunda carta con el mismo id para comparar
    cards.add(Card(id: i, imagePath: images[i]));
  }

  // mezcla la lista de forma aleatoria para que no salgan juntas
  cards.shuffle(Random());

  // devuelve la lista final de cartas barajadas
  return cards;
}
