import 'package:chat_app/data/models/user.dart';
import 'dart:convert';

const String tableMessage = 'messages';

List<Message> messagesFromMap(List<dynamic> map,
    [Message Function(Map<String, dynamic> map)? function]) {
  function ??= Message.fromMap;
  return List<Message>.from(map.map((x) => function!(x)));
}

class MessageFields {
  static const String id = '_id';
  static const String roomId = 'rid';
  static const String userId = 'userId';
  static const String msg = 'msg';
  static const String type = 't';
  static const String timestamp = 'ts';
  static const String attachments = 'attachments';
}

enum Type {
  removedUserFromTeam,
  addedUserToTeam,
  userAddRoomToTeam,
  userDeleteRoomFromTeam,
  userLeftTeam,
  addedUserToRoom,
  removedUserFromRoom,
  userLeaveRoom,
  unknown
}

class Message {
  Message({
    required this.id,
    required this.roomId,
    required this.msg,
    required this.user,
    this.timestamp,
    this.updatedAt,
    this.urls,
    this.mentions,
    this.channels,
    this.attachments,
    this.type,
  });

  String id;
  String roomId;
  String? msg;
  DateTime? timestamp;
  User user;
  DateTime? updatedAt;
  List<String>? urls;
  List<User>? mentions;
  List<Channel>? channels;
  List<Attachment>? attachments;
  Type? type;

  String? typeToString() {
    if (type == null) return null;
    switch (type) {
      case Type.addedUserToTeam:
        return 'added-user-to-team';
      case Type.removedUserFromTeam:
        return 'removed-user-from-team';
      case Type.userAddRoomToTeam:
        return 'user-added-room-to-team';
      case Type.userDeleteRoomFromTeam:
        return 'user-deleted-room-from-team';
      case Type.userLeftTeam:
        return 'ult';
      case Type.addedUserToRoom:
        return 'au';
      case Type.removedUserFromRoom:
        return 'ru';
      case Type.userLeaveRoom:
        return 'ul';
      case Type.unknown:
        return 'unknown';
      default:
        return 'unknown';
    }
  }

  factory Message.fromJson(String str) => Message.fromMap(json.decode(str));

  factory Message.fromMap(Map<String, dynamic> map) {
    // print(map["msg"]);
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
      } else if (map['t'] == 'ul') {
        type = Type.userLeaveRoom;
      } else {
        type = Type.unknown;
      }
    }
    return Message(
      id: map["_id"],
      roomId: map["rid"],
      msg: map["msg"],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map["ts"]["\$date"]),
      user: User.fromMap(map["u"]),
      updatedAt:
          DateTime.fromMillisecondsSinceEpoch(map["_updatedAt"]["\$date"]),
      urls: List<String>.from((map["urls"] ?? []).map((x) => x)),
      channels: List<Channel>.from(
          (map["channels"] ?? []).map((x) => Channel.fromMap(x))),
      mentions:
          List<User>.from((map["mentions"] ?? []).map((x) => User.fromMap(x))),
      attachments: List<Attachment>.from(
          (map["attachments"] ?? []).map((x) => Attachment.fromMap(x))),
      type: type,
    );
  }
}

class Channel {
  final String? id;
  final String? name;

  Channel({required this.id, required this.name});

  factory Channel.fromMap(Map<String, dynamic> map) => Channel(
        id: map["_id"],
        name: map["name"],
      );
}

class Attachment {
  Attachment({
    this.ts,
    this.title,
    this.titleLink,
    this.titleLinkDownload,
    this.imageUrl,
    this.type,
  });

  DateTime? ts;
  String? title;
  String? titleLink;
  bool? titleLinkDownload;
  String? imageUrl;
  String? type;

  Attachment.fromMap(Map<String, dynamic> json)
      : this(
          ts: DateTime.parse(json["ts"]),
          title: json["title"],
          titleLink: json["title_link"],
          titleLinkDownload: json["title_link_download"],
          imageUrl: json["image_url"],
          type: json["type"],
        );
}
