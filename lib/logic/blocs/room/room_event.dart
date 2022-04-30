part of 'room_bloc.dart';

@immutable
abstract class RoomEvent {}

class LoadRooms extends RoomEvent {
  final String teamId;
  final String teamRoomId;
  final String? filter;
  final String? type;
  LoadRooms(
      {required this.teamRoomId, required this.teamId, this.filter, this.type});
}

class SelectRoom extends RoomEvent {
  final Room room;
  SelectRoom(this.room);
}

class CreateRoom extends RoomEvent {
  final String teamId;
  final String name;
  final bool isPrivate;
  CreateRoom(
      {required this.teamId, required this.name, required this.isPrivate});
}
