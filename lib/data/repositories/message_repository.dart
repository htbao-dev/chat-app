import 'dart:convert';
import 'dart:io';

import 'package:chat_app/data/data_providers/api/message_provider.dart';
import 'package:chat_app/data/data_providers/api/rocket_message_provider.dart';
import 'package:chat_app/data/models/auth.dart';
import 'package:chat_app/data/models/message.dart';
import 'package:chat_app/utils/formatter.dart';

class MessageRepository {
  final MessageProvider _messageProvider = RocketMessageProvider();

  Future<List<Message>> loadHistory(Auth auth, String roomId,
      [DateTime? from, int quantity = 20]) async {
    from ??= DateTime.now();
    try {
      String rawData =
          await _messageProvider.loadHistory(auth, roomId, from, quantity);
      rawData = formatStringJson(rawData);
      // print(rawData);
      final json = jsonDecode(rawData);
      final messages = messagesFromMap(json['message']['result']['messages']);
      return messages;
    } catch (e, s) {
      // ignore: avoid_print
      print(e);
      // ignore: avoid_print
      print(s);
      return [];
    }
  }

  Future<Message?> sendMessage(Auth auth,
      {required String roomId, required String msg, File? file}) async {
    try {
      String rawData;
      if (file == null) {
        rawData =
            await _messageProvider.sendMessage(auth, roomId: roomId, msg: msg);
        rawData = formatStringJson(rawData);
      } else {
        rawData = await _messageProvider.sendFilesMessage(auth,
            roomId: roomId, msg: msg, file: file);
      }
      final json = jsonDecode(rawData);
      final message = Message.fromMap(json['message']['result']);
      return message;
    } catch (e, s) {
      // ignore: avoid_print
      print(e.toString());
      // ignore: avoid_print
      print(s);
      return null;
    }
  }
}
