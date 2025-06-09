import 'dart:async';
import 'dart:io';

import 'ansi_cli_helper/ansi_cli_helper.dart';

import 'blocks/blocks.dart';
import 'board.dart';

final class Game {
  late Board _board;
  StreamSubscription? _subscription;
  late Block currentBlock;
  late Block nextBlock;
  AnsiCliHelper ansiCliHelper;
  bool _isGameOver = false;
  int score = 0;

  Game(this.ansiCliHelper) {
    currentBlock = getNewRandomBlock();
    nextBlock = getNewRandomBlock();

    _board = Board(
      currentBlock: currentBlock,
      newBlockFunc: newBlock,
      updateScore: updateScore,
      updateBlock: updateBlock,
      gameOver: gameOver,
      ansiCliHelper: ansiCliHelper,
    );
    keyboardEventHandler();
  }


  void updateBlock(Block block) {
    currentBlock = block;
  }


  void updateScore() {
    score += 10;
  }


  Block newBlock() {
    currentBlock = nextBlock;
    nextBlock = getNewRandomBlock();
    return currentBlock;
  }


  void keyboardEventHandler() {
    stdin.echoMode = false;
    stdin.lineMode = false;
    _subscription = stdin.listen((data) {
      int key = data.first;
      _board.keyboardEventHandler(key);
    });
  }


  Future<void> start() async {

    while (!isGameOver) {
      nextStep();
      printScore();
      await Future.delayed(const Duration(milliseconds: 500));
    }


    _subscription?.cancel();
    ansiCliHelper.setTextColor(AnsiTextColor.yellow);
    ansiCliHelper.gotoxy(0, 22);
    stdout.write('===============\n'
        '~~~Game Over~~~\n'
        '===============\n');
    ansiCliHelper.setBackgroundColor(AnsiBackgroundColor.blue);
    stdout.writeln('Score: $score ');
    await Future.delayed(const Duration(seconds: 5));
    ansiCliHelper.reset();
  }

  void printScore() {
    ansiCliHelper.gotoxy(30, 10);
    ansiCliHelper.setTextColor(AnsiTextColor.red);
    ansiCliHelper.write('Score:   $score');
    ansiCliHelper.setTextColor(AnsiTextColor.white);
  }

  bool get isGameOver => _isGameOver;

  void gameOver(){
    _isGameOver = true;
  }

  void nextStep() {
    var x = currentBlock.x;
    var y = currentBlock.y;

    if (!_board.isFilledBlock(x, y + 1)) {
      _board.moveBlock(x, y + 1);
    } else {
      _board.clearLine();
      _board.savePresentBoardToCpy();
      _board.newBlock();
      _board.drawBoard();
    }
  }
}