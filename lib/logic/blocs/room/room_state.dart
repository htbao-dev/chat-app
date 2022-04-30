part of 'room_bloc.dart';

@immutable
abstract class RoomState extends Equatable {}

class RoomInitial extends RoomState {
  @override
  List<Object> get props => [];
}

class RoomLoaded extends RoomState {
  final Room generalRoom;
  final List<Room> publicRooms;
  final List<Room> privateRooms;
  final String teamId;
  RoomLoaded(
      {required this.publicRooms,
      required this.teamId,
      required this.privateRooms,
      required this.generalRoom});
  @override
  List<Object> get props => [publicRooms, privateRooms, teamId];
}

class RoomSelected extends RoomState {
  final Room room;
  RoomSelected({required this.room});
  @override
  List<Object> get props => [room, Random().nextInt(100)];
}

class RoomReceiveMessage extends RoomState {
  final Message message;
  RoomReceiveMessage({required this.message});
  @override
  List<Object> get props => [message];
}

class RoomCreated extends RoomState {
  final CreateRoomStatus status;
  RoomCreated({required this.status});
  @override
  List<Object> get props => [status];
}
