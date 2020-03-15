import 'dart:io';

import 'package:cli/service/config_service.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {

  ConfigService configService;
  File configFile = FileMock();

  group('one platform', () {
    test('one argument', () {
      when(configFile.readAsStringSync()).thenReturn(
'''
platforms:
  linux:
    include_master_files: false
'''
      );

      configService = ConfigService(configFile: configFile);

      var config = configService.configuration('linux');
      expect(config, isNot(null));
      expect(config.includeMasterFiles, false);
    });

    test('multiple arguments', () {
      when(configFile.readAsStringSync()).thenReturn(
"""
platforms:
  linux:
    include_master_files: false
    excluded:
      - 'alacritty.yaml'
      - 'config.ini'
    custom_paths:
      - 'compton': '~/.config/compton/'
      - 'i3': '~/.config/i3'
"""
      );

      configService = ConfigService(configFile: configFile);
      var config = configService.configuration('linux');
      expect(config, isNot(null));
      expect(config.includeMasterFiles, false);
      expect(config.excludedFiles, const <String>['alacritty.yaml', 'config.ini']);
      expect(config.customPaths, const <String, String> {
        'compton': '~/.config/compton/',
        'i3': '~/.config/i3'
      });
    });
  });

  group('multiple platforms', () {

    test('one argument', () {
      when(configFile.readAsStringSync()).thenReturn(
'''
platforms:
  win:
    include_master_files: true
  mac:
    blubber: true
  linux:
    include_master_files: false
'''
      );

      configService = ConfigService(configFile: configFile);
      var winConfig = configService.configuration('win');
      var macConfig = configService.configuration('mac');
      var linuxConfig = configService.configuration('linux');

      expect(winConfig, isNot(null));
      expect(macConfig, isNot(null));
      expect(linuxConfig, isNot(null));

      expect(winConfig.includeMasterFiles, true);
      expect(macConfig.includeMasterFiles, true);
      expect(linuxConfig.includeMasterFiles, false);
    });

    test('multiple arguments', () {
            when(configFile.readAsStringSync()).thenReturn(
'''
platforms:
  win:
    include_master_files: true
    excluded:
      - 'i3.config'
  mac:
    blubber: true
    custom_paths:
      - 'alacritty.yaml': '~/'
      - 'brew.conf': '~/.config/brew'
  linux:
    include_master_files: false
    excluded:
      - 'powershell.ps1'
      - 'superfile.four'
    custom_paths:
      - 'linux_exclude': 'I am here'
      - 'twoooh': 'twoooh.folder'
'''
      );

      configService = ConfigService(configFile: configFile);
      var winConfig = configService.configuration('win');
      var macConfig = configService.configuration('mac');
      var linuxConfig = configService.configuration('linux');

      expect(winConfig, isNot(null));
      expect(macConfig, isNot(null));
      expect(linuxConfig, isNot(null));

      expect(winConfig.includeMasterFiles, true);
      expect(winConfig.excludedFiles, const ['i3.config']);

      expect(macConfig.includeMasterFiles, true);
      expect(macConfig.customPaths, const {
        'alacritty.yaml': '~/',
        'brew.conf': '~/.config/brew'
      });

      expect(linuxConfig.includeMasterFiles, false);
      expect(linuxConfig.excludedFiles, const ['powershell.ps1', 'superfile.four']);
      expect(linuxConfig.customPaths, const {
        'linux_exclude': 'I am here',
        'twoooh': 'twoooh.folder'
      });
    });

  });
}

class FileMock extends Mock implements File {}
