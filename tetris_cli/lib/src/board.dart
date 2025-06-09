import 'blocks/blocks.dart';
import 'ansi_cli_helper/ansi_cli_helper.dart';

class Board {
  static const int heightBoard = 20;
  static const int widthBoard = 10;
  static const int posFree = 0;
  static const int posFilled = 1;
  static const int posBoarder = 2;

  late List<List<int>> mainBoard;
  late List<List<int>> mainCpy;


  Block Function() newBlockFunc;


  void Function() updateScore;


  void Function(Block block) updateBlock;


  void Function() gameOver;

  Block currentBlock; 
  AnsiCliHelper ansiCliHelper;

  Board({
    required this.newBlockFunc,
    required this.currentBlock,
    required this.updateScore,
    required this.updateBlock,
    required this.ansiCliHelper,
    required this.gameOver,
  }) {
    mainBoard = List.generate(
      heightBoard,
      (_) => List.filled(widthBoard, 0),
    );
    mainCpy = List.generate(
      heightBoard,
      (_) => List.filled(widthBoard, 0),
    );
    initDrawMain();
  }


  void keyboardEventHandler(int key) {
    var x = currentBlock.x;
    var y = currentBlock.y;

    switch (key) {
      case 119:
        rotateBlock();
      case 97:
        if (!isFilledBlock(x - 1, y)) {
          moveBlock(x - 1, y);
        }
      case 115:
        if (!isFilledBlock(x, y + 1)) {
          moveBlock(x, y + 1);
        }
      case 100: 
        if (!isFilledBlock(x + 1, y)) {
          moveBlock(x + 1, y);
        }
    }
  }


  void savePresentBoardToCpy() {
    for (int i = 0; i < heightBoard - 1; i++) {
      for (int j = 0; j < widthBoard - 1; j++) {
        mainCpy[i][j] = mainBoard[i][j];
      }
    }
  }


  void initDrawMain() {
    for (int i = 0; i <= heightBoard - 2; i++) {
      for (int j = 0; j <= widthBoard - 2; j++) {
        if (j == 0 || j == widthBoard - 2 || i == heightBoard - 2) {
          mainBoard[i][j] = posBoarder;
          mainCpy[i][j] = posBoarder;
        }
      }
    }

    newBlock();
    drawBoard();
  }

  void drawBoard() {
    ansiCliHelper.gotoxy(0, 0);
    for (int i = 0; i < heightBoard - 2; i++) {
      for (int j = 0; j < widthBoard - 1; j++) {
        switch (mainBoard[i][j]) {
          case posFree:
            ansiCliHelper.write('⬛');
          case posFilled:
            ansiCliHelper.write('⬜');
          case posBoarder:
            ansiCliHelper.write('🟥');
        }
      }
      ansiCliHelper.write('\n');
    }
    ansiCliHelper.write('🟥');
    ansiCliHelper.write('${'🟥' * 8}\n');
  }


  void newBlock() {
    currentBlock = newBlockFunc();
    var x = currentBlock.x;


    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        mainBoard[i][x + j] = mainCpy[i][x + j] + currentBlock[i][j];


        if (mainBoard[i][x + j] > 1) {
          gameOver(); 
        }
      }
    }
  }


  void moveBlock(int x2, int y2) {

    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (currentBlock.x + j >= 0) {
          mainBoard[currentBlock.y + i][currentBlock.x + j] -=
              currentBlock[i][j];
        }
      }
    }


    currentBlock.move(x2, y2);

    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {

        if (currentBlock.x + j >= 0) {
          mainBoard[currentBlock.y + i][currentBlock.x + j] +=
              currentBlock[i][j];
        }
      }
    }

    drawBoard();
  }


  void rotateBlock() {
 
    var tmpBlock = currentBlock.copyWith();
    currentBlock.rotate();


    if (isFilledBlock(tmpBlock.x, tmpBlock.y)) {
      currentBlock = tmpBlock;

      updateBlock(currentBlock); 
    }

    var x = currentBlock.x;
    var y = currentBlock.y;


    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {

        mainBoard[y + i][x + j] -= tmpBlock[i][j];
        

        mainBoard[y + i][x + j] += currentBlock[i][j];
      }
    }

    drawBoard();
  }


  void clearLine() {
    for (int j = 0; j <= heightBoard - 3; j++) {

      int i = 1;
      while (i <= widthBoard - 3) {
        if (mainBoard[j][i] == posFree) {
          break;
        }
        i++;
      }

      if (i == widthBoard - 2) {

        for (int k = j; k > 0; k--) {
          for (int idx = 1; idx <= widthBoard - 3; idx++) {
            mainBoard[k][idx] = mainBoard[k - 1][idx];
          }
        }
        updateScore(); 
      }
    }
  }


  bool isFilledBlock(int x2, int y2) {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (currentBlock[i][j] != 0 && mainCpy[y2 + i][x2 + j] != 0) {
          return true;
        }
      }
    }
    return false;
  }
} 