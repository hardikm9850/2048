import 'boardcell.dart';

class Snapshot {
  int _score = 0;
  int _highScore = 0;
  List<List<BoardCell>> cells = [];

  void saveGameState(int score, int highScore, List<List<BoardCell>> boardCells) {
    if(!isAnyCellEmpty(boardCells)){
      return;
    }
    print("Hey, ${boardCells.length}");
    _score = score;
    _highScore = highScore;
    storeList(boardCells);
    //printBoard(cells);
  }

  Map<String, Object> revertState() {
    //printBoard(cells);
    var result = {
      SnapshotKeys.SCORE: _score,
      SnapshotKeys.HIGH_SCORE: _highScore,
      SnapshotKeys.BOARD: cells
    };
    return result;
  }

  void printBoard(List<List<BoardCell>> boardCells) {
    try {
      print("### snapshot ------------");
      print("${cells[0][0].number} ${cells[0][1].number} ${cells[0][2].number} ${cells[0][3].number}");
      print("${cells[1][0].number} ${cells[1][1]} ${cells[1][2]} ${cells[1][3]}");
      print("${cells[2][0]} ${cells[2][1]} ${cells[2][2]} ${cells[2][3]}");
      print("${cells[3][0]} ${cells[3][1]} ${cells[3][2]} ${cells[3][3]}");
    } catch (e) {
      print(e);
    }
  }

  void printMe() {
    printBoard(cells);
  }

  void storeList(List<List<BoardCell>> boardCells) {
    cells = List.generate(
        4,
        (index) => List.generate(
            4,
            (column) => BoardCell(
                row: index, column: column, number: 0, isNew: false)));

    for (int r = 0; r < 4; r++) {
      for (int c = 0; c < 4; c++) {
        if (boardCells[r][c].number != 0) {
          cells[r][c].number = boardCells[r][c].number;
        }
      }
    }
  }

  bool isAnyCellEmpty(List<List<BoardCell>> boardCells) {
    List<BoardCell> emptyCells = <BoardCell>[];
    boardCells.forEach((cells) {
      emptyCells.addAll(cells.where((cell) {
        return cell.isEmpty();
      }));
    });
    return emptyCells.isNotEmpty;
  }

}

class SnapshotKeys {
  static String SCORE = "score";
  static String HIGH_SCORE = "high_score";
  static String BOARD = "board";
}
