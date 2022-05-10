import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/data/models/team.dart';
import 'package:chat_app/logic/blocs/team/team_bloc.dart';
import 'package:chat_app/presentation/new_team_screen/screen/new_team_screen.dart';
import 'package:chat_app/presentation/screens/profile_screen.dart';
import 'package:chat_app/utils/strings.dart';
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
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProfileScreen.routeName);
          },
          child: const _MenuItem(
            child: Icon(Icons.person),
          ),
        ),
        const _ListTeam(),
        Divider(
          color: Theme.of(context).primaryColor,
          thickness: 1,
          indent: 8,
          endIndent: 8,
        ),
        GestureDetector(
          onTap: () {
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
          },
          child: const _MenuItem(
            child: Icon(Icons.add),
          ),
        ),
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
          return Column(
            children: [
              Divider(
                color: Theme.of(context).primaryColor,
                thickness: 1,
                indent: 8,
                endIndent: 8,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: listTeam.length,
                itemBuilder: (context, index) {
                  return _teamItem(context, listTeam[index]);
                },
              ),
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget _teamItem(BuildContext context, Team team) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<TeamBloc>(context).add(DisplayTeam(
          team: team,
        ));
      },
      child: Stack(children: [
        _MenuItem(imageUrl: getAvatarUrl(param: team.roomId)),
      ]),
    );
  }
}

class _MenuItem extends StatefulWidget {
  const _MenuItem({Key? key, this.imageUrl, this.child}) : super(key: key);
  final String? imageUrl;
  final Widget? child;
  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  @override
  Widget build(BuildContext context) {
    if (widget.imageUrl != null) {
      return CachedNetworkImage(
          imageUrl: widget.imageUrl!,
          imageBuilder: (context, imageProvider) => Container(
              margin: const EdgeInsets.all(8.0),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ))),
          placeholder: (context, url) => _itemChild(Icon(
                Icons.message,
                size: 25,
                color: Theme.of(context).primaryColor,
              )),
          errorWidget: (context, url, error) => _itemChild(Icon(
                Icons.message,
                size: 25,
                color: Theme.of(context).primaryColor,
              )));
    } else {
      return _itemChild(widget.child!);
    }
  }

  Widget _itemChild(Widget child) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor, shape: BoxShape.circle),
      child: child,
    );
  }
}
