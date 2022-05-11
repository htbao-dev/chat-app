import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chat_app/data/data_providers/websocket/chat_socket.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chat_app/data/models/message.dart';
import 'package:chat_app/data/models/room.dart';
import 'package:chat_app/data/repositories/message_repository.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:equatable/equatable.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final Room room;
  final ChatSocket chatSocket = ChatSocket();
  late final int _roomMessageStreamId;

  late final StreamSubscription _roomMessageStreamSub;
  late final StreamSubscription _changedSub;

  final MessageRepository messageRepository = MessageRepository();
  ChatBloc({required this.room}) : super(MessageInitial()) {
    _roomMessageStreamId = chatSocket.subStreamRoomMessage(room.id);
    _roomMessageStreamSub = chatSocket.roomMessageStream.listen((event) {
      Message message = Message.fromMap(event['fields']['args'][0]);
      emit(MessageReceive(message: message));
    });
    _changedSub = chatSocket.changedSubStream.listen((event) {
      if (event['fields']['args'][0] == 'removed') {
        final String removedRoomId = event['fields']['args'][1]['rid'];
        if (StaticData.roomIdForcus == removedRoomId) {
          add(RemoveRoom());
        }
      }
    });
    on<RemoveRoom>(((event, emit) {
      emit(RoomRemoved());
    }));
    on<LoadHistory>(loadHistory);
    on<SendMessage>(sendMessage);
    on<OpenGallery>(openGallery);
    on<OpenCamera>(openCamera);
  }

  Future loadHistory(event, emit) async {
    final messages = await messageRepository.loadHistory(
      StaticData.auth!,
      event.roomId,
      event.from,
    );
    emit(HistoryLoaded(listMessage: messages));
  }

  Future sendMessage(SendMessage event, Emitter<ChatState> emit) async {
    final msg = event.message;
    await messageRepository.sendMessage(
      StaticData.auth!,
      roomId: room.id,
      msg: msg,
    );
    // if (message != null) {
    //   emit(MessageSent(message: message));
    // }
  }

  Future openGallery(OpenGallery event, Emitter<ChatState> emit) async {
    try {
      final ImagePicker _picker = ImagePicker();
      final images = await _picker.pickMultiImage();
      for (var item in images ?? []) {
        messageRepository.sendMessage(StaticData.auth!,
            roomId: room.id, msg: 'send file', file: File(item.path));
      }
      // emit(ChatChooseImageSuccessState(image));
    } catch (e) {
      debugPrint(e.toString());
      // emit(ChatChooseImageErrorState());
    }
  }

  Future openCamera(OpenCamera event, Emitter<ChatState> emit) async {
    try {
      final ImagePicker _picker = ImagePicker();
      final image = await _picker.pickImage(source: ImageSource.camera);

      messageRepository.sendMessage(StaticData.auth!,
          roomId: room.id, msg: 'send file', file: File(image!.path));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<void> close() {
    StaticData.roomIdForcus = null;
    _changedSub.cancel();
    chatSocket.unsubStreamRoomMessage(_roomMessageStreamId);
    _roomMessageStreamSub.cancel();
    return super.close();
  }
}
