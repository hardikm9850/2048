import 'dart:async';
import 'dart:math' show Random;

import 'package:get/get.dart';
import 'package:hardik_2048/model/snapshot.dart';

import '../model/boardcell.dart';
import '../storage/data_manager.dart';

class GameController extends GetxController {

  final int row = 4;
  final int column = 4;
  var score = 0.obs;
  var highScore = 0.obs;
  var numberOfMoves = 0.obs;
  var isGameOver = false.obs;
  var isGameWon = false.obs;

  late DataManager dataManager;
  late Snapshot snapshot;
  final reactiveBoardCells = <RxList<Rx<BoardCell>>>[].obs;
  final list = <Rx<BoardCell>>[].obs;

  static const String _defaultInitialTimerValue = '0';
  late Timer _timerObj;
  var timer = _defaultInitialTimerValue.obs;
  
  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() {
    isGameWon.value = isGameOver.value = false;
    score.value = 0;
    numberOfMoves.value = 0;
    timer.value = '0';

    snapshot = Snapshot();
    _initialiseDataManager();
    _initialiseBoard();
    _resetMergeStatus();
    _randomEmptyCell(2);
    _saveSnapShot();
  }


  void _saveSnapShot() {
    snapshot.saveGameState(
      score.value,
      highScore.value,
      numberOfMoves.value,
      reactiveBoardCells,
    );
  }

  void _incrementNumberOfMoves() {
    numberOfMoves.value++;
  }

  void moveLeft() {
    _saveSnapShot();
    if (!canMoveLeft()) {
      return;
    }
    _incrementNumberOfMoves();
    for (int r = 0; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        mergeLeft(r, c);
      }
    }
    _resetMergeStatus();
    _randomEmptyCell(1);
  }

  void moveRight() {
    _saveSnapShot();
    if (!canMoveRight()) {
      return;
    }
    _incrementNumberOfMoves();
    for (int r = 0; r < row; ++r) {
      for (int c = column - 2; c >= 0; --c) {
        mergeRight(r, c);
      }
    }
    _resetMergeStatus();
    _randomEmptyCell(1);
  }

  void moveUp() {
    _saveSnapShot();
    if (!canMoveUp()) {
      return;
    }
    _incrementNumberOfMoves();
    for (int r = 0; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        mergeUp(r, c);
      }
    }
    _resetMergeStatus();
    _randomEmptyCell(1);
  }

  void moveDown() {
    _saveSnapShot();
    if (!canMoveDown()) {
      return;
    }
    _incrementNumberOfMoves();
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
        if (canMerge(reactiveBoardCells[r][c], reactiveBoardCells[r][c - 1])) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveRight() {
    for (int r = 0; r < row; ++r) {
      for (int c = column - 2; c >= 0; --c) {
        if (canMerge(reactiveBoardCells[r][c], reactiveBoardCells[r][c + 1])) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveUp() {
    for (int r = 1; r < row; ++r) {
      for (int c = 0; c < column; ++c) {
        if (canMerge(reactiveBoardCells[r][c], reactiveBoardCells[r - 1][c])) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveDown() {
    for (int r = row - 2; r >= 0; --r) {
      for (int c = 0; c < column; ++c) {
        if (canMerge(reactiveBoardCells[r][c], reactiveBoardCells[r + 1][c])) {
          return true;
        }
      }
    }
    return false;
  }

  void mergeLeft(int r, int c) {
    while (c > 0) {
      merge(reactiveBoardCells[r][c], reactiveBoardCells[r][c - 1]);
      reactiveBoardCells.refresh();
      c--;
    }
  }

  void mergeRight(int r, int c) {
    while (c < column - 1) {
      merge(reactiveBoardCells[r][c], reactiveBoardCells[r][c + 1]);
      reactiveBoardCells.refresh();
      c++;
    }
  }

  void mergeUp(int r, int c) {
    while (r > 0) {
      merge(reactiveBoardCells[r][c], reactiveBoardCells[r - 1][c]);
      reactiveBoardCells.refresh();
      r--;
    }
  }

  void mergeDown(int r, int c) {
    while (r < row - 1) {
      //merge(boardCells[r][c], boardCells[r + 1][c]);
      merge(reactiveBoardCells[r][c], reactiveBoardCells[r + 1][c]);
      reactiveBoardCells.refresh();
      r++;
    }
  }

  bool canMerge(Rx<BoardCell> itemA, Rx<BoardCell> itemB) {
    var a = itemA.value;
    var b = itemB.value;
    return !b.isMerged &&
        ((b.isEmpty() && !a.isEmpty()) || (!a.isEmpty() && a == b));
  }

  void merge(Rx<BoardCell> itemA, Rx<BoardCell> itemB) {
    var a = itemA.value;
    var b = itemB.value;

    if (!canMerge(itemA, itemB)) {
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
      b.isMerged = true;
      a.number = 0;
      score.value += b.number;
      score.refresh();
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
    isGameOver.value = (left || right || top || down) == false;
    isGameOver.refresh();
    // ramzi print("is game over? ${isGameOver.value}");
  }

  void _randomEmptyCell(int cnt) {
    List<BoardCell> emptyCells = <BoardCell>[];

    for (var element in reactiveBoardCells) {
      var ans = element.value.where((element) => element.value.isEmpty());
      emptyCells.addAll(ans.map((e) => e.value));
    }
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
    for (var element in emptyCells) {
      reactiveBoardCells[element.row][element.column].update((val) {
        val?.row = element.row;
        val?.column = element.column;
        val?.number = element.number;
        val?.isNew = element.isNew;
      });
    }
    checkIfIsGameOver();
  }

  int randomCellNum() {
    final Random r = Random();
    return r.nextInt(15) == 0 ? 4 : 2;
  }

  void _resetMergeStatus() {
    for (var cells in reactiveBoardCells) {
      for (var cell in cells) {
        cell.update((val) {
          val?.isMerged = false;
        });
      }
    }
  }

  void reset() {
    reactiveBoardCells.clear();
    _resetMergeStatus();
    score.value = 0;
    resetTimer();
    init();
  }

  void undo() {
    var previousState = snapshot.revertState();
    score.value = previousState[SnapshotKeys.SCORE] as int;
    highScore.value = previousState[SnapshotKeys.HIGH_SCORE] as int;
    numberOfMoves.value = previousState[SnapshotKeys.NUMBER_OF_MOVES] as int;
    isGameOver.value = false;
    isGameWon.value = false;
    var cells = previousState[SnapshotKeys.BOARD];
    if (cells != null && cells is List<List<BoardCell>>) {
      reactiveBoardCells.clear();
      for (int r = 0; r < row; r++) {
        reactiveBoardCells.add(<Rx<BoardCell>>[].obs);
        for (int c = 0; c < column; c++) {
          var cell = BoardCell(
            row: r,
            column: c,
            number: cells[r][c].number,
            isNew: cells[r][c].isNew,
          );
          reactiveBoardCells[r].add(cell.obs);
          reactiveBoardCells.refresh();
        }
      }
    }
  }

  Future<void> _initialiseDataManager() async {
    dataManager = DataManager();
    var result = await dataManager.getValue(StorageKeys.highScore); // as int;
    highScore.value = int.parse(result);
  }

  void setHighScore() {
    if (score.value > highScore.value) {
      highScore.value = score.value;
      highScore.refresh();
      dataManager.setValue(StorageKeys.highScore, highScore.toString());
    }
  }

  void _initialiseBoard() {
    for (int r = 0; r < row; r++) {
      reactiveBoardCells.add(<Rx<BoardCell>>[].obs);
      for (int c = 0; c < column; c++) {
        var cell = BoardCell(
          row: r,
          column: c,
          number: 0,
          isNew: false,
        );
        reactiveBoardCells[r].add(cell.obs);
        reactiveBoardCells.refresh();
      }
    }
  }

  void _checkIfGameWon(int number) {
    isGameWon.value = number == 16;
  }

  String getScore() {
    return score.toString();
  }


  void startTimer() {
    if(timer.value == _defaultInitialTimerValue) {
      _timerObj = Timer.periodic(const Duration(seconds: 1), (_) {
        timer.value = (int.parse(timer.value) + 1).toString();
      });
    }
  }

  void stopTimer() {
    _timerObj.cancel();
  }

  void resetTimer() {
    stopTimer();
    timer.value = _defaultInitialTimerValue;
  }
}
