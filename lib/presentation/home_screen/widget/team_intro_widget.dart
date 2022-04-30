import 'package:chat_app/constants/routes.dart';
import 'package:chat_app/logic/blocs/room/room_bloc.dart';
import 'package:chat_app/logic/blocs/team/team_bloc.dart';
import 'package:chat_app/presentation/home_screen/widget/list_room_widget.dart';
import 'package:chat_app/presentation/new_room_screen/screen/new_room_screen.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:chat_app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamIntroWidget extends StatelessWidget {
  const TeamIntroWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamBloc, TeamState>(
      buildWhen: (previous, current) => current is TeamDisplayed,
      builder: (context, state) {
        if (state is TeamDisplayed) {
          return Container(
            padding: kScreenPadding,
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        state.team.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (state.team.isOwner)
                        // IconButton(
                        //     onPressed: () {
                        //       showDialog(
                        //           context: context,
                        //           barrierDismissible: false,
                        //           builder: (_) {
                        //             return AlertDialog(
                        //               contentPadding: const EdgeInsets.all(20),
                        //               content: NewRoomScreen(
                        //                 roomBloc:
                        //                     BlocProvider.of<RoomBloc>(context),
                        //                 team: state.team,
                        //               ),
                        //             );
                        //           });
                        //       // Navigator.pushNamed(context, AppRoutes.newRoom,
                        //       //     arguments: BlocProvider.of<RoomBloc>(context));
                        //     },
                        //     icon: const Icon(Icons.add)),

                        PopupMenuButton(
                          itemBuilder: (_) => [
                            const PopupMenuItem(
                              child: Text("New room"),
                              value: 1,
                            ),
                            const PopupMenuItem(
                              child: Text("Member"),
                              value: 2,
                            )
                          ],
                          onSelected: (value) {
                            if (value == 1) {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) {
                                    return AlertDialog(
                                      contentPadding: const EdgeInsets.all(20),
                                      content: NewRoomScreen(
                                        roomBloc:
                                            BlocProvider.of<RoomBloc>(context),
                                        team: state.team,
                                      ),
                                    );
                                  });
                            }
                          },
                        ),
                    ],
                  ),
                ),
                if (state.team.isOwner)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.inviteTeam,
                              arguments: {
                                'teamBloc': BlocProvider.of<TeamBloc>(context),
                                'teamRoomId': state.team.roomId,
                              });
                        },
                        child: Text(StaticData.languageDisplay.kInvite)),
                  ),
                Expanded(
                    child: ListRoom(
                  teamId: state.team.id,
                  teamRoomId: state.team.roomId,
                  key: UniqueKey(),
                ))
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
