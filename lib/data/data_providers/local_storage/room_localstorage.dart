import 'package:chat_app/data/models/room.dart';
import 'package:chat_app/data/models/user.dart';

abstract class RoomLocalStorage {
  Future saveListRooms(List<Room> rooms, String teamId);
  Future saveListUserInRoom(List<User> users, String roomId);
  Future<List<Room>> listRooms(String teamId);
  Future saveRoom(Room room, {String? teamId});
  Future<Room> getRoomInfo(String roomId);
}
