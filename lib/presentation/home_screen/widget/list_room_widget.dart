import 'package:chat_app/data/models/room.dart';
import 'package:chat_app/data/models/team.dart';
import 'package:chat_app/logic/blocs/room/room_bloc.dart';
import 'package:chat_app/logic/blocs/team/team_bloc.dart';
import 'package:chat_app/presentation/chat_screen/screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListRoom extends StatefulWidget {
  final Team team;
  // final TeamBloc teamBloc;
  const ListRoom({
    Key? key,
    required this.team,
    // required this.teamBloc,
  }) : super(key: key);

  @override
  State<ListRoom> createState() => _ListRoomState();
}

class _ListRoomState extends State<ListRoom> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TeamBloc>(context).loadRooms(team: widget.team);
    return BlocListener<RoomBloc, RoomState>(
      listener: (context, state) {
        if (state is RoomSelected) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ChatScreen(
              room: state.room,
              roomBloc: BlocProvider.of<RoomBloc>(context),
              team: widget.team,
              // teamBloc: widget.teamBloc,
            ),
          ));
        }
      },
      child: StreamBuilder<ListRoomTeam>(
        stream: BlocProvider.of<TeamBloc>(context).listRoomStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final publicRooms = snapshot.data!.publicRooms;
            final privateRooms = snapshot.data!.privateRooms;
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                _generalRoom(context, snapshot.data!.generalRoom),
                _groupRoom('public rooms', rooms: publicRooms),
                _groupRoom('private rooms', rooms: privateRooms),
              ],
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _generalRoom(BuildContext context, Room generalRoom) {
    return ListTile(
      title: const Text('general'),
      onTap: () {
        BlocProvider.of<RoomBloc>(context).add(
          SelectRoom(generalRoom),
        );
      },
    );
  }

  Widget _groupRoom(String groupName, {List<Room>? rooms}) {
    List<Widget> children = [];
    if (rooms != null) {
      children = rooms.map((room) {
        return _ListRoomItem(
          room: room,
        );
      }).toList();
    }
    return ExpansionTile(
        title: Text(groupName),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        // expandedAlignment: Alignment.,
        initiallyExpanded: true,
        childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
        children: children);
  }
}

class _ListRoomItem extends StatelessWidget {
  final Room room;
  const _ListRoomItem({Key? key, required this.room}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<RoomBloc>(context).add(
          SelectRoom(room),
        );
      },
      child: BlocBuilder<RoomBloc, RoomState>(
        buildWhen: (previous, current) => current is RoomReceiveMessage,
        builder: (context, state) {
          final bool isMessage;
          if (state is RoomReceiveMessage && state.message.roomId == room.id) {
            isMessage = true;
          } else {
            isMessage = false;
          }
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Icon(
                  Icons.grid_3x3,
                  size: 20,
                ),
                SizedBox(
                  width: 200,
                  child: Text(
                    room.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isMessage ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
