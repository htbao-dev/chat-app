import 'package:chat_app/constants/routes.dart';
import 'package:chat_app/data/repositories/room_repository.dart';
import 'package:chat_app/data/repositories/team_repository.dart';
import 'package:chat_app/data/repositories/user_repository.dart';
import 'package:chat_app/logic/blocs/auth/auth_bloc.dart';
import 'package:chat_app/logic/blocs/team/team_bloc.dart';
import 'package:chat_app/logic/cubits/cubit/nav_cubit.dart';
import 'package:chat_app/presentation/home_screen/screen/home_screen.dart';
import 'package:chat_app/presentation/screens/profile_screen.dart';
import 'package:chat_app/presentation/widgets/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);
  final Map<String, Widget> _screen = {};
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => UserRepository(),
        ),
        RepositoryProvider(
          create: (context) => TeamRepository(),
        ),
        RepositoryProvider(
          create: (context) => RoomRepository(),
        ),
        RepositoryProvider(create: (context) => UserRepository())
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLogout) {
            Navigator.of(context, rootNavigator: true)
                .popAndPushNamed(AppRoutes.login);
          }
        },
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => NavCubit(),
            ),
            BlocProvider(
              create: (context) => TeamBloc(
                teamRepository: RepositoryProvider.of<TeamRepository>(context),
                userRepository: RepositoryProvider.of<UserRepository>(context),
              )..add(LoadTeam()),
            ),
          ],
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: BlocBuilder<NavCubit, String>(builder: ((context, route) {
              if (_screen[route] == null) {
                if (route == HomeRoutes.home) {
                  _screen[route] = const HomeScreen();
                } else if (route == HomeRoutes.profile) {
                  _screen[route] = const ProfileScreen();
                }
              }
              return _screen[route]!;
            })),
            bottomNavigationBar: const BottomNavBar(),
          ),
        ),
      ),
    );
  }
}
