import 'package:chat_app/data/models/team.dart';
import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/logic/blocs/team/team_bloc.dart';
import 'package:chat_app/utils/theme.dart';
import 'package:flutter/material.dart';

class InviteScreen extends StatefulWidget {
  final TeamBloc teamBloc;
  final Team team;
  const InviteScreen({Key? key, required this.teamBloc, required this.team})
      : super(key: key);

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  // final List<User> listInvite = [];

  @override
  void initState() {
    super.initState();

    widget.teamBloc.searchInvite(selector: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite'),
        actions: [
          StreamBuilder<List<User>>(
              stream: widget.teamBloc.selectStream,
              builder: (context, snapshot) {
                final data = snapshot.data ?? [];
                if (data.isEmpty) {
                  return Container();
                }
                return IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    widget.teamBloc.inviteUser(team: widget.team);
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
                    stream: widget.teamBloc.selectStream,
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
              TextField(
                onChanged: (value) {
                  widget.teamBloc.searchInvite(selector: value);
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
                  stream: widget.teamBloc.searchStream,
                  builder: (context, snapshot) {
                    final data = snapshot.data ?? [];
                    return Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) => ListTile(
                          title: Text(data[index].name ?? data[index].username),
                          subtitle: Text(data[index].username,
                              style: const TextStyle(color: Colors.white70)),
                          onTap: () {
                            widget.teamBloc.selectUserInvite(data[index]);
                          },
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
        widget.teamBloc.removeUserInvite(user);
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
    widget.teamBloc.clearSearchUser();
    super.dispose();
  }
}
