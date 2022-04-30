import 'dart:convert';

import 'package:chat_app/constants/exceptions.dart';
import 'package:chat_app/constants/values.dart';
import 'package:chat_app/data/data_providers/api/rocket_server.dart';
import 'package:chat_app/data/data_providers/api/team_provider.dart';
import 'package:chat_app/data/models/auth.dart';
import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:http/http.dart' as http;

class RocketTeamProvider extends RocketServer implements TeamProvider {
  final _listTeamRoute = '/api/v1/users.listTeams';
  final _createTeamRoute = '/api/v1/teams.create';
  final _inviteRoute = '/api/v1/method.call/addUsersToRoom';
  final _setRoomAutoJoinRoute = '/api/v1/teams.updateRoom';
  @override
  Future<String> listTeams(Auth auth) async {
    print(auth.token);
    print(auth.userId);
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
  Future inviteUsers(Auth auth, String teamRoomId, List<User> users) async {
    try {
      String data = '';
      for (int i = 0; i < users.length; i++) {
        data += '"${users[i].username}"';
        if (i != users.length - 1) {
          data += ',';
        }
      }
      final response = await http.post(
        Uri.parse('$serverAddr$_inviteRoute'),
        headers: {
          'X-Auth-Token': auth.token,
          'X-User-Id': auth.userId,
        },
        body: {
          'message':
              '{"msg":"method","id":"${StaticData.idRandom}","method":"addUsersToRoom","params":[{"rid":"$teamRoomId","users":[$data]}]}'
        },
      );
      return response.body;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> setRoomAutoJoin(
      Auth Auth, String roomId, bool autoJoin) async {
    try {
      final response = await http.post(
        Uri.parse('$serverAddr$_setRoomAutoJoinRoute'),
        headers: {
          'X-Auth-Token': Auth.token,
          'X-User-Id': Auth.userId,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'roomId': roomId, 'isDefault': autoJoin}),
      );
      return response.body;
    } catch (e) {
      rethrow;
    }
  }
}
