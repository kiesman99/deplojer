import 'dart:io';

import 'package:args/command_runner.dart';

class ListCommand extends Command {

  @override
  String get description => 'List all available platforms.';

  @override
  String get name => 'list';

  @override
  void run() {
    _listPlatforms();
  }

  List<String> _listPlatforms() {
  var platformDir = Directory('platforms');

  if(!platformDir.existsSync()) {
    stdout.writeln('Error: No platforms are available.');
    exit(0);
  }

  var platforms = platformDir.listSync(recursive: false, followLinks: false).toList();

  return platforms.map((e) => e.name).toList();
}

}