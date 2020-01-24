import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:cli/commands/add/add_command.dart';
import 'package:test/test.dart';

void main() {

  Directory platformDir;
  CommandRunner runner;

  setUp(() {
    runner = CommandRunner('deplojer', 'A simple test')
      ..addCommand(AddCommand());
    platformDir = Directory('platforms');
  });

  tearDown(() {
    if(platformDir.existsSync()) platformDir.deleteSync(recursive: true);
  });

  group('add command', () {

    setUp(() {
      runner.run(['add', 'linux']);
      expect(platformDir.existsSync(), true); 
    });
    
    test('check platform files', () {
      var linux_main_dir = Directory('${platformDir.absolute.path}/linux');
      var linux_files_dir = Directory('${linux_main_dir.absolute.path}/files');
      var linux_scripts_dir = Directory('${linux_main_dir.absolute.path}/scripts');
      var linux_gap_filler_dir = Directory('${linux_main_dir.absolute.path}/gap_filler');

      expect(linux_main_dir.existsSync(), true);
      expect(linux_files_dir.existsSync(), true);
      expect(linux_scripts_dir.existsSync(), true);
      expect(linux_gap_filler_dir.existsSync(), true);
    });

    test('check master files', () {
      var master_main_dir = Directory('${platformDir.absolute.path}/master');
      var master_files_dir = Directory('${master_main_dir.absolute.path}/files');
      var master_scripts_dir = Directory('${master_main_dir.absolute.path}/scripts');

      expect(master_main_dir.existsSync(), true);
      expect(master_files_dir.existsSync(), true);
      expect(master_scripts_dir.existsSync(), true);
    });

    test('check setup of config file', (){
      var configFile = File('${platformDir.absolute.path}/config.yaml');
      expect(configFile.existsSync(), true);
    });

    test('add another platform', (){
      // another platform
      runner.run(['add', 'windows']);

      var linux_main_dir = Directory('${platformDir.absolute.path}/linux');
      var linux_files_dir = Directory('${linux_main_dir.absolute.path}/files');
      var linux_scripts_dir = Directory('${linux_main_dir.absolute.path}/scripts');
      var linux_gap_filler_dir = Directory('${linux_main_dir.absolute.path}/gap_filler');

      expect(linux_main_dir.existsSync(), true);
      expect(linux_files_dir.existsSync(), true);
      expect(linux_scripts_dir.existsSync(), true);
      expect(linux_gap_filler_dir.existsSync(), true);

      var windows_main_dir = Directory('${platformDir.absolute.path}/windows');
      var windows_files_dir = Directory('${linux_main_dir.absolute.path}/files');
      var windows_scripts_dir = Directory('${linux_main_dir.absolute.path}/scripts');
      var windows_gap_filler_dir = Directory('${linux_main_dir.absolute.path}/gap_filler');

      expect(windows_main_dir.existsSync(), true);
      expect(windows_files_dir.existsSync(), true);
      expect(windows_scripts_dir.existsSync(), true);
      expect(windows_gap_filler_dir.existsSync(), true);
    });

    test('setup platform twice', (){
      var linux_main_dir = Directory('${platformDir.absolute.path}/linux');
      var linux_files_dir = Directory('${linux_main_dir.absolute.path}/files');
      var linux_scripts_dir = Directory('${linux_main_dir.absolute.path}/scripts');
      var linux_gap_filler_dir = Directory('${linux_main_dir.absolute.path}/gap_filler');

      var linux_sample_file = File('${linux_files_dir.absolute.path}/testfile')
        ..createSync();
      
      expect(linux_sample_file.existsSync(), true);

      runner.run(['add', 'linux']);

      expect(linux_main_dir.existsSync(), true);
      expect(linux_files_dir.existsSync(), true);
      expect(linux_scripts_dir.existsSync(), true);
      expect(linux_gap_filler_dir.existsSync(), true);
      expect(linux_sample_file.existsSync(), true);

    });

  });
}
