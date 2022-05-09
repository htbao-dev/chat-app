import 'package:chat_app/data/repositories/auth_repository.dart';
import 'package:chat_app/logic/blocs/app/app_bloc.dart';
import 'package:chat_app/logic/blocs/auth/auth_bloc.dart';
import 'package:chat_app/constants/routes.dart';
import 'package:chat_app/logic/blocs/internet_bloc.dart';
import 'package:chat_app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => InternetBloc(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (context) => AppBloc(
              network: RepositoryProvider.of<InternetBloc>(context),
            )..add(InitApp()),
          ),
          BlocProvider(
            create: (context) => AuthBloc(
              authRepo: RepositoryProvider.of<AuthRepository>(context),
              appBloc: BlocProvider.of<AppBloc>(context),
              network: RepositoryProvider.of<InternetBloc>(context),
            ),
          ),
        ],
        child: MaterialApp(
          darkTheme: kDarkTheme,
          themeMode: ThemeMode.dark,
          onGenerateRoute: generateAppRoute,
        ),
      ),
    );
  }
}
