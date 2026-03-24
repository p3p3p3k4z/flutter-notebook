import 'dart:math';
import '../models/game_models.dart';

class WordSearchLogic {
  static List<List<BoardCell>> generateBoard(int size, List<String> words) {
    List<List<String?>> matrix = List.generate(
      size,
      (_) => List.filled(size, null),
    );
    final random = Random();

    for (String word in words) {
      bool placed = false;
      int attempts = 0;
      word = word.toUpperCase();

      while (!placed && attempts < 100) {
        int row = random.nextInt(size);
        int col = random.nextInt(size);
        int dRow =
            random.nextInt(3) - 1; // Dirección horizontal/vertical/diagonal
        int dCol = random.nextInt(3) - 1;

        if (dRow == 0 && dCol == 0) continue;

        if (_canPlace(matrix, word, row, col, dRow, dCol, size)) {
          for (int i = 0; i < word.length; i++) {
            matrix[row + i * dRow][col + i * dCol] = word[i];
          }
          placed = true;
        }
        attempts++;
      }
    }

    // Rellenar con letras aleatorias
    return List.generate(
      size,
      (r) => List.generate(size, (c) {
        return BoardCell(
          letter: matrix[r][c] ?? String.fromCharCode(random.nextInt(26) + 65),
          x: r,
          y: c,
        );
      }),
    );
  }

  static bool _canPlace(
    List<List<String?>> m,
    String w,
    int r,
    int c,
    int dr,
    int dc,
    int s,
  ) {
    for (int i = 0; i < w.length; i++) {
      int nr = r + i * dr;
      int nc = c + i * dc;
      if (nr < 0 || nr >= s || nc < 0 || nc >= s) return false;
      if (m[nr][nc] != null && m[nr][nc] != w[i]) return false;
    }
    return true;
  }
}
