import 'package:chat_app/data/data_providers/local_storage/sqlite_core.dart';
import 'package:chat_app/data/data_providers/local_storage/team_localstorage.dart';
import 'package:chat_app/data/models/team.dart';
import 'package:sqflite/sqlite_api.dart';

class TeamSqlite implements TeamLocalStorage {
  final SqliteCore _localDb = SqliteCore();
  @override
  Future<List<Team>> listTeams() async {
    try {
      final db = await _localDb.database;
      final teamQuery = await db.query(tableTeam);
      final teams = _teamsFromDbMap(teamQuery);
      return teams;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future saveTeams(List<Team> teams) async {
    final db = await _localDb.database;
    final batch = db.batch();
    for (var team in teams) {
      batch.insert(tableTeam, _teamToDbMap(team),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Map<String, dynamic> _teamToDbMap(Team team) {
    var map = team.toMap();
    map[TeamFields.createdBy] = team.createdBy.id;
    map[TeamFields.isOwner] = team.isOwner ? 1 : 0;
    return map;
  }

  List<Team> _teamsFromDbMap(List<Map<String, dynamic>> teamMaps) {
    return teamMaps.map((teamMap) {
      var team = Map<String, dynamic>.from(teamMap);
      team[TeamFields.createdBy] = {
        '_id': teamMap[TeamFields.createdBy],
      };
      team[TeamFields.isOwner] = teamMap[TeamFields.isOwner] == 1;
      return Team.fromMap(team);
    }).toList();
  }

  @override
  Future deleteTeams() async {
    final db = await _localDb.database;
    await db.delete(tableTeam);
  }
}
