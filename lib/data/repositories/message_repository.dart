import 'dart:convert';
import 'dart:io';

import 'package:chat_app/constants/enums.dart';
import 'package:chat_app/data/data_providers/api/message_provider.dart';
import 'package:chat_app/data/data_providers/api/rocket_message_provider.dart';
import 'package:chat_app/data/data_providers/local_storage/message_localstoreage.dart';
import 'package:chat_app/data/data_providers/local_storage/message_sqlite.dart';
import 'package:chat_app/data/models/auth.dart';
import 'package:chat_app/data/models/message.dart';
import 'package:chat_app/utils/formatter.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:flutter/material.dart';

class MessageRepository {
  final MessageProvider _messageProvider = RocketMessageProvider();
  final MessageLocalStorage _messageLocalStorage = MessageSqlite();

  Future<List<Message>> loadHistory(Auth auth, String roomId,
      [DateTime? from, int quantity = 20]) async {
    from ??= DateTime.now();
    try {
      if (StaticData.internetStatus == InternetStatus.connected) {
        String rawData =
            await _messageProvider.loadHistory(auth, roomId, from, quantity);
        rawData = formatStringJson(rawData);
        final json = jsonDecode(rawData);
        final messages = messagesFromMap(json['message']['result']['messages']);
        await _messageLocalStorage.saveMessages(messages);
        return messages;
      } else {
        final messages = await _messageLocalStorage.getMessages(roomId, from);
        return messages;
      }
    } catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);
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
