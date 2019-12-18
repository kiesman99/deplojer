import 'dart:io';

extension FileExtension on FileSystemEntity {

  /// Return the name of the entity
  String get name {
    var stat = statSync();
    if(stat.type == FileSystemEntityType.file){
      return uri.pathSegments.elementAt(uri.pathSegments.length - 1);
    } else if(stat.type == FileSystemEntityType.directory){
      return uri.pathSegments.elementAt(uri.pathSegments.length - 2);
    }
    else {
      return 'Could not be resolved';
    }
  }

  /// Evaluates if the entity is a directory
  bool get isDir {
    return statSync().type == FileSystemEntityType.directory;
  }

  /// Evaluates if the entity is a file
  bool get myIsFile {
    return statSync().type == FileSystemEntityType.file;
  }

}