import 'package:chat_app/logic/blocs/chat/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatField extends StatelessWidget {
  final _txtChatController = TextEditingController();
  ChatField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.image_rounded),
          onPressed: () {
            BlocProvider.of<ChatBloc>(context).add(
              OpenGallery(),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.camera_alt_rounded),
          onPressed: () {
            BlocProvider.of<ChatBloc>(context).add(
              OpenCamera(),
            );
          },
        ),
        Expanded(
            child: TextFormField(
          controller: _txtChatController,
          decoration: const InputDecoration(
            hintText: "Type a message",
            border: InputBorder.none,
          ),
          onChanged: (value) {},
        )),
        IconButton(
          icon: Icon(
            Icons.send,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            BlocProvider.of<ChatBloc>(context).add(SendMessage(
              message: _txtChatController.text,
            ));
            _txtChatController.text = '';
          },
        )
      ],
    );
  }
}



// Widget _listviewMessage() {
  // return BlocBuilder<ChatBloc, ChatState>(
  //   buildWhen: (previous, current) =>
  //       current is ChatReceiveMessageState ||
  //       current is GetRoomInfoLoaded ||
  //       current is ChatSendMessageSuccessState,
  //   builder: (context, state) {
  //     var _chatBloc = BlocProvider.of<ChatBloc>(context);
  //     if (state is ChatInitial) {
  //       _chatBloc.add(GetRoomInfo(room.id));
  //     }
  //     if (state is GetRoomInfoLoaded ||
  //         state is ChatReceiveMessageState ||
  //         state is ChatSendMessageSuccessState) {
  //       List<Message> listMessage = List.empty();
  //       if (state is GetRoomInfoLoaded) {
  //         for (var element in state.roomDetail.listMember) {
  //           members[element.id] = element;
  //         }
  //         listMessage = state.roomDetail.listMessage;
  //       } else if (state is ChatReceiveMessageState) {
  //         listMessage = state.listMessage;
  //       } else if (state is ChatSendMessageSuccessState) {
  //         listMessage = state.listMessage;
  //       }
  //       return Scrollbar(
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 10),
  //           child: ListView.builder(
  //             addAutomaticKeepAlives: true,
  //             reverse: true,
  //             itemCount: listMessage.length,
  //             itemBuilder: (context, index) {
  //               return Padding(
  //                 padding: const EdgeInsets.symmetric(vertical: 8.0),
  //                 child: ListViewItem(
  //                   message: listMessage[index],
  //                   index: index,
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       );
  //     } else {
  //       return Container();
  //     }
  //   },
  // );
  // return BlocListener<MessageBloc, MessageState>(
  //   listener: (context, state) {
  //     if (state is HistoryLoaded) {
  //       for (var item in state.listMessage) {
  //         print(item.msg);
  //       }
  //     }
  //   },
  //   child: Container(),
  // );
// }
