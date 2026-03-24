import 'package:flutter/material.dart';
import '../models/word_search_model.dart';

// Widget que dibuja el tablero y detecta el arrastre
class WordSearchGrid extends StatelessWidget {
  final List<List<BoardCell>> board;
  final Function(int, int) onPanUpdate;
  final VoidCallback onPanEnd;

  const WordSearchGrid({
    super.key,
    required this.board,
    required this.onPanUpdate,
    required this.onPanEnd,
  });

  @override
  Widget build(BuildContext context) {
    int size = board.length;

    return GestureDetector(
      onPanUpdate: (details) {
        // Calculamos qué celda se está tocando basándonos en la posición local
        RenderBox box = context.findRenderObject() as RenderBox;
        Offset localOffset = box.globalToLocal(details.globalPosition);
        double cellSize = box.size.width / size;

        int col = (localOffset.dx / cellSize).floor();
        int row = (localOffset.dy / cellSize).floor();

        if (row >= 0 && row < size && col >= 0 && col < size) {
          onPanUpdate(row, col);
        }
      },
      onPanEnd: (_) => onPanEnd(),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          color: Colors.grey[300],
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: size,
            ),
            itemCount: size * size,
            itemBuilder: (context, index) {
              int r = index ~/ size;
              int c = index % size;
              BoardCell cell = board[r][c];

              return Container(
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: cell.isSelected
                      ? Colors.yellow
                      : (cell.isFound ? Colors.greenAccent : Colors.white),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    cell.letter,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
