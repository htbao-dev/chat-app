import 'package:chat_app/data/models/team.dart';

abstract class TeamLocalStorage {
  Future<List<Team>> listTeams();
  Future saveTeams(List<Team> teams);
  Future deleteTeams();
}
