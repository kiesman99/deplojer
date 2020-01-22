import 'dart:collection';

import 'package:yaml/yaml.dart';

/// A simple extension to print out the platform
extension S on String {
  String replicate(int times) {
    var tmp = '';
    for(var i = 0; i < times; i++){
      tmp += this;
    }
    return tmp;
  }

  void printBox({String prefix = ''}) {
    print('-'.replicate(prefix.length + length + 4));
    print('| $prefix$this |');
    print('-'.replicate(prefix.length + length + 4));
  }
}

/// This class will hold the platform configuration
/// and all fields available for configuration.
class PlatformConfig {

  PlatformConfig(this._map, this.platform_name){
    _setExcludedFiles();
    _setExcludedScripts();
    _setExecutionOfMasterFiles();
    _setExecutionOfMasterScripts();
    _setCustomPathFiles();

    // platform_name.printBox(prefix: 'PLATFORM: ');
    // print('Master Files: $includeMasterFiles');
    // print('Master Scripts: $includeMasterScripts');
    // print('---');
    // print('Excluded Files: $excluded_files');
    // print('Excluded Scripts: $excluded_scripts');
    // print('---');
    // print('---\n');
  }

  // returns a platformconfig, that is empty
  static PlatformConfig empty(String platform){
    return PlatformConfig(YamlMap(), platform);
  }


  final YamlMap _map;

  /// The name of the platform that is configured
  String platform_name;

  /// The name of the scripts that should be
  /// excluded by this platform
  List<String> excluded_scripts = <String>[];

  /// The nae of the files that should be excluded
  List<String> excluded_files = <String>[];

  /// If master files should
  /// be included in execution
  /// 
  /// default: true
  bool includeMasterFiles = true;

  /// If master scripts should
  /// be included in execution
  /// 
  /// default: true
  bool includeMasterScripts = true;

  /// Here are all files listed, which should have
  /// a custom path.
  HashMap<String, String> customPath = HashMap();

  /// This function will filter the configuration for
  /// master files that should not be deployed by the specific
  /// platform
  void _setExcludedFiles() {
    YamlMap excluded = _map['excluded'];
    if(excluded != null){
      if(excluded['files'] != null){
        excluded['files'].forEach((val) {
          if(val is! YamlMap) {
            excluded_scripts.add(val);
          } 
          // TODO(jvietz): Scrape for excluded folders
        });
      }
    }
  }

  void _setCustomPathFiles() {
    YamlList custom_path = _map['custom_path'];
    if(custom_path != null) {
      custom_path.forEach((m) {

        (m as YamlMap).forEach((key, value) {
          customPath.putIfAbsent(key, () => value);
        });
      });
    }

    print(customPath);
  }

  /// This function will filter the configutaion for
  /// scripts located in the master directory
  /// that should not be deployed on the specific 
  /// platform
  void _setExcludedScripts() {
    YamlMap excluded = _map['excluded'];
    if(excluded != null){
      if(excluded['scripts'] != null){
        excluded['scripts'].forEach((val) {
          if(val is! YamlMap) {
            excluded_scripts.add(val);
          } 
          // TODO(jvietz): Scrape for excluded folders
        });
      }
    }
  }

  void _setExecutionOfMasterFiles() {
    includeMasterFiles = _map['include_master_files'] ?? includeMasterFiles;
  }

  void _setExecutionOfMasterScripts() {
    includeMasterScripts = _map['include_master_scripts'] ?? includeMasterScripts;
  }
}