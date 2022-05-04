import 'dart:convert';

import 'package:chat_app/constants/enums.dart';
import 'package:chat_app/data/data_providers/api/rocket_room_provider.dart';
import 'package:chat_app/data/data_providers/api/rocket_team_provider.dart';
import 'package:chat_app/data/data_providers/api/room_provider.dart';
import 'package:chat_app/data/data_providers/api/team_provider.dart';
import 'package:chat_app/data/data_providers/local_storage/team_localstorage.dart';
import 'package:chat_app/data/data_providers/local_storage/team_sqlite.dart';
import 'package:chat_app/data/models/team.dart';
import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:flutter/widgets.dart';

class TeamRepository {
  final TeamProvider _teamProvider = RocketTeamProvider();
  final RoomProvider _roomProvider = RocketRoomProvider();
  final TeamLocalStorage _teamLocalStorage = TeamSqlite();

  Future<List<User>> listMember(String teamId) async {
    try {
      if (StaticData.internetStatus == InternetStatus.disconnected) {
        return [];
      } else {
        final auth = StaticData.auth!;
        final rawData = await _teamProvider.listMembers(auth, teamId);
        var decodeData = jsonDecode(rawData);
        final users =
            usersFromMap(decodeData['members'].map((e) => e['user']).toList());
        // _teamLocalStorage.saveListMember(users);
        return users;
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      return [];
    }
  }

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
      rawData = await _roomProvider.inviteUsers(auth, teamRoomId, users);
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

  Future<List<User>> listTeamMember(String teamRoomId) async {
    try {
      final auth = StaticData.auth!;
      final rawData = await _roomProvider.groupMembers(auth, null, teamRoomId);
      var decodeData = jsonDecode(rawData);
      if (decodeData['success'] == true) {
        final users = usersFromMap(decodeData['members']);
        return users;
      }
      return [];
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}

enum CreateTeamStatus {
  success,
  duplicateName,
  unknown,
}
