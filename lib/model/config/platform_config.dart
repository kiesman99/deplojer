
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'platform_config.g.dart';

@CopyWith()
@immutable
class PlatformConfig extends Equatable {

  /// The name of the platform the configuration
  /// belongs to
  final String platformName;

  /// Wether the master files should be included or not
  final bool includeMasterFiles;

  /// The List of files that should be excluded 
  /// from the master folder
  final List<dynamic> excludedFiles;

  /// This is the list of files that will get a custom
  /// deployment folder
  final Map<String, String> customPaths;

  PlatformConfig({
    this.platformName, 
    this.includeMasterFiles = true,
    this.excludedFiles = const [],
    this.customPaths = const {}
    });

  @override
  List<Object> get props => null;

}