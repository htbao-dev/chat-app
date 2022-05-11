import 'package:chat_app/data/models/room.dart';
import 'package:chat_app/data/models/team.dart';
import 'package:chat_app/data/models/user.dart';

abstract class TeamLocalStorage {
  Future<List<Team>> listTeams();
  Future saveTeams(List<Team> teams);
  Future<void> deleteTeam(String teamId);
  Future deleteTeams();

  void removeMemberFromTeam(User user, Team team, List<Room> rooms);
}
