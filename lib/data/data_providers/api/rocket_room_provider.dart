import 'dart:convert';

import 'package:chat_app/constants/exceptions.dart';
import 'package:chat_app/data/data_providers/api/rocket_server.dart';
import 'package:chat_app/data/data_providers/api/room_provider.dart';
import 'package:chat_app/data/models/auth.dart';
import 'package:http/http.dart' as http;

class RocketRoomProvider extends RocketServer implements RoomProvider {
  final _listRoomRoute = '/api/v1/teams.listRooms';
  final _roomInfoRoute = '/api/v1/rooms.info';
  final _createGroupRoute = '/api/v1/groups.create';
  final _createChannelRoute = '/api/v1/channels.create';
  final _channelMembersRoute = '/api/v1/channels.members';
  final _groupMembersRoute = '/api/v1/groups.members';
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
}
