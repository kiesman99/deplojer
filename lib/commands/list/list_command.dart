import 'dart:io';
import 'package:cli/extensions/FileSystemEntityExtension.dart';
import 'package:args/command_runner.dart';

class ListCommand extends Command {

  @override
  String get description => 'List all available platforms.';

  @override
  String get name => 'list';

  @override
  void run() {
    _printPlatforms();
  }

  void _printPlatforms() {
  var platformDir = Directory('platforms');

  if(!platformDir.existsSync()) {
    stdout.writeln('Error: No platforms are available.');
    exit(0);
  }

  var platforms = platformDir.listSync(recursive: false, followLinks: false).toList();

  platforms.map((e) => e.name).toList().forEach((p) => stdout.writeln(p));
}

}