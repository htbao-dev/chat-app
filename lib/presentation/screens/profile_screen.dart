import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/logic/blocs/auth/auth_bloc.dart';
import 'package:chat_app/presentation/screens/display_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/home/profile';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) => current is AuthLoading,
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        BlocProvider.of<AuthBloc>(context).getUserInfo();
        return StreamBuilder<User?>(
            stream: BlocProvider.of<AuthBloc>(context).userStream,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Profile'),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.exit_to_app),
                        onPressed: () async {
                          final bool confirm = await _confirm(context);
                          if (confirm) {
                            BlocProvider.of<AuthBloc>(context).add(Logout());
                          }
                        },
                      )
                    ],
                  ),
                  body: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final user = snapshot.data!;
              return DisplayProfileScreen(user: user);
            });
      },
    );
  }

  Future<bool> _confirm(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit?'),
            actions: <Widget>[
              TextButton(
                child: const Text('No'),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        ) ??
        false;
  }
}
