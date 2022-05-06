import 'package:chat_app/data/models/team.dart';
import 'package:chat_app/logic/blocs/team/team_bloc.dart';
import 'package:chat_app/presentation/invite_team_screen/invite_screen.dart';
import 'package:chat_app/presentation/screens/main_screen.dart';
import 'package:chat_app/presentation/screens/login_screen.dart';
import 'package:chat_app/presentation/screens/profile_screen.dart';
import 'package:chat_app/presentation/screens/register_screen.dart';
import 'package:chat_app/presentation/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String login = '/login';
  static const String welcome = '/';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String chat = '/chat';
  static const String register = '/register';
  static const String inviteTeam = '/invite-team';
}

class HomeRoutes {
  static const String home = '/home/';
  static const String profile = '/home/profile';
}

Route? generateAppRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.login:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case AppRoutes.welcome:
      return MaterialPageRoute(
        builder: (context) => const WelcomeScreen(),
      );
    case AppRoutes.register:
      return MaterialPageRoute(
        builder: (context) => RegisterScreen(),
      );
    case AppRoutes.home:
      return MaterialPageRoute(
        builder: (context) => MainScreen(),
      );
    case HomeRoutes.home:
      return MaterialPageRoute(
        builder: (context) => MainScreen(),
      );
    case HomeRoutes.profile:
      return MaterialPageRoute(builder: (context) => const ProfileScreen());
    case AppRoutes.inviteTeam:
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (context) => InviteScreen(
          teamBloc: args['teamBloc'] as TeamBloc,
          team: args['team'] as Team,
        ),
      );
    default:
      return null;
  }
}
