part of 'chat_bloc.dart';

@immutable
abstract class ChatState extends Equatable {}

class MessageInitial extends ChatState {
  @override
  List<Object> get props => [];
}

class HistoryLoaded extends ChatState {
  final List<Message> listMessage;

  HistoryLoaded({
    required this.listMessage,
  });

  @override
  List<Object> get props => [listMessage];
}

class MessageSent extends ChatState {
  final Message message;

  MessageSent({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class MessageReceive extends ChatState {
  final Message message;

  MessageReceive({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
