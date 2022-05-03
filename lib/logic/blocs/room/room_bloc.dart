import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:chat_app/constants/values.dart';
import 'package:chat_app/data/models/message.dart';
import 'package:chat_app/data/models/room.dart';
import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/data/repositories/room_repository.dart';
import 'package:chat_app/data/repositories/team_repository.dart';
import 'package:chat_app/logic/blocs/team/team_bloc.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final RoomRepository roomRepository;
  final TeamRepository teamRepository = TeamRepository();
  final TeamBloc teamBloc;

  final StreamController<List<User>> _roomMemberController =
      StreamController<List<User>>.broadcast();

  final StreamController<List<User>> _teamMemberController =
      StreamController<List<User>>.broadcast();

  final StreamController<List<User>> _selectStreamController =
      StreamController<List<User>>.broadcast();

  late final StreamSubscription _messageStreamSub;

  Stream<List<User>> get teamMemberStream => _teamMemberController.stream;
  Stream<List<User>> get selectStream => _selectStreamController.stream;
  Stream<List<User>> get searchStream => _roomMemberController.stream;
  RoomBloc({required this.teamBloc, required this.roomRepository})
      : super(RoomInitial()) {
    _messageStreamSub = teamBloc.messageStream.listen((event) {
      emit(RoomReceiveMessage(message: event));
      // _messageController.sink.add(event);
    });
    on<LoadRooms>(loadRooms);
    on<SelectRoom>(selectRoom);
  }

  Future<void> leaveRoom({required Room room}) async {
    try {
      await roomRepository.leaveRoom(room);
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
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

  List<User>? listMember;
  void listMemberInRoom(Room room) async {
    listMember ??= await roomRepository.searchMember(room, '');
    _roomMemberController.sink.add(listMember!);
  }

  List<User> _listTeamMember = [];
  List<User> _listSelected = [];

  void selectUserInvite(User user) {
    _listSelected.add(user);
    _listTeamMember.remove(user);
    _teamMemberController.sink.add(_listTeamMember);
    _selectStreamController.sink.add(_listSelected);
  }

  void removeUserInvite(User user) {
    _listSelected.remove(user);
    _listTeamMember.add(user);
    _teamMemberController.sink.add(_listTeamMember);
    _selectStreamController.sink.add(_listSelected);
  }

  Future<void> inviteUser({required Room room}) async {
    await roomRepository.addToRoom(room, _listSelected);
    listMember = await roomRepository.searchMember(room, '');
    _roomMemberController.sink.add(listMember!);

    clearSearchUser();
  }

  void listMemberInTeam(String teamId) async {
    _listTeamMember = await teamRepository.listMember(teamId);
    _teamMemberController.sink.add(_listTeamMember);
  }

  void clearSearchUser() {
    _listTeamMember = [];
    _listSelected = [];
  }

  Future deleteRoom(Room room) async {
    await roomRepository.deleteRoom(room);
  }

  Future<bool> kickRoom(Room room, String userId) async {
    final ok = await roomRepository.kickRoom(room, userId);
    if (ok) {
      for (User user in listMember ?? []) {
        if (user.id == userId) {
          listMember!.remove(user);
          break;
        }
      }

      _roomMemberController.sink.add(listMember!);
      return true;
    }

    _roomMemberController.sink.add(listMember!);
    return false;
  }

  @override
  Future<void> close() {
    _messageStreamSub.cancel();
    _roomMemberController.close();
    _teamMemberController.close();
    _selectStreamController.close();
    return super.close();
  }
}
