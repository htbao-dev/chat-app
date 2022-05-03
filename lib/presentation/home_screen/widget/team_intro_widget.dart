import 'package:chat_app/constants/routes.dart';
import 'package:chat_app/data/models/team.dart';
import 'package:chat_app/logic/blocs/room/room_bloc.dart';
import 'package:chat_app/logic/blocs/team/team_bloc.dart';
import 'package:chat_app/presentation/home_screen/widget/list_room_widget.dart';
import 'package:chat_app/presentation/new_room_screen/screen/new_room_screen.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:chat_app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamIntroWidget extends StatelessWidget {
  const TeamIntroWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamBloc, TeamState>(
      buildWhen: (previous, current) => current is TeamDisplayed,
      builder: (context, state) {
        if (state is TeamDisplayed) {
          if (state.team != null) {
            return _Intro(
              team: state.team!,
            );
          } else {
            return Container();
          }
        }
        return Container();
      },
    );
  }
}

class _Intro extends StatelessWidget {
  final Team team;
  const _Intro({
    Key? key,
    required this.team,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: kScreenPadding,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  team.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (team.isOwner)
                  PopupMenuButton(
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        child: Text("New room"),
                        value: 1,
                      ),
                      const PopupMenuItem(
                        child: Text("Member"),
                        value: 2,
                      )
                    ],
                    onSelected: (value) {
                      if (value == 1) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              return AlertDialog(
                                contentPadding: const EdgeInsets.all(20),
                                content: NewRoomScreen(
                                  roomBloc: BlocProvider.of<RoomBloc>(context),
                                  team: team,
                                ),
                              );
                            });
                      }
                    },
                  ),
              ],
            ),
          ),
          if (team.isOwner)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.inviteTeam,
                        arguments: {
                          'teamBloc': BlocProvider.of<TeamBloc>(context),
                          'teamRoomId': team.roomId,
                        });
                  },
                  child: Text(StaticData.languageDisplay.kInvite)),
            ),
          Expanded(
              child: ListRoom(
            key: UniqueKey(), team: team,
            // teamBloc: context.read<TeamBloc>(),
          ))
        ],
      ),
    );
  }
}
