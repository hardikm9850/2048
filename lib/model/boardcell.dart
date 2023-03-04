class BoardCell {
  int row, column;
  int number = 0;
  bool isMerged = false;
  bool isNew = false;

  BoardCell(
      {required this.row,
      required this.column,
      required this.number,
      required this.isNew});

  bool isEmpty() {
    return number == 0;
  }

  @override
  int get hashCode {
    return number.hashCode;
  }

  @override
  bool operator ==(other) {
    return other is BoardCell && number == other.number;
  }

  @override
  String toString() {
    return "$number row $row column $column";
  }
}
