import 'dart:developer';

import 'package:chat_app/constants/routes.dart';
import 'package:chat_app/data/models/team.dart';
import 'package:chat_app/logic/blocs/room/room_bloc.dart';
import 'package:chat_app/logic/blocs/team/team_bloc.dart';
import 'package:chat_app/presentation/home_screen/widget/list_room_widget.dart';
import 'package:chat_app/presentation/new_room_screen/screen/new_room_screen.dart';
import 'package:chat_app/presentation/widgets/list_team_member.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamIntroWidget extends StatelessWidget {
  // final Team team;
  // final TeamBloc teamBloc;
  const TeamIntroWidget({
    Key? key,
    // required this.team,
    // required this.teamBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamBloc, TeamState>(
      buildWhen: (previous, current) => current is TeamDisplayed,
      builder: (context, state) {
        if (state is TeamDisplayed) {
          if (state.team != null) {
            BlocProvider.of<TeamBloc>(context).listTeamMember = null;
            return Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AppBar(
                title: Text(state.team!.name),
              ),
              endDrawer: _Drawer(
                team: state.team!,
              ),
              body: _Intro(
                team: state.team!,
                teamBloc: BlocProvider.of<TeamBloc>(context),
              ),
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

class _Drawer extends StatelessWidget {
  final Team team;
  const _Drawer({Key? key, required this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
          if (team.isOwner)
            ListTile(
              title: const Text(
                'Delete team',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
              trailing: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (context1) => AlertDialog(
                    title: Text('Delete ${team.name} ?'),
                    content: const Text('Are you sure?'),
                    actions: [
                      TextButton(
                        child: const Text('No'),
                        onPressed: () => Navigator.of(context1).pop(),
                      ),
                      TextButton(
                        child: const Text('Yes'),
                        onPressed: () async {
                          showDialog(
                            context: context1,
                            builder: (context1) => const AlertDialog(
                              title: Text('Deleting...'),
                              content: Text('Please wait...'),
                              actions: [
                                CircularProgressIndicator(),
                              ],
                            ),
                          );

                          await BlocProvider.of<TeamBloc>(context)
                              .deleteTeam(team);
                          Navigator.of(context1).pop();
                          Navigator.of(context1).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          if (team.isOwner)
            ListTile(
              title: const Text(
                'New room',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
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
              },
            ),
          if (!team.isOwner)
            ListTile(
              title: const Text(
                'Leave team',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
              trailing: const Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ),
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (context1) => AlertDialog(
                    title: const Text('Leave team'),
                    content: const Text('Are you sure?'),
                    actions: [
                      TextButton(
                        child: const Text('No'),
                        onPressed: () => Navigator.of(context1).pop(),
                      ),
                      TextButton(
                        child: const Text('Yes'),
                        onPressed: () async {
                          await BlocProvider.of<TeamBloc>(context)
                              .leaveTeam(team);
                          Navigator.of(context1).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          const Divider(
            thickness: 2,
          ),
          Expanded(
              child: ListTeamMember(
            team: team,
            onLongPressed: team.isOwner
                ? (user) {
                    log(user.name!);
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return AlertDialog(
                            contentPadding: const EdgeInsets.all(20),
                            content: Text(
                              'Are you sure you want to remove ${user.name} from team?',
                              style: const TextStyle(fontSize: 16),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await BlocProvider.of<TeamBloc>(context)
                                      .removeMemberFromTeam(
                                    team: team,
                                    user: user,
                                  );
                                  Navigator.pop(context);
                                },
                                child: const Text('Remove'),
                              ),
                            ],
                          );
                        });
                  }
                : null,
            teamBloc: BlocProvider.of<TeamBloc>(context),
          ))
        ],
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  final Team team;
  final TeamBloc teamBloc;
  const _Intro({
    Key? key,
    required this.team,
    required this.teamBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (team.isOwner)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.inviteTeam,
                        arguments: {
                          'teamBloc': BlocProvider.of<TeamBloc>(context),
                          'team': team,
                        });
                  },
                  child: Text(StaticData.languageDisplay.kInvite)),
            ),
          ),
        Expanded(
            child: ListRoom(
          key: UniqueKey(), team: team,
          // teamBloc: context.read<TeamBloc>(),
        ))
      ],
    );
  }
}
