import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:yaml/yaml.dart';

/// This class will hold the platform configuration
/// and all fields available for configuration.
class PlatformConfig extends Equatable{

  PlatformConfig(this._map, this.platform_name){
    _setExcludedFiles();
    _setExcludedScripts();
    _setExecutionOfMasterFiles();
    _setExecutionOfMasterScripts();
    _setCustomPathFiles();

    // platform_name.printBox(prefix: 'PLATFORM: ');
  }

  // returns a platformconfig, that is empty
  static PlatformConfig empty(String platform){
    return PlatformConfig(YamlMap(), platform);
  }


  final YamlMap _map;

  /// The name of the platform that is configured
  final String platform_name;

  /// The name of the scripts that should be
  /// excluded by this platform
  final List<String> excluded_scripts = <String>[];

  /// The nae of the files that should be excluded
  final List<String> excluded_files = <String>[];

  /// If master files should
  /// be included in execution
  /// 
  /// default: true
  bool includeMasterFiles;

  /// If master scripts should
  /// be included in execution
  /// 
  /// default: true
  bool includeMasterScripts = true;

  /// Here are all files listed, which should have
  /// a custom path.
  final HashMap<String, String> customPath = HashMap();

  /// This function will filter the configuration for
  /// master files that should not be deployed by the specific
  /// platform
  void _setExcludedFiles() {
    YamlMap excluded = _map['excluded'];
    if(excluded != null){
      if(excluded['files'] != null){
        excluded['files'].forEach((val) {
          if(val is! YamlMap) {
            excluded_files.add(val);
          } 
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

    //print(customPath);
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

  @override
  List<Object> get props => [_map, platform_name, excluded_files, excluded_scripts, includeMasterFiles, includeMasterScripts, customPath];
}