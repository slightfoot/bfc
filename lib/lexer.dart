import 'dart:io';

import 'package:charcode/charcode.dart';

enum Token {
  incPointer,
  decPointer,
  incMemory,
  decMemory,
  outputMemory,
  inputMemory,
  loopStart,
  loopEnd,
}

class BfLexer {
  const BfLexer();

  static List<Token> fromFile(String filename) {
    final program = File(filename).readAsStringSync().codeUnits;
    return BfLexer().run(program);
  }

  List<Token> run(List<int> program) {
    return List.unmodifiable(program.map(tokenForCharCode).whereType<Token>());
  }

  Token? tokenForCharCode(int charCode) {
    switch (charCode) {
      case $greater_than:
        return Token.incPointer;
      case $less_than:
        return Token.decPointer;
      case $plus:
        return Token.incMemory;
      case $minus:
        return Token.decMemory;
      case $fullstop:
        return Token.outputMemory;
      case $comma:
        return Token.inputMemory;
      case $open_bracket:
        return Token.loopStart;
      case $close_bracket:
        return Token.loopEnd;
      default:
        return null;
    }
  }
}
