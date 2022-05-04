import 'package:chat_app/logic/blocs/chat/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatField extends StatelessWidget {
  final _txtChatController = TextEditingController();
  ChatField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
      ),
      child: Row(
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
      ),
    );
  }
}
