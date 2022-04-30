import 'package:bloc_test/bloc_test.dart';
import 'package:chat_app/constants/values.dart';
import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/data/repositories/auth_repository.dart';
import 'package:chat_app/logic/blocs/register/register_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RegisterBloc registerBloc;
  setUp(() {
    registerBloc = RegisterBloc(
      authRepo: AuthRepository(),
    );
  });
  tearDown(() {
    registerBloc.close();
  });

  group('test register', () {
    blocTest<RegisterBloc, RegisterState>(
      'test username exists',
      build: () => registerBloc,
      wait: const Duration(seconds: 5),
      act: (bloc) => bloc.add(RegisterSubmited(
          username: 'testregister01',
          name: 'Huynh Tan Bao',
          email: 'test@gmail.com',
          password: '123456778')),
      expect: () => [
        RegisterLoading(),
        RegisterError(
          status: RegisterStatus.usernameExists,
        )
      ],
    );
    blocTest<RegisterBloc, RegisterState>(
      'test email exists ',
      build: () => registerBloc,
      wait: const Duration(seconds: 10),
      act: (bloc) => bloc.add(RegisterSubmited(
          username: 'testregasdasafdfsdister02',
          name: 'Huynh Tan Bao',
          email: 'test@gmail.com',
          password: '123456778')),
      expect: () => [
        RegisterLoading(),
        RegisterError(
          status: RegisterStatus.emailExists,
        )
      ],
    );
    blocTest<RegisterBloc, RegisterState>(
      'test register ok ',
      build: () => registerBloc,
      wait: const Duration(seconds: 10),
      act: (bloc) => bloc.add(RegisterSubmited(
          username: 'testregister09',
          name: 'Huynh Tan Bao',
          email: 'test09@gmail.com',
          password: '123456778')),
      expect: () => [RegisterLoading(), RegisterSuccess()],
    );

    test('test emailsFromJson', () {
      // ignore: unused_local_variable
      var emails = [
        {
          'address': 'asdas',
          'verified': true,
        }
      ];
      expect(emailsFromMap(null), null);
    });
  });
}
