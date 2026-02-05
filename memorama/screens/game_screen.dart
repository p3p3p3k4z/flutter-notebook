import 'package:flutter/material.dart' hide Card;
import '../models/card_model.dart';
import '../utils/load_cards.dart';
import 'dart:async';

// widget con estado porque el juego cambia constantemente
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  // crea la memoria del juego
  State<StatefulWidget> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // lista que guarda los datos de las cartas
  late List<Card> cards;
  // guarda la posicion de las dos cartas que tocamos
  List<int> selectedIndices = [];
  // evita que toquemos mas cartas mientras se comparan
  bool isChecking = false;

  // controla el reloj del juego
  Timer? timer;
  int elapsedSeconds = 0;
  bool gameFinished = false;

  @override
  // se ejecuta una sola vez al iniciar el juego
  void initState() {
    super.initState();
    // genera las cartas y arranca el reloj
    cards = generateCards();
    startTimer();
  }

  // crea un contador que suma uno cada segundo
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // actualiza la pantalla para mostrar el tiempo nuevo
      setState(() {
        elapsedSeconds++;
      });
    });
  }

  // funcion asincrona para esperar un segundo antes de voltear las cartas
  Future<void> checkForMatch() async {
    final firstIndex = selectedIndices[0];
    final secondIndex = selectedIndices[1];

    final firstCard = cards[firstIndex];
    final secondCard = cards[secondIndex];

    // pausa de un segundo para que el usuario vea las cartas
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      // si tienen el mismo id se quedan volteadas
      if (firstCard.id == secondCard.id) {
        firstCard.isMatched = true;
        secondCard.isMatched = true;
      } else {
        // si no coinciden se vuelven a tapar
        firstCard.isUp = false;
        secondCard.isUp = false;
      }

      if (cards.every((card) => card.isMatched)) {
        gameFinished = true;
        stopTimer();
      }
      // limpia la seleccion y permite tocar otra vez
      selectedIndices.clear();
      isChecking = false;
    });
  }

  // detiene el contador de segundos
  void stopTimer() {
    // cancela el proceso del reloj si existe
    timer?.cancel();
  }

  void resetGame() {
    timer?.cancel();

    setState(() {
      cards = generateCards();
      selectedIndices.clear();
      isChecking = false;
      gameFinished = false;
      elapsedSeconds = 0;
    });

    startTimer();
  }

  // logica al tocar una carta
  void onCardTapped(int index) {
    // si estamos comparando no hace nada
    if (isChecking) return;

    final card = cards[index];

    // si la carta ya esta volteada o ganada no hace nada
    if (card.isUp || card.isMatched) return;

    setState(() {
      // voltea la carta y la guarda en la lista de seleccionadas
      card.isUp = true;
      selectedIndices.add(index);
    });

    // si ya hay dos cartas seleccionadas inicia la comparacion
    if (selectedIndices.length == 2) {
      isChecking = true;
      checkForMatch();
    }
  }

  // dibuja cada carta individualmente
  Widget buildCard(Card card, int index) {
    // detecta el toque en la carta
    return GestureDetector(
      onTap: () => onCardTapped(index),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.blueGrey, blurRadius: 10)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          // muestra la imagen frontal o la trasera segun el estado
          child: Image.asset(
            card.isUp || card.isMatched
                ? card.imagePath
                : 'assets/images/back.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  // crea la cuadricula del tablero
  Widget buildGameBoard() {
    // genera elementos de forma eficiente segun la lista
    return GridView.builder(
      itemCount: cards.length,
      // define que habra 2 columnas con espacio entre ellas
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      // llama a la funcion de dibujar carta para cada posicion
      itemBuilder: (context, index) {
        return buildCard(cards[index], index);
      },
    );
  }

  // crea el widget que muestra el cronometro en pantalla
  Widget buildTimer() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // icono de reloj
          const Icon(Icons.timer, color: Colors.blue),
          const SizedBox(width: 10),
          // muestra los segundos acumulados
          Text(
            "Tiempo: $elapsedSeconds s",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Memorama"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              resetGame();
            },
            tooltip: 'Reiniciar juego',
          ),
        ],
      ),
      body: Column(
        children: [
          buildTimer(),
          SizedBox(height: 20),
          Expanded(child: buildGameBoard()),
        ],
      ),
    );
  }
}

//contexto es para saber propiedades de la pantalla (como color y tamañano)
//index es para saber cuantas veces van a iterar las cartas
