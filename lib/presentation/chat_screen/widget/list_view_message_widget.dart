import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/data/data_providers/api/rocket_server.dart';
import 'package:chat_app/data/models/message.dart';
import 'package:chat_app/data/models/room.dart';
import 'package:chat_app/logic/blocs/chat/chat_bloc.dart';
import 'package:chat_app/presentation/chat_screen/widget/avt_chat_widgetd.dart';
import 'package:chat_app/utils/formatter.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListViewMessage extends StatefulWidget {
  final Room room;
  const ListViewMessage({Key? key, required this.room}) : super(key: key);

  @override
  State<ListViewMessage> createState() => _ListViewMessageState();
}

class _ListViewMessageState extends State<ListViewMessage> {
  final ScrollController _controller = ScrollController();
  bool _canLoad = true;
  final List<Message> listMessage = [];

  @override
  void initState() {
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.position.pixels) {
        if (_canLoad) {
          final time = listMessage.last.timestamp;
          BlocProvider.of<ChatBloc>(context)
              .add(LoadHistory(roomId: widget.room.id, from: time));
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) =>
          current is HistoryLoaded || current is MessageReceive,
      builder: (context, state) {
        if (state is HistoryLoaded || state is MessageReceive) {
          if (state is HistoryLoaded) {
            if (state.listMessage.isEmpty) {
              _canLoad = false;
            } else {
              _canLoad = true;
              listMessage.addAll(state.listMessage);
            }
          } else if (state is MessageReceive) {
            listMessage.insert(0, state.message);
          }
          return ListView.builder(
            addAutomaticKeepAlives: true,
            controller: _controller,
            reverse: true,
            padding: EdgeInsets.zero,
            itemCount: listMessage.length,
            itemBuilder: (context, index) {
              return _listTile(listMessage[index]);
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
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
        title: Row(
          children: [
            Text(
              message.user.name ?? message.user.username,
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
            const SizedBox(width: 5),
            Text(getTimeMesage(message.timestamp),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                )),
          ],
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
              CachedNetworkImage(
                imageUrl: imageUrl,
                errorWidget: (context, url, error) => Container(
                  child: const Icon(Icons.error),
                  color: Colors.grey,
                ),
                placeholder: (context, url) => Container(
                  child: const Icon(Icons.image),
                  color: Colors.grey,
                ),
                fit: BoxFit.cover,
                height: 300,
                width: 200,
                httpHeaders: {
                  'X-Auth-Token': StaticData.auth!.token,
                  'X-User-Id': StaticData.auth!.userId,
                },
              ),
          ],
        ),
        leading: AvatarChat(message.user.avatarUrl!),
        textColor: Colors.white,
      ),
    );
  }

  Widget _messageText(Message message) {
    String? messageText = message.msg;
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
        case Type.userLeaveRoom:
          messageText = '${message.msg} leave room';
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
    if (messageText != null) {
      return Text(
        messageText,
        style: const TextStyle(wordSpacing: 2),
      );
    }
    return const SizedBox();
  }
}
