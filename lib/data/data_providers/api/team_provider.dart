import 'package:chat_app/data/models/auth.dart';
import 'package:chat_app/data/models/user.dart';

abstract class TeamProvider {
  Future<String> listTeams(Auth auth);
  Future<String> createTeam(Auth auth, String name);
  Future<String> setRoomAutoJoin(Auth auth, String roomId, bool autoJoin);
  Future<String> listMembers(Auth auth, String teamId);
}
