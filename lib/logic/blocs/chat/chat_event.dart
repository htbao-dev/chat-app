part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class LoadHistory extends ChatEvent {
  final String roomId;
  final DateTime? from;
  final int? quantity;

  LoadHistory({
    required this.roomId,
    this.from,
    this.quantity,
  });
}

class SendMessage extends ChatEvent {
  final String message;

  SendMessage({required this.message});
}

class OpenGallery extends ChatEvent {}

class OpenCamera extends ChatEvent {}

class RemoveRoom extends ChatEvent {}
