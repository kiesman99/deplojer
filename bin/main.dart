import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:cli/commands/add/add_command.dart';
import 'package:cli/commands/list/list_command.dart';
import 'package:cli/commands/run/run_command.dart';
import 'dart:io';

const _tool_name = 'deplojer';

void main(List<String> args) {

  var runner = CommandRunner(_tool_name, 'Easy deployment of all your dotfiles')
      ..addCommand(AddCommand())
      ..addCommand(RunCommand())
      ..addCommand(ListCommand());

  if(args.isEmpty) runner.printUsage();

  runner.run(args);
}
