import 'dart:io';

import 'package:cli/model/config/platform_config.dart';
import 'package:cli/service/config_service.dart';
import 'package:test/test.dart';

void main() {
  var configString;
  ConfigService configService;

  setUp(() {
    configString = """
platforms:
  win: 
    include_master_files: false
    include_master_scripts: false
    excluded:
      files:
        - 'blubber'
        - 'compton'
        - 'alacritty'
  linux: 
    custom_path:
      - 'alacritty': '/home/kiesman/.config/alacritty/'
      - 'init.vim': '~/.config/nvim'
  mac:
    include_master_scripts: true
    excluded:
      files:
        - 'vimrc'
        - 'neovim'
        - 'linux_conf'
        - 'linuc_compton'
      scripts:
        - 'setup_linux.sh'
        - 'linux_aliases.sh'
    custom_path:
      - 'hot_corners.conf': '~/.hot_corners'
""";
    var configFile = File('platforms/config.yaml')
      ..createSync(recursive: true)
      ..writeAsStringSync(configString);
    configService = ConfigService(configFile: configFile);
  });

  tearDown(() {
    // Delete old dirs
    Directory('platforms/').deleteSync(recursive: true);
  });

  test('test basic reading of configuration', () {
    var winConfig = configService.configuration('win');
    expect(winConfig, isNot(PlatformConfig.empty('win')));
    expect(configService.configuration('blubber'), isNot(null));
    expect(configService.configuration('blubber'),
        PlatformConfig.empty('blubber'));
  });

  group('test include_master_files', () {
    test('existing platform with disabled master files', () {
      expect(configService.configuration('win').includeMasterFiles, false);
    });

    test('non existing platform', () {
      expect(configService.configuration('blubber').includeMasterFiles, true);
    });

    test('existing platform without explicit configuration', (){
      expect(configService.configuration('mac').includeMasterFiles, true);
    });
  });

  group('test include_master_scripts', () {
    test('existing platform with disabled master scripts', () {
      expect(configService.configuration('win').includeMasterScripts, false);
    });

    test('non existing platform', () {
      expect(configService.configuration('blubber').includeMasterScripts, true);
    });

    test('existing platform without explicit configuration', (){
      expect(configService.configuration('mac').includeMasterScripts, true);
    });

    test('existing platform with enabled scripts', () {
      expect(configService.configuration('mac').includeMasterScripts, true);
    });
  });

  group('test platform_name', () {

    test('existing platform', (){
      expect(configService.configuration('win').platform_name, 'win');
    });

    test('non existing platform', (){
      expect(configService.configuration('blubber').platform_name, 'blubber');
    });

  });

  group('test custom_path', (){

    test('existing platform with custom path', () {
      var customPaths = configService.configuration('linux').customPath;
      expect(customPaths['alacritty'], '/home/kiesman/.config/alacritty/');
      expect(customPaths['init.vim'], '~/.config/nvim');
      expect(customPaths.containsKey('blubber'), false);
    });

    test('existing platform without custom path', () {
      var customPaths = configService.configuration('win').customPath;
      expect(customPaths.isEmpty, true);
    });

    test('non existing platform', () {
      expect(configService.configuration('blubber').customPath.isEmpty, true);
    });

  });

  group('test excluded_scripts', (){
    test('existing platform with excluded scripts', (){
      var ex_scripts = configService.configuration('mac').excluded_scripts;

      expect(ex_scripts, <String>[
        'setup_linux.sh',
        'linux_aliases.sh'
      ]);
    });

    test('existing platform without excluded scripts', () {
      var ex_scripts = configService.configuration('win').excluded_scripts;
      expect(ex_scripts, <String>[]);
    });

    test('non existing platform', () {
      var ex_scripts = configService.configuration('blubber').excluded_scripts;
      expect(ex_scripts, <String>[]);
    });
  });

  group('test excluded_files', (){
    test('existing platform with excluded files', (){
      var ex_scripts = configService.configuration('mac').excluded_files;

      expect(ex_scripts, <String>[
        'vimrc',
        'neovim',
        'linux_conf',
        'linuc_compton'
      ]);
    });

    test('existing platform without excluded files', () {
      var ex_scripts = configService.configuration('linux').excluded_files;
      expect(ex_scripts, <String>[]);
    });

    test('non existing platform', () {
      var ex_scripts = configService.configuration('blubber').excluded_files;
      expect(ex_scripts, <String>[]);
    });
  });
}
