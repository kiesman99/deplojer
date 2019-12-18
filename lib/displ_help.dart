import 'dart:io';

/// This function will display the help information for this package
void displ_help(){

  // print the header
  _help_header();

  // print flag information
  _print_flag_information();

  exit(0);
}

void _help_header(){
  print('This Programm will deploy the provided files to your system and executes all scripts if needed.\n');
}

/// This function will hold all flags and arguments and its explanations
void _print_flag_information() {
  // TODO(kiesman99): Add printing of help
}