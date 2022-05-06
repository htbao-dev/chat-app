import 'package:chat_app/data/models/team.dart';
import 'package:chat_app/logic/blocs/team/team_bloc.dart';
import 'package:chat_app/presentation/new_team_screen/screen/new_team_screen.dart';
import 'package:chat_app/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuTeam extends StatelessWidget {
  const MenuTeam({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _MenuItem(
          child: Icon(
            Icons.person,
            size: 30,
            color: Theme.of(context).primaryColor,
          ),
          ontap: () {
            Navigator.of(context).pushNamed(ProfileScreen.routeName);
          },
        ),
        const _ListTeam(),
        Container(width: 40, height: 1, color: Theme.of(context).primaryColor),
        _MenuItem(
            child: const Icon(Icons.add),
            ontap: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.all(20),
                      content: NewTeamScreen(
                        teamBloc: BlocProvider.of<TeamBloc>(context),
                      ),
                    );
                  });
              // Navigator.pushNamed(context, AppRoutes.newRoom,
              //     arguments: BlocProvider.of<RoomBloc>(context));
            }),
      ],
    );
  }
}

class _ListTeam extends StatelessWidget {
  const _ListTeam({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamBloc, TeamState>(
      buildWhen: (previous, current) => current is TeamLoaded,
      builder: (context, state) {
        if (state is TeamLoaded) {
          final listTeam = state.teams;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: listTeam.length,
            itemBuilder: (context, index) {
              return _listTeamItem(context, listTeam[index]);
            },
          );
        }
        return Container();
      },
    );
  }

  Widget _listTeamItem(BuildContext context, Team team) {
    return _MenuItem(
      child: BlocBuilder<TeamBloc, TeamState>(
        buildWhen: (previous, current) =>
            current is TeamDisplayed ||
            (current is TeamHaveMessage && current.teamId == team.id),
        builder: (context, state) {
          final Color color;
          if (state is TeamDisplayed && state.team?.id == team.id) {
            color = Theme.of(context).primaryColor;
          } else if (state is TeamHaveMessage) {
            color = Colors.red;
          } else {
            color = Colors.grey;
          }
          return Icon(
            Icons.chat,
            color: color,
          );
        },
      ),
      ontap: () {
        BlocProvider.of<TeamBloc>(context).add(DisplayTeam(
          team: team,
        ));
      },
    );
  }
}

class _MenuItem extends StatefulWidget {
  const _MenuItem({Key? key, required this.child, this.ontap})
      : super(key: key);
  final Widget child;
  final Function()? ontap;
  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Theme.of(context).backgroundColor,
          ),
          child: widget.child,
        ),
      ),
      onTap: widget.ontap,
    );
  }
}
