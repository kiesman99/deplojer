
import 'dart:collection';
import 'dart:io';

import 'package:cli/model/config/platform_config.dart';
import 'package:yaml/yaml.dart';

/// This service will read the given config.yaml
/// file and expose it's values.
class ConfigService {

  ConfigService({File configFile}){
    var confDir = Directory('platforms/');
    var confFile = configFile ?? File('${confDir.absolute.path}/config.yaml');
    YamlMap yaml = loadYaml(confFile.readAsStringSync());
    // check if yaml is not empty
    if(yaml != null && yaml.isNotEmpty){
      yaml['platforms']?.forEach((key, value) {

        var customPaths = HashMap<String, String>();

        if(value['custom_paths'] != null) {
          value['custom_paths'].forEach((m) {
            (m as YamlMap).forEach((key, value) {
              customPaths.putIfAbsent(key, () => value);
            });
          });
        }

        _configurations.putIfAbsent(key.toString(), () => PlatformConfig(
          platformName: key.toString(),
          includeMasterFiles: value['include_master_files'] ?? true,
          excludedFiles: (value['excluded'] as YamlList)?.toList() ?? const [],
          customPaths: customPaths
        ));
      });
    }
  }
   
  /// This field holds all available platformconfigurations
  final HashMap<String, PlatformConfig> _configurations = HashMap();

  /// This function will return the configuration for the given
  /// [platform].
  /// If the platform has **no** configuration in the config.yaml
  /// file it'll return [PlatformConfig.empty(platform)]
  PlatformConfig configuration(String platform) {
    if(_configurations[platform] == null){
      // return empty configuration, because there is no config yet
      return PlatformConfig();
    }

    return _configurations[platform];
  }

}
