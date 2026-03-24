import 'package:flutter/material.dart';
import '../models/game_models.dart';

class WordGrid extends StatelessWidget {
  final List<List<BoardCell>> board;
  final Function(int, int) onCellTap; // Para diagonales (toque)
  final Function(int, int) onPanStart; // Para H/V (deslizar)
  final Function(int, int) onPanUpdate;
  final VoidCallback onPanEnd;

  const WordGrid({
    super.key,
    required this.board,
    required this.onCellTap,
    required this.onPanStart,
    required this.onPanUpdate,
    required this.onPanEnd,
  });

  @override
  Widget build(BuildContext context) {
    int size = board.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculamos el tamaño para que sea un cuadrado perfecto
        double maxSize = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;
        double cellSize = maxSize / size;

        return Center(
          child: SizedBox(
            width: maxSize,
            height: maxSize,
            child: GestureDetector(
              // Lógica de subrayado (H/V)
              onPanStart: (details) => _handleTouch(
                details.localPosition,
                cellSize,
                size,
                onPanStart,
              ),
              onPanUpdate: (details) => _handleTouch(
                details.localPosition,
                cellSize,
                size,
                onPanUpdate,
              ),
              onPanEnd: (_) => onPanEnd(),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: size,
                ),
                itemCount: size * size,
                itemBuilder: (context, index) {
                  int r = index ~/ size;
                  int c = index % size;
                  BoardCell cell = board[r][c];

                  return GestureDetector(
                    // Lógica de toque (Diagonales)
                    onTap: () => onCellTap(r, c),
                    child: Container(
                      margin: const EdgeInsets.all(0.5),
                      decoration: BoxDecoration(
                        color: cell.isSelected
                            ? Colors.yellow.withOpacity(0.8)
                            : (cell.isFound
                                  ? Colors.greenAccent.withOpacity(0.5)
                                  : Colors.white),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 0.5,
                        ),
                      ),
                      child: Center(
                        child: FittedBox(
                          child: Text(
                            cell.letter,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleTouch(
    Offset localPos,
    double cellSize,
    int size,
    Function(int, int) callback,
  ) {
    int col = (localPos.dx / cellSize).floor();
    int row = (localPos.dy / cellSize).floor();
    if (row >= 0 && row < size && col >= 0 && col < size) {
      callback(row, col);
    }
  }
}
