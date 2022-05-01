import 'package:chat_app/data/models/auth.dart';
import 'package:chat_app/data/models/user.dart';

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

  Future inviteUsers(Auth auth, String teamRoomId, List<User> users);

  Future<String> deleteGroup(Auth auth, String roomId);
  Future<String> deleteChannel(Auth auth, String roomId);
  Future<String> leaveRoom(Auth auth, String roomId);
}
