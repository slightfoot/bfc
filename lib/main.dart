import 'dart:io';
import 'package:args/args.dart';
import 'package:bfc/compiler.dart';
import 'package:bfc/interpreter.dart';
import 'package:bfc/lexer.dart';
import 'package:path/path.dart' as p;

void main(List<String> arguments) {
  final parser = ArgParser(allowTrailingOptions: false);

  parser.addOption(
    'mode',
    abbr: 'm',
    help: 'Mode of operation',
    allowed: [
      'interpet',
      'compile',
    ],
    allowedHelp: {
      'interpret': 'Interpret at runtime.',
      'compile': 'Compile and link executable.',
    },
    defaultsTo: 'interpret',
  );

  parser.addSeparator('Compiler options:');
  parser.addOption(
    'output',
    abbr: 'o',
    help: 'Output filename',
  );
  parser.addFlag(
    'assemblyOnly',
    abbr: 'a',
    help: 'Assembly output only',
    negatable: false,
  );

  parser.addSeparator('Interpreter options:');
  parser.addOption(
    'cell-size',
    abbr: 's',
    help: 'Sets the BF cell-size',
    defaultsTo: '16',
  );

  final results = parser.parse(arguments);
  if (results.rest.isEmpty) {
    print('bfc: ${Platform.executable} [<options>] <filename.b>');
    print('\n${parser.usage}'.replaceAll('\n', '\n    '));
    exit(1);
  }

  final mode = results['mode'] as String;

  final program = BfLexer.fromFile(results.rest[0]);

  if (mode == 'interpret') {
    final interpreter = BfInterpreter(
      program: program,
      memory: BfInterpreter.allocateMemoryCells(results),
    );
    interpreter.run();
  } else if (mode == 'compile') {
    final compiler = BfCompiler(
      program: program,
    );
    final assemblyOnly = results['assemblyOnly'] as bool;
    final outputExecutable =
        results['output'] ?? '${p.basenameWithoutExtension(results.rest[0])}.exe';
    final outputAssembly = '${p.basenameWithoutExtension(outputExecutable)}.asm';
    compiler.run(outputExecutable, outputAssembly, assemblyOnly: assemblyOnly);
  }
}
