import 'package:chat_app/data/models/room.dart';
import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/logic/blocs/room/room_bloc.dart';
import 'package:flutter/material.dart';

class ListRoomMember extends StatelessWidget {
  final RoomBloc roomBloc;
  final Room room;
  final Function(User)? onLongPress;
  const ListRoomMember(
      {Key? key, required this.roomBloc, required this.room, this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    roomBloc.listMemberInRoom(room);
    return StreamBuilder<List<User>>(
        stream: roomBloc.searchStream,
        builder: (context, snapshot) {
          final data = snapshot.data ?? [];
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) => ListTile(
              title: Text(data[index].name ?? data[index].username),
              subtitle: Text(data[index].username,
                  style: const TextStyle(color: Colors.white70)),
              onLongPress: () {
                if (onLongPress != null) onLongPress!(data[index]);
              },
            ),
            itemCount: data.length,
            shrinkWrap: true,
          );
        });
  }
}
