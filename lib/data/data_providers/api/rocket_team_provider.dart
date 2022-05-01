import 'dart:convert';

import 'package:chat_app/constants/exceptions.dart';
import 'package:chat_app/data/data_providers/api/rocket_server.dart';
import 'package:chat_app/data/data_providers/api/team_provider.dart';
import 'package:chat_app/data/models/auth.dart';
import 'package:http/http.dart' as http;

class RocketTeamProvider extends RocketServer implements TeamProvider {
  final _listTeamRoute = '/api/v1/users.listTeams';
  final _createTeamRoute = '/api/v1/teams.create';
  final _setRoomAutoJoinRoute = '/api/v1/teams.updateRoom';
  final _listMemberRoute = '/api/v1/teams.members';
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
}
