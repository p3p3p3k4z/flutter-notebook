import 'package:flutter/material.dart';

import '../models/card_model.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState(); //manejador del estado y clase privada
}

class _GameScreenState extends State<GameScreen> {
  late List<Card> cards; //late espera el dato 

  Widget buildCard(Card card,int index){
    return GestureDetector( //detectar el clik en la pantalla
    onTap: () => {},
    child: Container(
        decoration: BoxDecoration(
          color:Colors.red,
          boxShadow: BoxShadow(
            color: Colors.purple,
            blurRadius: 5,
            offset: Offset(3, 3)
          )
        )    
        ),
          child:ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(10),
          child: Image.asset(card.imagePath
            
          ),

      ),
    )
  }

  Widget buildGameBoard(){
    return GridView.builder(itemCount: cards.length , //para 0,1,2,3
      itemBuilder: (context,index){
      return build(cards[index], index);
        /**
        1 0
        0 1
        1 2
        **/
      },
    );
  }//contexto es para saber propiedades de la pantalla (como color y tamañano)
  //index es para saber cuantas veces van a iterar las cartas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Memorama :D")),
      body: Text("data"),
    );
  }
}
