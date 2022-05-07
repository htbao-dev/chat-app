import 'package:chat_app/constants/routes.dart';
import 'package:chat_app/data/repositories/room_repository.dart';
import 'package:chat_app/data/repositories/team_repository.dart';
import 'package:chat_app/data/repositories/user_repository.dart';
import 'package:chat_app/logic/blocs/auth/auth_bloc.dart';
import 'package:chat_app/logic/blocs/team/team_bloc.dart';
import 'package:chat_app/logic/cubits/cubit/nav_cubit.dart';
import 'package:chat_app/presentation/home_screen/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);
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
              create: (context) => TeamBloc(
                teamRepository: RepositoryProvider.of<TeamRepository>(context),
                userRepository: RepositoryProvider.of<UserRepository>(context),
                roomRepository: RepositoryProvider.of<RoomRepository>(context),
              )..add(LoadTeam()),
            ),
          ],
          child:
              const Scaffold(resizeToAvoidBottomInset: false, body: HomeScreen()
                  // bottomNavigationBar: const BottomNavBar(),
                  ),
        ),
      ),
    );
  }
}
