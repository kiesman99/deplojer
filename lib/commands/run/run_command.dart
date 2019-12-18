import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:cli/extensions/FileSystemEntityExtension.dart';

class RunCommand extends Command {

  final env = Platform.environment;

  @override
  String get description => 'Start deploying all your dotfiles and optionally scripts.';

  @override
  String get name => 'run';

  RunCommand(){
    argParser
      ..addFlag(
        'scripts',
        abbr: 's',
        negatable: false,
        defaultsTo: false,
        help: 'Enable script execution for the run.'
      )
      ..addFlag(
        'dotfiles',
        negatable: true,
        defaultsTo: true,
        help: 'Disable linking of dotfiles.'
      )
      ..addOption(
        'homePath',
        abbr: 'p',
        defaultsTo: env['HOME'],
        help: 'Define a custom directory to which the dotfiles will be linked.'
      );
  }

  @override
  void run() {
    if(argResults.rest.isEmpty) {
      printUsage();
      exit(0);
    }
    else if(argResults.rest.length > 1) {
      stderr.writeln('Error: Please provide only one platform to run the script on.');
      exit(1);
    }
    else {
      if(_isPlatformAvailable(argResults.rest.last)){
        _checkSelectedPlatform();
        _linkDotfiles();
        _execScripts();
      }
      else {
        stderr.writeln('Error: The platform ${argResults.rest.last} is not available.');
        exit(2);
      }
    }
  }

  /// This function will check if the selected platform is available
  void _checkSelectedPlatform() {

  }

  void _linkDotfiles() {
    if(argResults['dotfiles']) {
      stdout.writeln('Dotfiles will be linked...');
    }
    var homeDir = Directory(argResults['homePath']);
    var platform = argResults['platform'];
  }

  void _execScripts() {
    if(argResults['scripts']) {
      stdout.writeln('Scripts will be executed...');
    }
  }

  /// This function will return all available platforms
  ///
  /// If there is no 'platforms' folder the function will return an
  /// errorMessage and will exit the program
  List<String> get _availablePlatforms {
    var platformDir = Directory('platforms');
    if(!platformDir.existsSync()){
      stderr.writeln('Error: No platforms available');
      exit(2);
    }
    return platformDir.listSync().map((FileSystemEntity entity) => entity.name).toList();
  }

  /// This function will return true if the [platform]
  /// is available.
  bool _isPlatformAvailable(String platform){
    return _availablePlatforms.contains(platform);
  }

}