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
          padding: EdgeInsets.zero,
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
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        title: Text(
          message.user.name ?? message.user.username,
          style: const TextStyle(fontWeight: FontWeight.w400),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(10)),
              child: _messageText(message),
            ),
            const SizedBox(height: 10),
            if (imageUrl != null)
              Image.network(
                imageUrl,
                height: 400,
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
          size: 50,
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
        case Type.userAddRoomToTeam:
          messageText = 'Team owner added ${message.msg} to team';
          break;
        case Type.userDeleteRoomFromTeam:
          messageText = 'Team owner removed ${message.msg} from team';
          break;
        case Type.userLeftTeam:
          messageText = '${message.msg} left team';
          break;
        case Type.addedUserToRoom:
          messageText = '${message.msg} added to room';
          break;
        case Type.removedUserFromRoom:
          messageText = '${message.msg} removed from room';
          break;
        case Type.unknown:
          messageText = 'unknown ${message.msg}';
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
