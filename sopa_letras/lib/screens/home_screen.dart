import 'package:flutter/material.dart';
import 'game_screen.dart';
import '../data/game_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final bool isLand = orientation == Orientation.landscape;

    // Paleta de colores Galáctica
    const Color electricPurple = Color(0xFFBB86FC);
    const Color deepBlue = Color(0xFF1A237E);
    const Color vividPurple = Color(0xFF6200EA);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [deepBlue, Color(0xFF311B92), vividPurple],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Margen superior mínimo
                  SizedBox(height: isLand ? 5 : 40),

                  // --- LOGO ESCALADO ---
                  _buildLogo(electricPurple, isLand),

                  SizedBox(height: isLand ? 5 : 20),

                  // --- TÍTULO ---
                  Text(
                    "SOPA DE LETRAS",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isLand ? 26 : 42,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: isLand ? 2 : 4,
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: electricPurple.withAlpha(150),
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),

                  // --- LA FRASE (AHORA SIEMPRE VISIBLE) ---
                  Text(
                    "Desafía tu mente",
                    style: TextStyle(
                      fontSize: isLand ? 14 : 18,
                      color: Colors.white.withAlpha(200),
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1.2,
                    ),
                  ),

                  SizedBox(height: isLand ? 15 : 50),

                  // --- BOTÓN ---
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: electricPurple,
                      foregroundColor: deepBlue,
                      padding: EdgeInsets.symmetric(
                        horizontal: isLand ? 40 : 60,
                        vertical: isLand ? 12 : 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 8,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              GameScreen(initialTheme: appThemes[0]),
                        ),
                      );
                    },
                    child: Text(
                      "JUGAR AHORA",
                      style: TextStyle(
                        fontSize: isLand ? 16 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Margen inferior mínimo
                  SizedBox(height: isLand ? 10 : 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(Color accent, bool isLand) {
    // Reducimos el tamaño en horizontal para que la frase tenga espacio
    final double size = isLand ? 80.0 : 150.0;
    final double iconSize = isLand ? 55.0 : 100.0;
    final double fontSizeS = isLand ? 24.0 : 40.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(20),
            borderRadius: BorderRadius.circular(isLand ? 15 : 25),
            border: Border.all(color: Colors.white.withAlpha(40), width: 1.5),
          ),
          child: GridView.count(
            crossAxisCount: 3,
            padding: EdgeInsets.all(isLand ? 10 : 15),
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              9,
              (i) => Center(
                child: Text(
                  "?",
                  style: TextStyle(
                    color: Colors.white.withAlpha(25),
                    fontWeight: FontWeight.bold,
                    fontSize: isLand ? 10 : 18,
                  ),
                ),
              ),
            ),
          ),
        ),
        Icon(Icons.search_rounded, size: iconSize, color: accent),
        Positioned(
          // Ajuste de posición de la letra "S" dentro de la lupa
          top: isLand ? 23 : 45,
          left: isLand ? 28 : 55,
          child: Text(
            "S",
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSizeS,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: accent,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
