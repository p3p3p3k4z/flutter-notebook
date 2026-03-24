import 'package:flutter/material.dart';
import '../models/game_models.dart';
import 'game_screen.dart';

class ResultScreen extends StatelessWidget {
  final bool hasWon;
  final int stars;
  final GameTheme theme;

  const ResultScreen({
    super.key,
    required this.hasWon,
    required this.stars,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hasWon ? Colors.green[50] : Colors.red[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasWon ? Icons.emoji_events : Icons.sentiment_dissatisfied,
              size: 70,
              color: hasWon ? Colors.amber : Colors.red,
            ),
            Text(
              hasWon ? "¡VICTORIA!" : "DERROTA",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (i) => Icon(
                  i < stars ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GameScreen(initialTheme: theme),
                  ),
                );
              },
              child: const Text(
                "REINICIAR JUEGO",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.popUntil(context, (route) => route.isFirst),
              child: Text(
                "VOLVER AL INICIO",
                style: TextStyle(color: theme.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
