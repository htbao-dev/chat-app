import 'package:chat_app/data/models/auth.dart';

abstract class RoomProvider {
  Future<String> listRooms(
      Auth auth, String teamId, String? filter, String? type);

  Future<String> getRoomInfo(Auth auth, String roomId);

  ///private "room"
  Future<String> createGroup(Auth auth, String teamId, String name);

  ///public "room"
  Future<String> createChannel(Auth auth, String teamId, String name);

  Future<String> groupMembers(Auth auth, String? selector, String roomId);

  Future<String> channelMembers(Auth auth, String? selector, String roomId);
}
