import 'package:chat_app/data/data_providers/local_storage/message_localstoreage.dart';
import 'package:chat_app/data/data_providers/local_storage/sqlite_core.dart';
import 'package:chat_app/data/models/message.dart';
import 'package:chat_app/data/models/user.dart';
import 'package:sqflite/sqflite.dart';

class MessageSqlite implements MessageLocalStorage {
  final SqliteCore _localDb = SqliteCore();

  @override
  Future<void> clearMessages() {
    throw UnimplementedError();
  }

  @override
  Future<List<Message>> getMessages(String roomId, DateTime from) async {
    var db = await _localDb.database;

    var messageQuery = await db.rawQuery(
      'SELECT * FROM $tableMessage JOIN $tableUser on $tableMessage.${MessageFields.userId} = $tableUser.${UserFields.id} WHERE ${MessageFields.roomId} = ? AND ${MessageFields.timestamp} < ? ORDER BY ${MessageFields.timestamp} DESC',
      [roomId, from.toIso8601String()],
    );
    return messagesFromMap(messageQuery, _messageFromDbMap);
  }

  @override
  Future<void> saveMessages(List<Message> messages) async {
    var db = await _localDb.database;
    var batch = db.batch();
    for (var message in messages) {
      batch.insert(tableMessage, _messageToDbMap(message),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Map<String, dynamic> _messageToDbMap(Message message) {
    return {
      MessageFields.id: message.id,
      MessageFields.msg: message.msg,
      MessageFields.roomId: message.roomId,
      MessageFields.type: message.typeToString(),
      MessageFields.userId: message.user.id,
      MessageFields.timestamp: message.timestamp?.toIso8601String(),
      MessageFields.attachments:
          (message.attachments != null && message.attachments!.isNotEmpty)
              ? message.attachments!.first.imageUrl
              : null,
    };
  }

  Message _messageFromDbMap(Map<String, dynamic> map) {
    Type? type;
    if (map['t'] != null) {
      if (map['t'] == 'removed-user-from-team') {
        type = Type.removedUserFromTeam;
      } else if (map['t'] == 'added-user-to-team') {
        type = Type.addedUserToTeam;
      } else if (map['t'] == 'user-added-room-to-team') {
        type = Type.userAddRoomToTeam;
      } else if (map['t'] == 'user-deleted-room-from-team') {
        type = Type.userDeleteRoomFromTeam;
      } else if (map['t'] == 'ult') {
        type = Type.userLeftTeam;
      } else if (map['t'] == 'au') {
        type = Type.addedUserToRoom;
      } else if (map['t'] == 'ru') {
        type = Type.removedUserFromRoom;
      } else {
        type = Type.unknown;
      }
    }
    return Message(
      id: map["_id"],
      roomId: map["rid"],
      msg: map["msg"],
      timestamp: DateTime.parse(map["ts"]),
      user: User.fromMap(map),
      channels: List<Channel>.from(
          (map["channels"] ?? []).map((x) => Channel.fromMap(x))),
      mentions:
          List<User>.from((map["mentions"] ?? []).map((x) => User.fromMap(x))),
      attachments: (map['attachments'] != null)
          ? [Attachment(titleLink: map['attachments'])]
          : null,
      type: type,
    );
  }
}
