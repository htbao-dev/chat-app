import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/logic/blocs/team/team_bloc.dart';
import 'package:flutter/material.dart';

// class ListTeamMember extends StatelessWidget {
//   final String teamId;
//   final TeamBloc teamBloc;
//   const ListTeamMember({Key? key, required this.teamBloc, required this.teamId})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     teamBloc.listMember(teamId);
//     return StreamBuilder<List<User>>(
//         stream: teamBloc.teamMemberStream,
//         builder: (context, snapshot) {
//           final data = snapshot.data ?? [];
//           return ListView.builder(
//             itemBuilder: (context, index) => ListTile(
//               title: Text(data[index].name ?? data[index].username),
//               subtitle: Text(data[index].username,
//                   style: const TextStyle(color: Colors.white70)),
//               onTap: () {},
//             ),
//             itemCount: data.length,
//             shrinkWrap: true,
//           );
//         });
//   }
// }
