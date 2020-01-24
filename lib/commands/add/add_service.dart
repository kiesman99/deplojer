import 'dart:io';

/// This function is used by [AddCommand]
/// to execute all the logic needed to add
/// a platform
class AddService {

  /// This script will create all folders for the new platform
  /// [name].
  void createNewPlatform(String name) {
    var platformDir = Directory('platform/$name');

    if(!platformDir.existsSync()){
      Directory('platforms/$name/files').createSync(recursive: true);
      Directory('platforms/$name/scripts').createSync(recursive: true);
      Directory('platforms/$name/gap_filler').createSync(recursive: true);
      _createConfFile();
      _createMasterFolder();
    }
  }

  void _createConfFile() {
    const example_url = 'https://github.com/kiesman99/deplojer';
    var dir = Directory('platforms');
    var file = File('${dir.absolute.path}/config.yaml');
    if(!file.existsSync()) {
      file.createSync(recursive: true);
      file.writeAsStringSync('# $example_url');
    }
  }

  void _createMasterFolder() {
    Directory('platforms/master/files').createSync(recursive: true);
    Directory('platforms/master/scripts').createSync(recursive: true);
  }

}