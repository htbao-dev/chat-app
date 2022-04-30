import 'package:chat_app/data/models/auth.dart';
import 'package:chat_app/data/models/user.dart';

abstract class TeamProvider {
  Future<String> listTeams(Auth auth);
  Future<String> createTeam(Auth auth, String name);
  Future inviteUsers(Auth auth, String teamRoomId, List<User> users);
  Future<String> setRoomAutoJoin(Auth Auth, String roomId, bool autoJoin);
}
