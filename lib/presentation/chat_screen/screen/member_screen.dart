import 'package:chat_app/data/models/room.dart';
import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/logic/blocs/room/room_bloc.dart';
import 'package:chat_app/utils/theme.dart';
import 'package:flutter/material.dart';

class AddMemberScreen extends StatefulWidget {
  final RoomBloc roomBloc;
  final String teamId;
  final Room room;
  const AddMemberScreen({
    Key? key,
    required this.roomBloc,
    required this.room,
    // required this.teamBloc,
    required this.teamId,
  }) : super(key: key);

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  // final List<User> listInvite = [];

  @override
  void initState() {
    super.initState();
    widget.roomBloc.listMemberInTeam(widget.teamId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name),
        actions: [
          StreamBuilder<List<User>>(
              stream: widget.roomBloc.selectStream,
              builder: (context, snapshot) {
                final data = snapshot.data ?? [];
                if (data.isEmpty) {
                  return Container();
                }
                return IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    widget.roomBloc.inviteUser(room: widget.room);
                    Navigator.pop(context);
                  },
                );
              }),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: kScreenPadding,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor.withAlpha(200),
                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                ),
                child: StreamBuilder<List<User>>(
                    stream: widget.roomBloc.selectStream,
                    builder: (context, snapshot) {
                      final data = snapshot.data ?? [];
                      return SingleChildScrollView(
                        child: Wrap(
                          runSpacing: 10,
                          spacing: 10,
                          children: [
                            for (final user in data) _inviteItem(user),
                          ],
                        ),
                      );
                    }),
              ),
              const SizedBox(height: 20),
              StreamBuilder<List<User>>(
                  stream: widget.roomBloc.teamMemberStream,
                  builder: (context, snapshot) {
                    final data = snapshot.data ?? [];
                    return ListView.builder(
                      itemBuilder: (context, index) => ListTile(
                        title: Text(data[index].name ?? data[index].username),
                        subtitle: Text(data[index].username,
                            style: const TextStyle(color: Colors.white70)),
                        onTap: () {
                          widget.roomBloc.selectUserInvite(data[index]);
                        },
                      ),
                      itemCount: data.length,
                      shrinkWrap: true,
                    );
                  }),
              // ListTeamMember(teamBloc: widget.teamBloc, teamId: widget.teamId)
            ],
          ),
        ),
      ),
    );
  }

  Widget _inviteItem(User user) {
    return GestureDetector(
      onTap: () {
        widget.roomBloc.removeUserInvite(user);
      },
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(user.name ?? user.username),
            const Padding(
              padding: EdgeInsets.only(left: 5),
              child: Icon(
                Icons.close,
                size: 13,
              ),
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          // color: Theme.of(context).backgroundColor.withAlpha(255),
          color: Colors.grey.shade800.withAlpha(200),
          borderRadius: const BorderRadius.all(Radius.circular(18)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.roomBloc.clearSearchUser();
    super.dispose();
  }
}
