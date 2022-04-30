import 'package:chat_app/data/repositories/room_repository.dart';
import 'package:chat_app/logic/blocs/room/room_bloc.dart';
import 'package:chat_app/logic/blocs/team/team_bloc.dart';
import 'package:chat_app/presentation/home_screen/widget/menu_team_widget.dart';
import 'package:chat_app/presentation/home_screen/widget/team_intro_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TeamBloc>(context).add(LoadTeam());
    return BlocProvider(
      create: (context) => RoomBloc(
          roomRepository: RepositoryProvider.of<RoomRepository>(context),
          teamBloc: BlocProvider.of<TeamBloc>(context)),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Flexible(child: MenuTeam(), flex: 2),
            Flexible(
              child: TeamIntroWidget(),
              fit: FlexFit.tight,
              flex: 10,
            )
          ],
        ),
      ),
    );
  }
}
