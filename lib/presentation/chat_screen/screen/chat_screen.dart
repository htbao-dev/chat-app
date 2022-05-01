import 'package:chat_app/data/models/room.dart';
import 'package:chat_app/data/models/team.dart';
import 'package:chat_app/logic/blocs/chat/chat_bloc.dart';
import 'package:chat_app/logic/blocs/room/room_bloc.dart';
import 'package:chat_app/presentation/chat_screen/screen/member_screen.dart';
import 'package:chat_app/presentation/chat_screen/widget/chat_field_widget.dart';
import 'package:chat_app/presentation/chat_screen/widget/list_room_member.dart';
import 'package:chat_app/presentation/chat_screen/widget/list_view_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  final Room room;
  final Team team;
  final RoomBloc roomBloc;
  // final TeamBloc teamBloc;
  const ChatScreen(
      {Key? key, required this.room, required this.roomBloc, required this.team
      // required this.teamBloc,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(
        room: room,
      )..add(
          LoadHistory(roomId: room.id),
        ),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: _appBar(),
        body: _body(),
        endDrawer: Drawer(
          child: Column(
            children: [
              Padding(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
              if (team.isOwner)
                ListTile(
                  title: const Text(
                    'Delete room',
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: const Icon(Icons.delete),
                  textColor: Colors.red,
                  iconColor: Colors.red,
                  onTap: () async {
                    await roomBloc.deleteRoom(room);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    roomBloc.add(
                        LoadRooms(teamId: team.id, teamRoomId: team.roomId));
                  },
                ),
              if (!(team.isOwner))
                ListTile(
                  title: const Text(
                    'leave room',
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: const Icon(Icons.exit_to_app),
                  textColor: Colors.red,
                  iconColor: Colors.red,
                  onTap: () async {
                    await roomBloc.leaveRoom(room: room);
                    roomBloc.add(
                        LoadRooms(teamId: team.id, teamRoomId: team.roomId));
                    Navigator.of(context).pop();
                  },
                ),
              if (team.isOwner)
                ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return AddMemberScreen(
                        roomBloc: roomBloc,
                        room: room,
                        teamId: team.id,
                      );
                    }));
                  },
                  title: const Text(
                    'add member',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              const Divider(
                thickness: 2,
              ),
              // const TextField(),
              Expanded(
                child: ListRoomMember(room: room, roomBloc: roomBloc),
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(room.name),
      leading: const BackButton(),
    );
  }

  Widget _body() {
    return Column(
      children: [Expanded(child: ListViewMessage()), ChatField()],
    );
  }
}
