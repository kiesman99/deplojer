import 'package:args/command_runner.dart';
import 'package:cli/commands/add/add_command.dart';
import 'package:cli/commands/run/run_command.dart';
import 'dart:io';
import 'package:cli/extensions/FileSystemEntityExtension.dart';
import 'package:cli/mainArgs.dart' show parser;

const _tool_name = 'deplojer';

void main(List<String> args) {

  var runner = CommandRunner(_tool_name, 'Easy deployment of all your dotfiles')
      ..addCommand(AddCommand())
      ..addCommand(RunCommand())
      ..run(args);

  if(args.isEmpty) runner.printUsage();
}

void blubb(List<String> args) async {
  var results = parser.parse(args);

  print(parser.usage);

  // collecting args
  //final bool help = results['help'];
  final String platform = results['platform'];
  final String new_platform = results['new_platform'];
  final bool dotfiles = results['dotfiles'];
  final bool scripts = results['scripts'];


  var supportedPlatforms = await _getPlatforms();
  
  // check if platform is supported
  if(!supportedPlatforms.contains(platform)){
    stderr.writeln('Error: Platform $platform is not supported.');
    exit(2);
  }


  print('This is your choosen platform: $platform');

  if(!dotfiles){
    _deploy_dotfiles(platform);
  }

  if(scripts){
    _exec_scripts(platform);
  }
}

String get execString {
  if (Platform.isMacOS) {
    return './$_tool_name';
  } else if (Platform.isLinux) {
    return './$_tool_name';
  } else if (Platform.isWindows) {
    return '$_tool_name.exe';
  } else {
    throw Exception('The platform which executes this script could not be determined');
  }
}

Future<List<String>> _getPlatforms() async {
  var platforms = <String>[];
  var platformDir = Directory('platforms');

  await platformDir.exists().then((isThere) {
    if(!isThere){
     // create if not existent
      print(
        '''
There are no platforms yet. Please add new platforms by invoking:
$execString -p [platform name]

----
Example for creating the platform "mac":
$execString -p mac
        '''
      );
      exit(0);
    }
  });

  var ent = await platformDir.list(recursive: false, followLinks: false).toList();
  ent.forEach((e) => platforms.add(e.name));

  return platforms;
}

void _deploy_dotfiles(String platform) {
  var dir = Directory('platforms/$platform/dotfiles');
  var list = dir.listSync().toList();
  if(list.isEmpty) {
    print('There are no dotfiles for platform: $platform');
  } else {
    // dotfiles were provided
    list.forEach((FileSystemEntity file) {
      if(file.myIsFile){
        Link('${homePath}/.${file.name}').createSync(file.absolute.path, recursive: false);
      }
    });
  }
}

// TODO(kiesman99): implement executing of custom scripts
void _exec_scripts(String platform) {
  var dir = Directory('platforms/$platform/scripts');
  var list = dir.listSync().toList();
  if(list.isEmpty) {
    print('There are no scripts for platform: $platform');
  } else {
    // scripts were provided
  }
}

String get homePath {
  var envVars = Platform.environment;
  if (Platform.isMacOS) {
    return envVars['HOME'];
  } else if (Platform.isLinux) {
    return envVars['HOME'];
  } else if (Platform.isWindows) {
    return envVars['UserProfile'];
  } else {
    throw Exception('The platform which executes this script could not be determined');
  }
}