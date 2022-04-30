import 'package:chat_app/data/models/room.dart';
import 'package:chat_app/logic/blocs/chat/chat_bloc.dart';
import 'package:chat_app/logic/blocs/room/room_bloc.dart';
import 'package:chat_app/presentation/chat_screen/screen/member_screen.dart';
import 'package:chat_app/presentation/chat_screen/widget/chat_field_widget.dart';
import 'package:chat_app/presentation/chat_screen/widget/list_view_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  final Room room;
  final RoomBloc roomBloc;
  const ChatScreen({Key? key, required this.room, required this.roomBloc})
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
              ListTile(
                title: const Text(
                  'Delete room',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: const Icon(Icons.delete),
                textColor: Colors.red,
                iconColor: Colors.red,
                onTap: () {},
              ),
              const ListTile(
                title: Text(
                  'leave room',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: Icon(Icons.exit_to_app),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return AddMemberScreen(
                      roomBloc: roomBloc,
                      room: room,
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
              const TextField(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemBuilder: (_, index) => ListTile(
                    title: Text(
                      'member $index',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
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
      actions: const [
        // IconButton(
        //   icon: const Icon(Icons.call),
        //   onPressed: () {
        //     // ignore: avoid_print
        //     print("call");
        //   },
        // ),
        // IconButton(
        //   icon: const Icon(Icons.videocam),
        //   onPressed: () {
        //     // ignore: avoid_print
        //     print("video");
        //   },
        // ),
        // IconButton(
        //   icon: const Icon(Icons.more_vert),
        //   onPressed: () {
        //     // ignore: avoid_print
        //     print("more");
        //   },
        // ),
      ],
    );
  }

  Widget _body() {
    return Column(
      children: [Expanded(child: ListViewMessage()), ChatField()],
    );
  }
}

// class ListViewItem extends StatefulWidget {
//   // final Message message;
//   // final int index;
//   const ListViewItem({
//     Key? key,
//     // required this.message,
//     // required this.index
//   }) : super(key: key);

//   @override
//   _ListItemState createState() => _ListItemState();
// }

// class _ListItemState extends State<ListViewItem>
//     with AutomaticKeepAliveClientMixin {
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Column(
//       crossAxisAlignment: widget.message.isYourMessage
//           ? CrossAxisAlignment.end
//           : CrossAxisAlignment.start,
//       children: [
//         // Text(members[message.senderId]!.name),
//         Container(
//           decoration: BoxDecoration(
//             color: widget.message.isYourMessage ? Colors.blue : Colors.grey,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               widget.message.message!,
//               style: const TextStyle(color: Colors.white, fontSize: 16),
//             ),
//           ),
//         ),
//         _listImage(widget.message, widget.message.roomId!),
//         Text(widget.message.formattedDate),
//       ],
//     );
//   }

//   Widget _listImage(Message message, String roomId) {
//     if (message.images.isEmpty) {
//       return Container();
//     } else {
//       return Directionality(
//         textDirection:
//             message.isYourMessage ? TextDirection.rtl : TextDirection.ltr,
//         child: GridView.builder(
//             physics: const NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//               maxCrossAxisExtent: 90,
//               childAspectRatio: 1,
//             ),
//             itemBuilder: (context, index) =>
//                 _displayImage(roomId, message.images[index]),
//             itemCount: message.images.length),
//       );
//     }
//   }
