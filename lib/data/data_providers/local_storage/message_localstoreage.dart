import 'package:chat_app/data/models/message.dart';

abstract class MessageLocalStorage {
  Future<List<Message>> getMessages(String roomId, DateTime from);
  Future<void> saveMessages(List<Message> messages);
  Future<void> clearMessages();
}
