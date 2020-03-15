import 'package:args/command_runner.dart';
import 'package:cli/commands/add/add_service.dart';

class AddCommand extends Command<String> {

  @override
  String get description => 'Add a new platform.';

  @override
  String get name => 'add';

  @override
  String get invocation => 'deplojer add <platform_names>';

  final AddService _addService = AddService();

  @override
  String run() {
    if(argResults.rest.isEmpty){
      return usage;
    }

    try{
      argResults.rest.forEach((platform) => _addService.createNewPlatform(platform));
      return 'Platforms ${argResults.rest} has been created.';
    } catch(e){
      return 'Platforms could not be created.';
    }
  }

}