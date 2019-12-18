import 'dart:io';

import 'package:args/command_runner.dart';

class AddCommand extends Command {

  @override
  String get description => 'Add a new platform.';

  @override
  String get name => 'add';

  @override
  void run() {
    if(argResults.rest.isEmpty){
      printUsage();
      exit(0);
    }
    else if(argResults.rest.isNotEmpty){
      try{
        argResults.rest.forEach((platform) => _createNewPlatform(platform));
        exit(0);
      } catch(e){
        exit(1);
      }
    }
  }

  /// This script will create all folders for the new platform
  /// [name].
  void _createNewPlatform(String name) {
    var platformDir = Directory('platform/$name');

    if(!platformDir.existsSync()){
      Directory('platforms/$name/dotfiles').createSync(recursive: true);
      Directory('platforms/$name/scripts').createSync(recursive: true);
      print('Platform $name has been created');
    }
  }

}