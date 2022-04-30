import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:chat_app/constants/values.dart';
import 'package:chat_app/data/models/message.dart';
import 'package:chat_app/data/models/room.dart';
import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/data/repositories/room_repository.dart';
import 'package:chat_app/logic/blocs/team/team_bloc.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final RoomRepository roomRepository;
  final TeamBloc teamBloc;
  final StreamController<List<User>> _searchController =
      StreamController<List<User>>();
  late final StreamSubscription _messageStreamSub;

  Stream<List<User>> get searchStream => _searchController.stream;
  RoomBloc({required this.teamBloc, required this.roomRepository})
      : super(RoomInitial()) {
    _messageStreamSub = teamBloc.messageStream.listen((event) {
      emit(RoomReceiveMessage(message: event));
      // _messageController.sink.add(event);
    });
    on<LoadRooms>(loadRooms);
    on<SelectRoom>(selectRoom);
  }

  Future<void> selectRoom(SelectRoom event, emit) async {
    StaticData.roomIdForcus = event.room.id;
    emit(RoomSelected(room: event.room));
  }

  Future<void> loadRooms(event, emit) async {
    final List<Room> publicRooms = [];
    final List<Room> privateRooms = [];
    final Room generalRoom;

    generalRoom = await roomRepository.getGeneralRoom(event.teamRoomId);

    final rooms = await roomRepository.listRooms(
      teamId: event.teamId,
      filter: event.filter,
      type: event.type,
    );
    for (var room in rooms) {
      if (room.type == RoomTypes.publicRoom) {
        publicRooms.add(room);
      } else if (room.type == RoomTypes.privateRoom) {
        privateRooms.add(room);
      }
    }
    emit(RoomLoaded(
      publicRooms: publicRooms,
      privateRooms: privateRooms,
      generalRoom: generalRoom,
      teamId: event.teamId,
    ));
  }

  Future<CreateRoomStatus> createRoom(
      {required String teamId,
      required String name,
      required bool isPrivate}) async {
    final status = await roomRepository.createRoom(
      teamId: teamId,
      name: name,
      isPrivate: isPrivate,
    );
    return status;
    // emit(RoomCreated(room: room));
  }

  Timer? _debounce;
  void searchMember(String selector, Room room) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final usersSearch = await roomRepository.searchMember(room, selector);
      _searchController.sink.add(usersSearch);
    });
  }

  @override
  Future<void> close() {
    _messageStreamSub.cancel();
    _searchController.close();
    return super.close();
  }
}
