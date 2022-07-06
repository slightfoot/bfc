import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';
import 'package:args/args.dart';
import 'package:charcode/charcode.dart';

void main(List<String> arguments) {
  var parser = ArgParser();
  parser.addOption(
    'cell-size',
    abbr: 'c',
    help: 'Sets the BF cell-size',
    defaultsTo: '16',
  );

  if (arguments.isEmpty) {
    print('BF Usage: ${Platform.script}\n');
    print(parser.usage);
    exit(1);
  }

  final results = parser.parse(arguments);
  int cellSize = int.tryParse(results['cell-size']) ?? 0;
  if (cellSize != 8 && cellSize != 16) {
    print('cell-size of $cellSize invalid');
    exit(1);
  }

  final program = File(arguments[0]).readAsStringSync().codeUnits;

  late List<int> cells;
  if (cellSize == 8) {
    cells = Uint8ClampedList(30000);
  } else if (cellSize == 16) {
    cells = Uint16List(30000);
  }

  final stack = Queue<int>();
  int ptr = 0, ip = 0;

  while (ip >= 0 && ip < program.length) {
    final instruction = program[ip];
    // print('${ip.toRadixString(16).padLeft(8)}: ${String.fromCharCode(instruction)}');
    ip++;
    switch (instruction) {
      case $greater_than:
        ptr++;
        break;
      case $less_than:
        ptr--;
        break;
      case $plus:
        cells[ptr]++;
        break;
      case $minus:
        cells[ptr]--;
        break;
      case $fullstop:
        stdout.writeCharCode(cells[ptr]);
        break;
      case $comma:
        cells[ptr] = stdin.readByteSync();
        break;
      case $open_bracket:
        final value = cells[ptr];
        if (value != 0) {
          stack.addLast(ip - 1);
        } else {
          ip = findClosingBracket(program, ip - 1);
        }
        break;
      case $close_bracket:
        if (stack.isEmpty) {
          throw 'Unmatched closing bracket';
        }
        ip = stack.removeLast();
        break;
    }
  }
}

int findClosingBracket(List<int> program, int ip) {
  int ref = 0, bip = ip;
  do {
    final instruction = program[bip];
    if (instruction == $open_bracket) {
      ref++;
    } else if (instruction == $close_bracket) {
      ref--;
    }
    bip++;
  } while (ref != 0 && bip < program.length);
  if (bip >= program.length) {
    throw 'Matching bracket not found for: $ip';
  }
  return bip;
}
