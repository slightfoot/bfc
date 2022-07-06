import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:args/args.dart';
import 'package:bfc/lexer.dart';

typedef BfPutChar = void Function(int charCode);
typedef BgGetChar = int Function();

class BfInterpreter {
  BfInterpreter({
    required this.program,
    required this.memory,
    BfPutChar? putChar,
    BgGetChar? getChar,
  }) {
    this.putChar = putChar ?? stdout.writeCharCode;
    this.getChar = getChar ?? stdin.readByteSync;
  }

  final List<Token> program;
  final List<int> memory;
  late final BfPutChar putChar;
  late final BgGetChar getChar;

  final stack = Queue<int>();
  late int programPtr;
  late int memoryPtr;

  static List<int> allocateMemoryCells(ArgResults results) {
    final cellSize = int.tryParse(results['cell-size']) ?? 0;
    switch (cellSize) {
      case 8:
        return Uint8ClampedList(30000);
      case 16:
        return Uint16List(30000);
      default:
        print('cell-size of $cellSize invalid');
        exit(1);
    }
  }

  void run() {
    stack.clear();
    programPtr = 0;
    memoryPtr = 0;

    while (programPtr >= 0 && programPtr < program.length) {
      final token = program[programPtr];
      // print('${programPtr.toRadixString(16).padLeft(8)}: '
      //     '${String.fromCharCode(token)}');
      programPtr++;
      switch (token) {
        case Token.incPointer:
          memoryPtr++;
          break;
        case Token.decPointer:
          memoryPtr--;
          break;
        case Token.incMemory:
          memory[memoryPtr]++;
          break;
        case Token.decMemory:
          memory[memoryPtr]--;
          break;
        case Token.outputMemory:
          stdout.writeCharCode(memory[memoryPtr]);
          break;
        case Token.inputMemory:
          memory[memoryPtr] = stdin.readByteSync();
          break;
        case Token.loopStart:
          final value = memory[memoryPtr];
          if (value != 0) {
            stack.addLast(programPtr - 1);
          } else {
            programPtr = _findClosingBracket();
          }
          break;
        case Token.loopEnd:
          if (stack.isEmpty) {
            throw 'Unmatched closing bracket';
          }
          programPtr = stack.removeLast();
          break;
      }
    }
  }

  int _findClosingBracket() {
    int ref = 0, startPtr = programPtr - 1, endPtr = startPtr;
    do {
      final token = program[endPtr];
      if (token == Token.loopStart) {
        ref++;
      } else if (token == Token.loopEnd) {
        ref--;
      }
      endPtr++;
    } while (ref != 0 && endPtr < program.length);
    if (endPtr > program.length) {
      throw 'Matching bracket not found for: $startPtr';
    }
    return endPtr;
  }
}
