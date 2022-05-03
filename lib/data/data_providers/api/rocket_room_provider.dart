import 'dart:convert';

import 'package:chat_app/constants/exceptions.dart';
import 'package:chat_app/data/data_providers/api/rocket_server.dart';
import 'package:chat_app/data/data_providers/api/room_provider.dart';
import 'package:chat_app/data/models/auth.dart';
import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:http/http.dart' as http;

class RocketRoomProvider extends RocketServer implements RoomProvider {
  final _listRoomRoute = '/api/v1/teams.listRooms';
  final _roomInfoRoute = '/api/v1/rooms.info';
  final _createGroupRoute = '/api/v1/groups.create';
  final _createChannelRoute = '/api/v1/channels.create';
  final _channelMembersRoute = '/api/v1/channels.members';
  final _groupMembersRoute = '/api/v1/groups.members';
  final _inviteRoute = '/api/v1/method.call/addUsersToRoom';
  final _deleteChannelRoute = '/api/v1/channels.delete';
  final _deleteGroupRoute = '/api/v1/groups.delete';
  final _leaveRoomRoute = '/api/v1/method.call/leaveRoom';
  final _kickGroupRoute = '/api/v1/groups.kick';
  final _kickChannelRoute = '/api/v1/channels.kick';

  @override
  Future<String> listRooms(
      Auth auth, String teamId, String? filter, String? type) async {
    String uri = '$serverAddr$_listRoomRoute?teamId=$teamId';
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
  getRoomInfo(Auth auth, String roomId) async {
    try {
      final response = await http.get(
        Uri.parse('$serverAddr$_roomInfoRoute?roomId=$roomId'),
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
  Future<String> createGroup(Auth auth, String teamId, String name) async {
    try {
      final response = await http.post(
        Uri.parse('$serverAddr$_createGroupRoute'),
        headers: {
          'X-Auth-Token': auth.token,
          'X-User-Id': auth.userId,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'extraData': {
            'teamId': teamId,
            'description': '',
            'broadcast': false,
            'encrypted': false,
          },
          'name': name,
        }),
      );
      return response.body;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> createChannel(Auth auth, String teamId, String name) async {
    try {
      final response = await http.post(
        Uri.parse('$serverAddr$_createChannelRoute'),
        headers: {
          'X-Auth-Token': auth.token,
          'X-User-Id': auth.userId,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'extraData': {
            'teamId': teamId,
            'description': '',
            'broadcast': false,
            'encrypted': false,
          },
          'name': name,
        }),
      );
      return response.body;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> channelMembers(
      Auth auth, String? selector, String roomId) async {
    try {
      final String url;
      if (selector == null) {
        url = '$serverAddr$_channelMembersRoute?roomId=$roomId';
      } else {
        url =
            '$serverAddr$_channelMembersRoute?roomId=$roomId&filter=$selector';
      }
      final response = await http.get(
        Uri.parse(url),
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
  Future<String> groupMembers(
      Auth auth, String? selector, String roomId) async {
    try {
      final String url;
      if (selector == null) {
        url = '$serverAddr$_groupMembersRoute?roomId=$roomId';
      } else {
        url = '$serverAddr$_groupMembersRoute?roomId=$roomId&filter=$selector';
      }
      final response = await http.get(
        Uri.parse(url),
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
  Future<String> deleteChannel(Auth auth, String roomId) async {
    try {
      final response = await http.post(
        Uri.parse('$serverAddr$_deleteChannelRoute'),
        headers: {
          'X-Auth-Token': auth.token,
          'X-User-Id': auth.userId,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'roomId': roomId,
        }),
      );
      return response.body;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> deleteGroup(Auth auth, String roomId) async {
    try {
      final response = await http.post(
        Uri.parse('$serverAddr$_deleteGroupRoute'),
        headers: {
          'X-Auth-Token': auth.token,
          'X-User-Id': auth.userId,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'roomId': roomId,
        }),
      );
      return response.body;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> leaveRoom(Auth auth, String roomId) async {
    try {
      final response = await http.post(
        Uri.parse('$serverAddr$_leaveRoomRoute'),
        headers: {
          'X-Auth-Token': auth.token,
          'X-User-Id': auth.userId,
        },
        body: {
          'message':
              '{"msg":"method","id":"${StaticData.idRandom}","method":"leaveRoom","params":["$roomId"]}'
        },
      );
      return response.body;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> kickChannel(Auth auth, String roomId, String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$serverAddr$_kickChannelRoute'),
        headers: {
          'X-Auth-Token': auth.token,
          'X-User-Id': auth.userId,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'roomId': roomId,
          'userId': userId,
        }),
      );
      return response.body;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> kickGroup(Auth auth, String roomId, String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$serverAddr$_kickGroupRoute'),
        headers: {
          'X-Auth-Token': auth.token,
          'X-User-Id': auth.userId,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'roomId': roomId,
          'userId': userId,
        }),
      );
      return response.body;
    } catch (e) {
      rethrow;
    }
  }
}
