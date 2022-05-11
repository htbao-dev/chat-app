import 'dart:convert';

import 'package:chat_app/constants/exceptions.dart';
import 'package:chat_app/data/data_providers/api/rocket_server.dart';
import 'package:chat_app/data/data_providers/api/team_provider.dart';
import 'package:chat_app/data/models/auth.dart';
import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/data/models/team.dart';
import 'package:chat_app/data/models/room.dart';
import 'package:http/http.dart' as http;

class RocketTeamProvider extends RocketServer implements TeamProvider {
  final _listTeamRoute = '/api/v1/users.listTeams';
  final _createTeamRoute = '/api/v1/teams.create';
  final _setRoomAutoJoinRoute = '/api/v1/teams.updateRoom';
  final _listMemberRoute = '/api/v1/teams.members';
  final _removeMemberFromTeamRoute = '/api/v1/teams.removeMember';
  // final _listRoomRoute = '/api/v1/teams.listRooms';
  final _listRoomRoute = '/api/v1/teams.listRoomsOfUser';
  final _leaveTeamRoute = '/api/v1/teams.leave';
  final _deleteTeamRoute = '/api/v1/teams.delete';
  @override
  Future<String> listTeams(Auth auth) async {
    final response = await http.get(
      Uri.parse('$serverAddr$_listTeamRoute?userId=${auth.userId}'),
      headers: {
        keyHeaderToken: auth.token,
        keyHeaderUserId: auth.userId,
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw ServerException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }
  }

  @override
  Future<String> createTeam(Auth auth, String name) async {
    try {
      final response = await http.post(
        Uri.parse('$serverAddr$_createTeamRoute'),
        headers: {
          'X-Auth-Token': auth.token,
          'X-User-Id': auth.userId,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'type': 1,
          'room': {
            "readOnly": false,
            "extraData": {
              "description": "",
              "broadcast": false,
              "encrypted": false
            }
          }
        }),
      );
      return response.body;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> setRoomAutoJoin(
      Auth auth, String roomId, bool autoJoin) async {
    try {
      final response = await http.post(
        Uri.parse('$serverAddr$_setRoomAutoJoinRoute'),
        headers: {
          'X-Auth-Token': auth.token,
          'X-User-Id': auth.userId,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'roomId': roomId, 'isDefault': autoJoin}),
      );
      return response.body;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> listMembers(Auth auth, String teamId) async {
    try {
      final response = await http.get(
        Uri.parse('$serverAddr$_listMemberRoute?teamId=$teamId'),
        headers: {
          keyHeaderToken: auth.token,
          keyHeaderUserId: auth.userId,
        },
      );
      return response.body;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> removeMemberFromTeam(
    Auth auth,
    User user,
    Team team,
    List<Room> rooms,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$serverAddr$_removeMemberFromTeamRoute'),
        headers: {
          'X-Auth-Token': auth.token,
          'X-User-Id': auth.userId,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': user.id,
          'teamId': team.id,
          if (rooms.isNotEmpty) 'rooms': rooms.map((room) => room.id).toList(),
        }),
      );
      return response.body;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> listRooms(
      Auth auth, String teamId, String? filter, String? type) async {
    String uri =
        '$serverAddr$_listRoomRoute?teamId=$teamId&userId=${auth.userId}';
    // String uri = '$serverAddr$_listRoomRoute?teamId=$teamId';
    if (filter != null) {
      uri += '&filter=$filter';
    }
    if (type != null) {
      uri += '&type=$type';
    }
    try {
      var response = await http.get(
        Uri.parse(uri),
        headers: {
          'X-Auth-Token': auth.token,
          'X-User-Id': auth.userId,
        },
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.body,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> leaveTeam(Auth auth, Team team, List<Room> rooms) async {
    try {
      final response = await http.post(
        Uri.parse('$serverAddr$_leaveTeamRoute'),
        headers: {
          'X-Auth-Token': auth.token,
          'X-User-Id': auth.userId,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'teamId': team.id,
          if (rooms.isNotEmpty) 'rooms': rooms.map((room) => room.id).toList(),
        }),
      );
      return response.body;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> deleteTeam(Auth auth, Team team, List<Room> rooms) async {
    try {
      final response = await http.post(
        Uri.parse('$serverAddr$_deleteTeamRoute'),
        headers: {
          'X-Auth-Token': auth.token,
          'X-User-Id': auth.userId,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'teamId': team.id,
          if (rooms.isNotEmpty)
            'roomsToRemove': rooms.map((room) => room.id).toList(),
        }),
      );
      return response.body;
    } catch (e) {
      rethrow;
    }
  }
}
