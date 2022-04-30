import 'package:chat_app/data/models/room.dart';
import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/logic/blocs/room/room_bloc.dart';
import 'package:chat_app/logic/blocs/team/team_bloc.dart';
import 'package:chat_app/utils/theme.dart';
import 'package:flutter/material.dart';

class AddMemberScreen extends StatefulWidget {
  final RoomBloc roomBloc;
  final Room room;
  const AddMemberScreen({
    Key? key,
    required this.roomBloc,
    required this.room,
  }) : super(key: key);

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  // final List<User> listInvite = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.room.name),
        actions: const [
          // StreamBuilder<List<User>>(
          //     stream: widget.roomBloc.selectStream,
          //     builder: (context, snapshot) {
          //       final data = snapshot.data ?? [];
          //       if (data.isEmpty) {
          //         return Container();
          //       }
          //       return IconButton(
          //         icon: const Icon(Icons.check),
          //         onPressed: () {
          //           widget.roomBloc.inviteUser(roomId: widget.roomId);
          //           Navigator.pop(context);
          //         },
          //       );
          //     }),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: kScreenPadding,
        child: SafeArea(
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  widget.roomBloc.searchMember(value, widget.room);
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  fillColor: Theme.of(context).backgroundColor.withAlpha(200),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                    borderSide: BorderSide(
                      color: Theme.of(context).backgroundColor.withAlpha(200),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(
                      color: Theme.of(context).backgroundColor.withAlpha(200),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              StreamBuilder<List<User>>(
                  stream: widget.roomBloc.searchStream,
                  builder: (context, snapshot) {
                    final data = snapshot.data ?? [];
                    return Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) => ListTile(
                          title: Text(data[index].name ?? data[index].username),
                          subtitle: Text(data[index].username,
                              style: const TextStyle(color: Colors.white70)),
                          onTap: () {},
                        ),
                        itemCount: data.length,
                        shrinkWrap: true,
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget _inviteItem(User user) {
    return GestureDetector(
      onTap: () {
        // widget.roomBloc.removeUserInvite(user);
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
    // widget.roomBloc.clearSearch();
    super.dispose();
  }
}
