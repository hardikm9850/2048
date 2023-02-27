import 'dart:math' show Random;

import 'package:hardik_2048/model/snapshot.dart';

import '../model/boardcell.dart';
import '../storage/data_manager.dart';

class GameController {
  final int row = 4;
  final int column = 4;
  int _score = 0;
  int highScore = 0;
  bool _isGameOver = false;
  bool _isGameWon = false;

  late DataManager dataManager;
  late Snapshot snapshot;
  late List<List<BoardCell>> _boardCells;

  GameController();

  void init() {
    _isGameWon = _isGameOver = false;
    _score = 0;

    snapshot = Snapshot();
    _initialiseDataManager();
    _initialiseBoard();
    _resetMergeStatus();
    _randomEmptyCell(2);
    snapshot.saveGameState(_score, highScore, _boardCells);
  }

  BoardCell get(int r, int c) {
    return _boardCells[r][c];
  }

  void moveLeft() {
    snapshot.saveGameState(_score, highScore, _boardCells);
    if (!canMoveLeft()) {
      return;
    }
    for (int r = 0; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        mergeLeft(r, c);
      }
    }
    _resetMergeStatus();
    _randomEmptyCell(1);
  }

  void moveRight() {
    snapshot.saveGameState(_score, highScore, _boardCells);
    if (!canMoveRight()) {
      return;
    }
    for (int r = 0; r < row; ++r) {
      for (int c = column - 2; c >= 0; --c) {
        mergeRight(r, c);
      }
    }
    _resetMergeStatus();
    _randomEmptyCell(1);
  }

  void moveUp() {
    snapshot.saveGameState(_score, highScore, _boardCells);
    if (!canMoveUp()) {
      return;
    }
    for (int r = 0; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        mergeUp(r, c);
      }
    }
    _resetMergeStatus();
    _randomEmptyCell(1);
  }

  void moveDown() {
    snapshot.saveGameState(_score, highScore, _boardCells);
    if (!canMoveDown()) {
      return;
    }
    for (int r = row - 2; r >= 0; --r) {
      for (int c = 0; c < column; ++c) {
        mergeDown(r, c);
      }
    }
    _resetMergeStatus();
    _randomEmptyCell(1);
  }

  bool canMoveLeft() {
    for (int r = 0; r < row; ++r) {
      for (int c = 1; c < column; ++c) {
        if (canMerge(_boardCells[r][c], _boardCells[r][c - 1])) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveRight() {
    for (int r = 0; r < row; ++r) {
      for (int c = column - 2; c >= 0; --c) {
        if (canMerge(_boardCells[r][c], _boardCells[r][c + 1])) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveUp() {
    for (int r = 1; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        if (canMerge(_boardCells[r][c], _boardCells[r - 1][c])) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveDown() {
    for (int r = row - 2; r >= 0; --r) {
      for (int c = 0; c < column; ++c) {
        if (canMerge(_boardCells[r][c], _boardCells[r + 1][c])) {
          return true;
        }
      }
    }
    return false;
  }

  void mergeLeft(int r, int c) {
    while (c > 0) {
      merge(_boardCells[r][c], _boardCells[r][c - 1]);
      c--;
    }
  }

  void mergeRight(int r, int c) {
    while (c < column - 1) {
      merge(_boardCells[r][c], _boardCells[r][c + 1]);
      c++;
    }
  }

  void mergeUp(int r, int c) {
    while (r > 0) {
      merge(_boardCells[r][c], _boardCells[r - 1][c]);
      r--;
    }
  }

  void mergeDown(int r, int c) {
    while (r < row - 1) {
      merge(_boardCells[r][c], _boardCells[r + 1][c]);
      r++;
    }
  }

  bool canMerge(BoardCell a, BoardCell b) {
    return !b.isMerged &&
        ((b.isEmpty() && !a.isEmpty()) || (!a.isEmpty() && a == b));
  }

  void merge(BoardCell a, BoardCell b) {
    if (!canMerge(a, b)) {
      if (!a.isEmpty() && !b.isMerged) {
        b.isMerged = true;
      }
      return;
    }
    if (b.isEmpty()) {
      b.number = a.number;
      a.number = 0;
    } else if (a == b) {
      b.number = b.number * 2;
      a.number = 0;
      _score += b.number;
      b.isMerged = true;
    } else {
      b.isMerged = true;
    }
    setHighScore();
    _checkIfGameWon(b.number);
  }

  void checkIfIsGameOver() {
    var left = canMoveLeft();
    var right = canMoveRight();
    var top = canMoveUp();
    var down = canMoveDown();
    _isGameOver = (left || right || top || down) == false;
  }

  bool isGameOver(){
    return _isGameOver;
  }

  void _randomEmptyCell(int cnt) {
    List<BoardCell> emptyCells = <BoardCell>[];
    _boardCells.forEach((cells) {
      emptyCells.addAll(cells.where((cell) {
        return cell.isEmpty();
      }));
    });
    if (emptyCells.isEmpty) {
      checkIfIsGameOver();
      return;
    }
    Random r = Random();
    for (int i = 0; i < cnt && emptyCells.isNotEmpty; i++) {
      int index = r.nextInt(emptyCells.length);
      emptyCells[index].number = randomCellNum();
      emptyCells[index].isNew = true;
      emptyCells[index].isMerged = false;
    }
    checkIfIsGameOver();
  }

  int randomCellNum() {
    final Random r = Random();
    return r.nextInt(15) == 0 ? 4 : 2;
  }

  void _resetMergeStatus() {
    for (var cells in _boardCells) {
      for (var cell in cells) {
        cell.isMerged = false;
      }
    }
  }

  void reset() {
    _boardCells.clear();
    _resetMergeStatus();
    _score = 0;
    init();
  }

  void undo(){
    var previousState = snapshot.revertState();
    _score = previousState[SnapshotKeys.SCORE] as int;
    highScore = previousState[SnapshotKeys.HIGH_SCORE] as int;
    _isGameOver = false;
    _isGameWon = false;
    var cells = previousState[SnapshotKeys.BOARD];
    if(cells != null && cells is List<List<BoardCell>>) {
      List<List<BoardCell>> temp = [...cells];
      _boardCells.clear();
      _boardCells.addAll(temp);
    }
  }

  Future<void> _initialiseDataManager() async {
      dataManager = DataManager();
      highScore = await dataManager.getValue(StorageKeys.highScore) as int;
  }

  void setHighScore() {
    if (_score > highScore) {
      highScore = _score;
      dataManager.setValue(StorageKeys.highScore, highScore.toString());
    }
  }

  void _initialiseBoard() {
    _boardCells = <List<BoardCell>>[];
    for (int r = 0; r < row; r++) {
      _boardCells.add(<BoardCell>[]);
      for (int c = 0; c < column; c++) {
        _boardCells[r].add(BoardCell(
          row: r,
          column: c,
          number: 0,
          isNew: false,
        ));
      }
    }
  }

  void _checkIfGameWon(int number) {
    _isGameWon = number == 2048;
  }

  bool isGameWon(){
    return _isGameWon;
  }

  String getScore(){
    return _score.toString();
  }

  String getHighScore(){
    return highScore.toString();
  }

  List<List<BoardCell>> getBoardCells(){
    return _boardCells;
  }
}
