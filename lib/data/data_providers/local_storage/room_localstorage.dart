import 'package:chat_app/data/models/room.dart';

abstract class RoomLocalStorage {
  Future saveListRooms(List<Room> rooms, String teamId);
  Future<List<Room>> listRooms(String teamId);
  Future saveRoom(Room room, {String? teamId});
  Future<Room> getRoomInfo(String roomId);
}
