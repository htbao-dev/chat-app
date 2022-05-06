import 'package:chat_app/logic/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/home/profile';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (previous, current) => current is AuthLoading,
          builder: (context, state) {
            if (state is AuthLoading) {
              return const CircularProgressIndicator();
            }
            return ElevatedButton(
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(Logout());
              },
              child: const Text('Logout!'),
            );
          },
        ),
      ),
    );
  }
}
