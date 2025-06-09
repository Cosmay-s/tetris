import 'package:tetris_cli/tetris_cli.dart';
import 'package:tetris_cli/src/ansi_cli_helper/ansi_cli_helper.dart' as ansi;

void main(List<String> arguments) {
  ansi.reset();
  ansi.hideCursor();

  initGame();
  start();
}