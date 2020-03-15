import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:cli/commands/list/list_command.dart';
import 'package:test/test.dart';

void main() {

  CommandRunner<String> runner;
  Directory platformDir;

  setUp(() {
    runner = CommandRunner('deplojer', 'A simple test')
      ..addCommand(ListCommand());

    platformDir = Directory('platforms')
      ..createSync();

    // setup some platforms
    Directory('${platformDir.absolute.path}/linux').createSync();
    Directory('${platformDir.absolute.path}/windows').createSync();
    Directory('${platformDir.absolute.path}/mac').createSync();
    Directory('${platformDir.absolute.path}/PopOs!').createSync();
  });

  tearDown(() {
    if(platformDir.existsSync()) platformDir.deleteSync(recursive: true);
  });

  test('basictest', () async {

    var res = await runner.run(['list']);

    print(res);
    expect(res, equals(
'''
mac
linux
windows
PopOs!
'''));
  });


}