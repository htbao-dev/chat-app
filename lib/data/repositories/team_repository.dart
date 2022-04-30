import 'dart:convert';

import 'package:chat_app/constants/enums.dart';
import 'package:chat_app/data/data_providers/api/rocket_team_provider.dart';
import 'package:chat_app/data/data_providers/api/team_provider.dart';
import 'package:chat_app/data/data_providers/local_storage/team_localstorage.dart';
import 'package:chat_app/data/data_providers/local_storage/team_sqlite.dart';
import 'package:chat_app/data/models/team.dart';
import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:flutter/widgets.dart';

class TeamRepository {
  final TeamProvider _teamProvider = RocketTeamProvider();
  final TeamLocalStorage _teamLocalStorage = TeamSqlite();
  Future<List<Team>> listTeams() async {
    try {
      if (StaticData.internetStatus == InternetStatus.disconnected) {
        final teams = await _teamLocalStorage.listTeams();
        return teams;
      } else {
        final auth = StaticData.auth!;
        final rawData = await _teamProvider.listTeams(auth);
        var decodeData = jsonDecode(rawData);
        final teams = teamsFromMap(decodeData['teams']);
        print(teams.length);
        _teamLocalStorage.saveTeams(teams);
        return teams;
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      return [];
    }
  }

  Future<CreateTeamStatus> createTeam({required String name}) async {
    try {
      final auth = StaticData.auth!;
      final String rawData;
      rawData = await _teamProvider.createTeam(auth, name);
      var decodeData = jsonDecode(rawData);
      if (decodeData['success'] == true) {
        return CreateTeamStatus.success;
      } else if (decodeData['error'] == "team-name-already-exists") {
        return CreateTeamStatus.duplicateName;
      }
      return CreateTeamStatus.unknown;
      // final room = Room.fromJson(decodeData['room']);
      // _roomLocalStorage.saveRoom(room, teamId: teamId);
      // return room;
    } catch (e) {
      debugPrint(e.toString());
      return CreateTeamStatus.unknown;
    }
  }

  Future<bool> inviteUsers(
      {required String teamRoomId, required List<User> users}) async {
    try {
      final auth = StaticData.auth!;
      final String rawData;
      rawData = await _teamProvider.inviteUsers(auth, teamRoomId, users);
      var decodeData = jsonDecode(rawData);
      if (decodeData['success'] == true) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> setRoomAutoJoin(String roomId) async {
    try {
      final auth = StaticData.auth!;
      final String rawData;
      rawData = await _teamProvider.setRoomAutoJoin(auth, roomId, true);
      var decodeData = jsonDecode(rawData);
      if (decodeData['success'] == true) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}

enum CreateTeamStatus {
  success,
  duplicateName,
  unknown,
}
