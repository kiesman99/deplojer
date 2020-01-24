import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:cli/commands/add/add_service.dart';

class AddCommand extends Command {

  @override
  String get description => 'Add a new platform.';

  @override
  String get name => 'add';

  @override
  String get invocation => 'deplojer add <platform_name>';

  final AddService _addService = AddService();

  @override
  void run() {
    if(argResults.rest.isEmpty){
      printUsage();
    }
    else if(argResults.rest.isNotEmpty){
      try{
        argResults.rest.forEach((platform) => _addService.createNewPlatform(platform));
      } catch(e){
        exit(1);
      }
    }
  }

}