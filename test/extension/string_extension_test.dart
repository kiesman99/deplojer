import 'package:test/test.dart';
import 'package:cli/extensions/string_extension.dart';

void main() {
  group('replicate', () {
    test('test single char', () {
      expect('h'.replicate(10), 'hhhhhhhhhh');
    });

    test('test word', () {
      expect('hello'.replicate(17),
          'hellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohello');
    });

    test('test multiline', () {
      expect(
          '''
Hallo ich bin ein
cooler
cooler
 test
'''
              .replicate(2),
          '''
Hallo ich bin ein
cooler
cooler
 test
Hallo ich bin ein
cooler
cooler
 test
''');
    });
  });

  group('toBox', () {
    group('without prefix', () {
      test('simple string', () {
        expect('hello'.toBox(), '''
---------
| hello |
---------
''');
      });

      test('complex String', () {
        expect('I am a rather complex string'.toBox(), '''
--------------------------------
| I am a rather complex string |
--------------------------------
''');
      });
    });

    group('with prefix', () {
      test('simple string', () {
        expect('hello'.toBox(prefix: 'Title: '), '''
----------------
| Title: hello |
----------------
''');
      });

      test('complex string', () {
        expect('I am a rather complex String'.toBox(prefix: 'Title: '), '''
---------------------------------------
| Title: I am a rather complex String |
---------------------------------------
''');
      });
    });
  });
}
