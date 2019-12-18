import 'package:args/args.dart';

final ArgParser _parser = ArgParser()
..addCommand('run')
..addCommand('add');

final parser = _parser;