import 'package:chat_app/utils/validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('username test', () {
    test('username < 6', () {
      expect(validateUsername('1'), false);
    });
    test('username is null', () {
      expect(validateUsername(null), false);
    });
    test('username special character', () {
      expect(validateUsername('&^^&*%&*Y('), false);
    });
    test('username start by number', () {
      expect(validateUsername('1asdasdasdasd'), false);
    });
    test('username ok', () {
      expect(validateUsername('Test123123'), true);
    });
  });
  group('password test', () {
    test('password < 6', () {
      expect(validatePassword('1'), false);
    });
    test('password is null', () {
      expect(validatePassword(null), false);
    });
    test('password special character', () {
      expect(validatePassword('Test1&^%^23123'), false);
    });
    test('password ok', () {
      expect(validatePassword('Test_123123'), true);
    });
  });

  group('email test', () {
    test('email is null', () {
      expect(validateEmail(null), false);
    });
    test('email is empty', () {
      expect(validateEmail(''), false);
    });
    test('email is invalid', () {
      expect(validateEmail('test@gmail'), false);
    });
    test('email is invalid [.] ', () {
      expect(validateEmail('test@gmail.'), false);
    });
    test('email is invalid [@]', () {
      expect(validateEmail('testgmail.com'), false);
    });
    test('email is start with @', () {
      expect(validateEmail('@gmail.com'), false);
    });
    test('email ok', () {
      expect(validateEmail('test@gmail.com'), true);
    });
  });

  group('name test', () {
    test('name is null', () {
      expect(validateName(null), false);
    });
    test('name is empty', () {
      expect(validateName(''), false);
    });
    test('name contain number', () {
      expect(validateName('test123'), false);
    });
    test('name is contain special character ', () {
      expect(validateName('test@gmail'), false);
    });
    test('name is start with space', () {
      expect(validateName(' testgmail'), false);
    });
    test('name is end with space', () {
      expect(validateName('gmail '), false);
    });
    test('name multi space', () {
      expect(validateName('gmail  asd'), false);
    });
    test('name ok', () {
      expect(validateName('Huynh Tan Bao'), true);
    });
  });
}
