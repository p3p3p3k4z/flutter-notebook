import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/word_grid.dart';
import '../data/game_data.dart';
import '../logic/word_search_logic.dart';
import '../models/game_models.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  final GameTheme initialTheme;
  const GameScreen({super.key, required this.initialTheme});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameTheme currentTheme;
  late List<List<BoardCell>> board;
  List<BoardCell> currentSelection = [];
  List<String> foundWords = [];
  int? startR, startC;
  int timeLeft = 120;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    currentTheme = widget.initialTheme;
    _initNewGame();
  }

  void _initNewGame() {
    setState(() {
      board = WordSearchLogic.generateBoard(10, currentTheme.words);
      foundWords.clear();
      timeLeft = 120;
      currentSelection.clear();
    });
    _startTimer();
  }

  void _startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        _endGame(false);
      }
    });
  }

  void _onCellTap(int r, int c) {
    setState(() {
      BoardCell cell = board[r][c];
      if (cell.isSelected) {
        cell.isSelected = false;
        currentSelection.remove(cell);
      } else {
        cell.isSelected = true;
        currentSelection.add(cell);
      }
    });
    _validateWord();
  }

  void _onPanStart(int r, int c) {
    startR = r;
    startC = c;
  }

  void _updateLineSelection(int endR, int endC) {
    if (startR == null || startC == null) {
      return;
    }
    int diffR = endR - startR!;
    int diffC = endC - startC!;
    if (diffR == 0 || diffC == 0) {
      setState(() {
        _clearTempSelection();
        int stepR = diffR == 0 ? 0 : diffR.sign;
        int stepC = diffC == 0 ? 0 : diffC.sign;
        int steps = diffR.abs() > diffC.abs() ? diffR.abs() : diffC.abs();
        for (int i = 0; i <= steps; i++) {
          int currR = startR! + (i * stepR);
          int currC = startC! + (i * stepC);
          board[currR][currC].isSelected = true;
          currentSelection.add(board[currR][currC]);
        }
      });
    }
  }

  void _clearTempSelection() {
    for (var row in board) {
      for (var cell in row) {
        if (!cell.isFound) {
          cell.isSelected = false;
        }
      }
    }
    currentSelection.clear();
  }

  void _validateWord() {
    String selected = currentSelection.map((e) => e.letter).join();
    String reversed = selected.split('').reversed.join();
    if (currentTheme.words.contains(selected) ||
        currentTheme.words.contains(reversed)) {
      setState(() {
        for (var cell in currentSelection) {
          cell.isFound = true;
        }
        String word = currentTheme.words.contains(selected)
            ? selected
            : reversed;
        if (!foundWords.contains(word)) {
          foundWords.add(word);
        }
        _clearTempSelection();
      });
    }
    if (foundWords.length == currentTheme.words.length) {
      _endGame(true);
    }
  }

  void _endGame(bool win) {
    timer?.cancel();
    int starsCount = win ? 3 : (foundWords.length >= 3 ? 2 : 0);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ResultScreen(hasWon: win, stars: starsCount, theme: currentTheme),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: currentTheme.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isLandscape ? 40.0 : 80.0),
        child: AppBar(
          toolbarHeight: isLandscape ? 40.0 : 80.0,
          backgroundColor: currentTheme.primaryColor,
          centerTitle: true,
          elevation: 2,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            currentTheme.title.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: isLandscape ? 16 : 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Center(
                child: Text(
                  "$timeLeft s",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isLandscape ? 14 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: _buildDrawer(),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return Column(
                children: [
                  Expanded(
                    flex: 4, // La sopa ocupa la mayor parte
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: WordGrid(
                        board: board,
                        onCellTap: _onCellTap,
                        onPanStart: _onPanStart,
                        onPanUpdate: _updateLineSelection,
                        onPanEnd: () {
                          _validateWord();
                          setState(() => _clearTempSelection());
                        },
                      ),
                    ),
                  ),
                  // ÁREA DE PALABRAS CENTRADA EN EL ESPACIO RESTANTE
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min, // Hace que el bloque se agrupe
                        children: [
                          const Text(
                            "PALABRAS A BUSCAR",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 15),
                          _buildCenteredWordList(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: WordGrid(
                      board: board,
                      onCellTap: _onCellTap,
                      onPanStart: _onPanStart,
                      onPanUpdate: _updateLineSelection,
                      onPanEnd: () {
                        _validateWord();
                        setState(() => _clearTempSelection());
                      },
                    ),
                  ),
                  // LATERAL CENTRADO
                  Container(
                    width: 170,
                    color: Colors.black.withOpacity(0.04),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // CENTRADO VERTICAL EN EL LATERAL
                      children: [
                        const Text(
                          "PALABRAS A BUSCAR",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(indent: 20, endIndent: 20),
                        const SizedBox(height: 5),
                        Flexible(child: _buildSideWordList()),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildCenteredWordList() {
    return SingleChildScrollView(
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 20,
        runSpacing: 12,
        children: currentTheme.words.map((w) {
          bool f = foundWords.contains(w);
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                f ? Icons.check_circle : Icons.circle_outlined,
                size: 18,
                color: f ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                w,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: f ? Colors.green : Colors.black87,
                  decoration: f ? TextDecoration.lineThrough : null,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSideWordList() {
    return ListView.builder(
      shrinkWrap: true, // Importante para que el Column pueda centrarlo
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: currentTheme.words.length,
      itemBuilder: (context, index) {
        String w = currentTheme.words[index];
        bool f = foundWords.contains(w);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(
                f ? Icons.check_circle : Icons.circle_outlined,
                size: 14,
                color: f ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  w,
                  style: TextStyle(
                    fontSize: 12,
                    decoration: f ? TextDecoration.lineThrough : null,
                    color: f ? Colors.green : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawer() {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Drawer(
      width: 250,
      child: Column(
        children: [
          // CABECERA TOTALMENTE CENTRADA
          Container(
            height: isLandscape ? 100 : 160,
            width: double.infinity,
            color: currentTheme.primaryColor,
            alignment: Alignment.center, // FUERZA EL CENTRADO TOTAL
            child: const Text(
              "MENÚ DE TEMAS",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: appThemes
                  .map(
                    (t) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        tileColor: t.backgroundColor,
                        leading: Icon(t.icon, color: t.primaryColor),
                        title: Text(
                          t.title,
                          style: TextStyle(
                            color: t.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            currentTheme = t;
                          });
                          _initNewGame();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
