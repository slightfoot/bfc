import 'dart:io';

import 'package:bfc/lexer.dart';
import 'package:bfc/output/i386-windows.dart';

class BfCompiler {
  BfCompiler({
    required this.program,
  });

  final List<Token> program;

  void run(String exeName, String asmName, {bool assemblyOnly = false}) {
    final code = StringBuffer();
    for (int i = 0; i < program.length; i++) {
      final token = program[i];
      switch (token) {
        case Token.incPointer:
        case Token.decPointer:
        case Token.incMemory:
        case Token.decMemory:
          int j = i;
          while (j < program.length && token == program[j]) {
            j++;
          }
          final repeat = (j - i);
          if (repeat > 1) {
            switch (token) {
              case Token.incPointer:
                code.writeln('add  esi, $repeat');
                break;
              case Token.decPointer:
                code.writeln('sub  esi, $repeat');
                break;
              case Token.incMemory:
                code.writeln('add  byte [esi], $repeat');
                break;
              case Token.decMemory:
                code.writeln('sub  byte [esi], $repeat');
                break;
              default:
                throw FallThroughError();
            }
          } else {
            switch (token) {
              case Token.incPointer:
                code.writeln('inc  esi');
                break;
              case Token.decPointer:
                code.writeln('dec  esi');
                break;
              case Token.incMemory:
                code.writeln('inc  byte [esi]');
                break;
              case Token.decMemory:
                code.writeln('dec  byte [esi]');
                break;
              default:
                throw FallThroughError();
            }
          }
          i = j - 1;
          break;
        case Token.outputMemory:
          code.writeln('call putchar');
          break;
        case Token.inputMemory:
          code.writeln('call getchar');
          break;
        case Token.loopStart:
          code.writeln('m_open');
          break;
        case Token.loopEnd:
          code.writeln('m_close');
          break;
      }
    }

    final i386code = i386windows(code.toString().replaceAll('\n', '\n    '));
    File(asmName).writeAsStringSync(i386code);

    if (!assemblyOnly) {
      final nasm = Process.runSync('nasm', ['-f', 'win32', '-o', 'temp.obj', asmName]);
      if (nasm.exitCode != 0) {
        stdout.write(nasm.stdout);
        stderr.write(nasm.stderr);
        exit(1);
      }
      final link = Process.runSync('golink.exe', [
        '/console',
        '/entry',
        '_start',
        'temp.obj',
        'msvcrt.dll',
        'kernel32.dll',
        '/fo',
        exeName,
      ]);
      if (link.exitCode != 0) {
        stdout.write(link.stdout);
        stderr.write(link.stderr);
        exit(1);
      }
      //File('temp.obj').deleteSync();
      //File(asmName).deleteSync();
    }
  }
}
