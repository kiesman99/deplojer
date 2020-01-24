import 'package:args/command_runner.dart';
import 'package:cli/commands/list/list_command.dart';
import 'package:test/test.dart';

void main() {

  CommandRunner<String> runner;

  setUp(() {
    runner = CommandRunner('deplojer', 'A simple test')
      ..addCommand(ListCommand());

    // setup some platforms
    runner.run(['add', 'linux', 'windows', 'mac']);
  });



}