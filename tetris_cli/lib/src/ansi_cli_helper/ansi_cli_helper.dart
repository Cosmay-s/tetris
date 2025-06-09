import 'dart:io';
import 'ansi_background_colors.dart';
import 'ansi_text_colors.dart';

export 'ansi_background_colors.dart';
export 'ansi_text_colors.dart';


final class AnsiCliHelper {
    static AnsiCliHelper? _instanse;
    bool _isHideCursor = false;

    AnsiCliHelper._();

    factory AnsiCliHelper() {
        return _instanse ??= AnsiCliHelper._();    
    }

    bool get isHideCursor => _isHideCursor;

    void showCursor() {
        if (_isHideCursor) {
            stdout.write('\u001b[?25h');
            _isHideCursor = false;
        }
    }

    void clear() {
        stdout.write('\u001b[2J\u001b[0;0H');
    }

    void reset() {
        setTextColor(AnsiTextColor.white);
        setBackgroundColor(AnsiBackgroundColor.black);
        clear();
        showCursor();
    }

    void write(String text) {
        stdout.write(text);
    }

    void writeLine(String text) {
        stdout.writeln(text);
    }

  void setTextColor(AnsiTextColor color) {
    stdout.write(color.ansiText);
  }


  void setBackgroundColor(AnsiBackgroundColor color) {
    stdout.write(color.ansiText);
  }


  void gotoxy(int x, int y) {
    if (x < 0 || y < 0) {
      return;
    }
    stdout.write('\u001b[$y;${x}H');
  }
}