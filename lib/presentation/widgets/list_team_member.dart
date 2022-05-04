import 'package:chat_app/data/models/team.dart';
import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/logic/blocs/team/team_bloc.dart';
import 'package:flutter/material.dart';

class ListTeamMember extends StatelessWidget {
  final Team team;
  final TeamBloc teamBloc;
  final Function(User)? onLongPressed;
  const ListTeamMember({
    Key? key,
    this.onLongPressed,
    required this.teamBloc,
    required this.team,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    teamBloc.loadTeamMember(team);
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<User>>(
            stream: teamBloc.teamMemberStream,
            builder: (context, snapshot) {
              final data = snapshot.data ?? [];
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) => ListTile(
                  title: Text(data[index].name ?? data[index].username),
                  subtitle: Text(data[index].username,
                      style: const TextStyle(color: Colors.white70)),
                  onLongPress: () {
                    if (onLongPressed != null) onLongPressed!(data[index]);
                  },
                ),
                itemCount: data.length,
                shrinkWrap: true,
              );
            }),
      ),
    );
  }
}
