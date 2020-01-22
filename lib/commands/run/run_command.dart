import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:cli/extensions/FileSystemEntityExtension.dart';
import 'package:cli/model/config/platform_config.dart';
import 'package:cli/service/config_service.dart';

class RunCommand extends Command {
  final env = Platform.environment;
  String _platform = '';

  String _homeDir;

  @override
  String get description =>
      'Start deploying all your files and optionally scripts.';

  @override
  String get name => 'run';

  RunCommand() {
    argParser
      ..addFlag('scripts',
          abbr: 's',
          negatable: false,
          defaultsTo: false,
          help: 'Enable script execution for the run.')
      ..addFlag('files',
          negatable: true,
          defaultsTo: true,
          help: 'Disable linking of files.')
      ..addOption('homePath',
          abbr: 'p',
          defaultsTo: env['HOME'],
          help:
              'Define a custom (absolute) directory to which the files will be linked.');
  }

  @override
  void run() {
    _platform = argResults.rest.last;
    if (argResults.rest.isEmpty) {
      printUsage();
      exit(0);
    } else if (argResults.rest.length > 1) {
      stderr.writeln(
          'Error: Please provide only one platform to run the script on.');
      exit(1);
    } else {
      if (_isPlatformAvailable(argResults.rest.last)) {

        // set variables given by args
        _homeDir = argResults['homePath'];

        _checkSelectedPlatform();
        _linkFiles();
        _execScripts();
      } else {
        stderr.writeln(
            'Error: The platform ${argResults.rest.last} is not available.');
        exit(2);
      }
    }
  }

  /// This function will check if the selected platform is available
  void _checkSelectedPlatform() {}

  void _linkFiles() {
    var outDir = Directory('platforms/$_platform/out');
    outDir.createSync();
    // clear out folder
    stdout.writeln('Clear "out" folder of $_platform');
    outDir.deleteSync(recursive: true);
    outDir.createSync();

    if (argResults['files']) {
      stdout.writeln('Files will be linked...');
    }
    var homeDir = Directory(argResults['homePath']);
    var configFile = File('platforms/config.yaml');
    // create file if not existent
    configFile.createSync();

    var configService = ConfigService();

    // link master platform files
    _setup_master_files(configService.configuration(_platform), outDir);

    // link platform files
    _setup_platform_files(configService.configuration(_platform), outDir);

    _link_files();
  }

  /// This function will link all files, that are in the platforms
  /// out directory.
  /// The files will be settet up beforehand by the functions
  /// [_setup_master_files] and [_setup_platform_files]
  void _link_files() {
    // If a json file with information about previously linked
    // files is available, iterate through each file and remove
    // the link at the fiven destination
    var oldLinksFile = File('.tmp/oldLinks.json');
    if(oldLinksFile.existsSync()) {
      // old file exists, so we need to delete old links to clean up eventually removed files
      var oldLinksJsonMap = jsonDecode(oldLinksFile.readAsStringSync());
      oldLinksJsonMap.forEach((link) => _removeOldLink(link));
    }
    // Save files that will be linked from the outfolder
    // into a json file to be able to clean the previous created 
    // links
    // TODO(vietz): Implement saving of files that should be linked

    // Link each file that is located in the platforms out-dir
    // everything should now be available from the json file that was
    // previsouly created/updated
    // TODO(jvietz): Implement actual linking of the files 
  }

  /// This function will merge the gap_filler into the given files
  /// stored in the "platforms/master/files" folder and saves the resulting
  /// files in the [outDir]
  void _setup_master_files(PlatformConfig config, Directory outDir) {
    // go through each file located in the master dir
    // create dir if not available
    var masterFilesDir = Directory('platforms/master/files')..createSync(recursive: true);
    var gap_filler_dir = Directory('platforms/$_platform/gap_filler');
    masterFilesDir.listSync().forEach((element) {
      // check if file is in excluded list
      // if not it should be included
      if(!config.excluded_files.contains(element.toString())) {
        
        // search for the files gap_filler folder
        // There are gap fillers for the requested element
        if(Directory('${gap_filler_dir.absolute.path}/${element.name}').existsSync()){
          // TODO(jvietz): Fill file with gap_fillers
        }
        // There are no gap_fillers for the requested element
        // Copy ready file into output dir
        else {
          if(element.myIsFile) (element as File).copySync('${outDir.absolute.path}/${element.name}');
        }
      }
    });
  }

  /// This function will make a copy of each platform file
  /// into the [outDir]
  void _setup_platform_files(PlatformConfig configuration, Directory outDir) {
    var files_platform =
        Directory('platforms/$_platform/files').listSync();
    stdout.writeln('Link files from ${_platform}...');
    files_platform.forEach((FileSystemEntity e) {
      if (FileSystemEntity.isFileSync(e.absolute.path)) {
        if(e.myIsFile) (e as File).copySync('${outDir.absolute.path}/${e.name}');
      }
    });
  }

  void _execScripts() {
    if (argResults['scripts']) {
      stdout.writeln('Scripts will be executed...');
      // TODO(jvietz): Implement execution of scripts in the scripts folder
    }
  }

  /// This function will return all available platforms
  ///
  /// If there is no 'platforms' folder the function will return an
  /// errorMessage and will exit the program
  List<String> get _availablePlatforms {
    var platformDir = Directory('platforms');
    if (!platformDir.existsSync()) {
      stderr.writeln('Error: No platforms available');
      exit(2);
    }
    return platformDir
        .listSync()
        .map((FileSystemEntity entity) => entity.name)
        .toList();
  }

  /// This function will return true if the [platform]
  /// is available.
  bool _isPlatformAvailable(String platform) {
    return _availablePlatforms.contains(platform);
  }

  /// This function will remove the given link
  void _removeOldLink(link) {
    // if no path is given in [link]
    // set [_homeDir] as Path
    var fileDir = link['path'] ?? _homeDir;
    var fileName = link['name'];

    var oldLink = File('$fileDir/.$fileName');
    if(oldLink.existsSync()) oldLink.deleteSync();
  }
}
