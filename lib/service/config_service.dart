
import 'dart:collection';
import 'dart:io';

import 'package:cli/model/config/platform_config.dart';
import 'package:yaml/yaml.dart';

/// This service will read the given config.yaml
/// file and expose it's values.
class ConfigService {

  ConfigService(){
    var confDir = Directory('platforms/');
    var confFile = File('${confDir.absolute.path}/config.yaml');
    YamlMap yaml = loadYaml(confFile.readAsStringSync());
    // check if yaml is not empty
    if(yaml != null && yaml.isNotEmpty){
      yaml['platforms'].forEach((key, value) {
        _configurations.putIfAbsent(key.toString(), () => PlatformConfig(value, key.toString()));
      });
    }
  }
   
  /// This field holds all available platformconfigurations
  final HashMap<String, PlatformConfig> _configurations = HashMap();

  PlatformConfig configuration(String platform) {
    if(_configurations[platform] == null){
      // return empty configuration, because there is no config yet
      return PlatformConfig.empty(platform);
    }

    return _configurations[platform];
  }

}
