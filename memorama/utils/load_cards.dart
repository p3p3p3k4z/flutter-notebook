

import 'dart:math';
import 'package:flutter/material.dart';

import '../models/card_model.dart';

List<Card> generateCards(){
  final List<String> images =[
    "img01.png",
    "img02.png",
    "img03.png",
    "img04.png",
    ]
  
  List<Card> cards = [];

  for (int i=0; i<images.length;i++) {
    cards.add(Card(id:i, imagePath: images[i]));
    cards.add(Card(id:i, imagePath: images[i]));
    // se usa asi debido a que son 2 cartas por descubir memeoriama
  }
  //barajear  
  cards.shuffle(Random());
  return cards;

}
