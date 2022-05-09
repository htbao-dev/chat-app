import 'dart:io';

import 'package:chat_app/data/models/auth.dart';

abstract class MessageProvider {
  Future<String> loadHistory(Auth auth, String roomId,
      [DateTime? from, int quantity = 50]);

  Future<String> sendMessage(Auth auth,
      {required String roomId, required String msg});

  Future<String> sendFilesMessage(Auth auth,
      {required String roomId, required String? msg, required File file});
}
