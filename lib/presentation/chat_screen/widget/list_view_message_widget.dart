import 'package:chat_app/data/data_providers/api/rocket_server.dart';
import 'package:chat_app/data/models/message.dart';
import 'package:chat_app/logic/blocs/chat/chat_bloc.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListViewMessage extends StatelessWidget {
  ListViewMessage({Key? key}) : super(key: key);
  final List<Message> listMessage = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) =>
          current is HistoryLoaded || current is MessageReceive,
      builder: (context, state) {
        if (state is HistoryLoaded) {
          listMessage.addAll(state.listMessage);
        } else if (state is MessageReceive) {
          listMessage.insert(0, state.message);
        }
        return ListView.builder(
          addAutomaticKeepAlives: true,
          reverse: true,
          itemCount: listMessage.length,
          itemBuilder: (context, index) {
            return _listTile(listMessage[index]);
          },
        );
      },
    );
  }

  Widget _listTile(Message message) {
    String? imageUrl;
    if (message.attachments != null &&
        message.attachments!.isNotEmpty &&
        message.attachments!.first.titleLink != null) {
      imageUrl =
          RocketServer.getServerAdd() + message.attachments!.first.titleLink!;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          message.user.name ?? message.user.username,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(color: Colors.grey),
              child: _messageText(message),
            ),
            if (imageUrl != null)
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                headers: {
                  'X-Auth-Token': StaticData.auth!.token,
                  'X-User-Id': StaticData.auth!.userId,
                },
              ),
          ],
        ),
        leading: const Icon(
          Icons.account_circle,
          size: 40,
        ),
        textColor: Colors.white,
      ),
    );
  }

  Widget _messageText(Message message) {
    String messageText = message.msg;
    if (message.type != null) {
      switch (message.type!) {
        case Type.addedUserToTeam:
          messageText = 'Team owner added ${message.msg}';
          break;
        case Type.removedUserFromTeam:
          messageText = 'Team owner removed ${message.msg}';
          break;
      }
      return Text(
        messageText,
        style:
            const TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
      );
    }
    return Text(
      messageText,
      style: const TextStyle(wordSpacing: 2),
    );
  }
}
