import 'package:chat_app/data/models/auth.dart';
import 'package:chat_app/data/models/room.dart';
import 'package:chat_app/data/models/team.dart';
import 'package:chat_app/data/models/user.dart';

abstract class TeamProvider {
  Future<String> listTeams(Auth auth);
  Future<String> createTeam(Auth auth, String name);
  Future<String> setRoomAutoJoin(Auth auth, String roomId, bool autoJoin);
  Future<String> listMembers(Auth auth, String teamId);
  Future<String> removeMemberFromTeam(
      Auth auth, User user, Team team, List<Room> rooms);
  Future<String> listRooms(
      Auth auth, String teamId, String? filter, String? type);

  Future<String> leaveTeam(Auth auth, Team team, List<Room> rooms);
  Future<String> deleteTeam(Auth auth, Team team, List<Room> rooms);
}
