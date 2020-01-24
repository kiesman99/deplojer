import 'dart:io';
import 'package:cli/extensions/FileSystemEntityExtension.dart';
import 'package:args/command_runner.dart';
import 'package:cli/extensions/string_extension.dart';

class ListCommand extends Command<String> {
  @override
  String get description => 'List all available platforms.';

  @override
  String get name => 'list';

  @override
  String run() {
    // stdout.write(_printPlatforms());
    return _printPlatforms();
  }

  String _printPlatforms() {
    var platformDir = Directory('platforms');

    if (!platformDir.existsSync()) {
      return 'Error: No platforms are available.';
    }

    'Available Platforms'.printBox();
    var platforms = '';

    platformDir.listSync(recursive: false, followLinks: false).toList()
      .where((e) => e.isDir)
      .map((e) => e.name)
      .forEach((e) => platforms += '$e\n');

    return platforms;
  }
}
