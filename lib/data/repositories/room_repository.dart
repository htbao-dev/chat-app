import 'dart:convert';

import 'package:chat_app/constants/enums.dart';
import 'package:chat_app/data/data_providers/api/rocket_room_provider.dart';
import 'package:chat_app/data/data_providers/api/rocket_team_provider.dart';
import 'package:chat_app/data/data_providers/api/room_provider.dart';
import 'package:chat_app/data/data_providers/api/team_provider.dart';
import 'package:chat_app/data/data_providers/local_storage/room_localstorage.dart';
import 'package:chat_app/data/data_providers/local_storage/room_sqlite.dart';
import 'package:chat_app/data/data_providers/local_storage/user_localstorage.dart';
import 'package:chat_app/data/data_providers/local_storage/user_sqlite.dart';
import 'package:chat_app/data/models/room.dart';
import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:flutter/widgets.dart';

class RoomRepository {
  final RoomProvider _roomProvider = RocketRoomProvider();
  final TeamProvider _teamProvider = RocketTeamProvider();
  final RoomLocalStorage roomLocalStorage = RoomSqlite();
  final UserLocalStorage _userLocalStorage = UserSqlite();

  Future<Room> getGeneralRoom(String teamRoomId, String teamId) async {
    try {
      if (StaticData.internetStatus == InternetStatus.disconnected) {
        return roomLocalStorage.getRoomInfo(teamRoomId);
      } else {
        final auth = StaticData.auth!;
        final rawData = await _roomProvider.getRoomInfo(auth, teamRoomId);
        var decodeData = jsonDecode(rawData);
        final room = Room.fromJson(decodeData['room']);
        roomLocalStorage.saveRoom(room, teamId: teamRoomId);
        return room;
      }
    } catch (_) {
      return roomLocalStorage.getRoomInfo(teamRoomId);
    }
  }

  Future<Room> getRoom(String roomId) async {
    try {
      if (StaticData.internetStatus == InternetStatus.disconnected) {
        return roomLocalStorage.getRoomInfo(roomId);
      } else {
        final auth = StaticData.auth!;
        final rawData = await _roomProvider.getRoomInfo(auth, roomId);
        var decodeData = jsonDecode(rawData);
        final room = Room.fromJson(decodeData['room']);
        roomLocalStorage.saveRoom(room, teamId: room.teamId);
        return room;
      }
    } catch (_) {
      return roomLocalStorage.getRoomInfo(roomId);
    }
  }

  /// throws ServerException
  Future<Room> roomInfo(String roomId) async {
    try {
      final auth = StaticData.auth!;
      final rawData = await _roomProvider.getRoomInfo(
        auth,
        roomId,
      );
      var decodeData = jsonDecode(rawData);
      return Room.fromJson(decodeData['room']);
    } catch (_) {
      rethrow;
    }
  }

  Future<CreateRoomStatus> createRoom(
      {required String teamId,
      required String name,
      required bool isPrivate}) async {
    try {
      final auth = StaticData.auth!;
      final String rawData;
      if (isPrivate) {
        rawData = await _roomProvider.createGroup(auth, teamId, name);
      } else {
        rawData = await _roomProvider.createChannel(auth, teamId, name);
      }
      var decodeData = jsonDecode(rawData);
      if (decodeData['success'] == true) {
        if (!isPrivate) {
          final String roomId = decodeData['channel']['_id'];
          // final res =
          await _teamProvider.setRoomAutoJoin(auth, roomId, true);
        }
        return CreateRoomStatus.success;
      } else if (decodeData['errorType'] == "error-duplicate-channel-name") {
        return CreateRoomStatus.duplicateName;
      }
      return CreateRoomStatus.unknown;
      // final room = Room.fromJson(decodeData['room']);
      // _roomLocalStorage.saveRoom(room, teamId: teamId);
      // return room;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      return CreateRoomStatus.unknown;
    }
  }

  Future<List<User>> searchMember(
    Room room,
    String selector,
  ) async {
    try {
      if (StaticData.internetStatus == InternetStatus.connected) {
        final auth = StaticData.auth!;
        final String rawData;
        if (room.type == Room.privateRoom) {
          rawData = await _roomProvider.groupMembers(auth, selector, room.id);
        } else {
          rawData = await _roomProvider.channelMembers(auth, selector, room.id);
        }
        var decodeData = jsonDecode(rawData);
        if (decodeData['success'] == true) {
          final users = usersFromMap(decodeData['members']);
          // await _userLocalStorage.saveUsers(users);
          await roomLocalStorage.saveListUserInRoom(users, room.id);
          return users;
        }
        return [];
      } else {
        return _userLocalStorage.getUsersInRoom(room.id);
        // return [];
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future addToRoom(Room room, List<User> users) async {
    try {
      final auth = StaticData.auth!;
      final String rawData;
      rawData = await _roomProvider.inviteUsers(auth, room.id, users);
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

  Future deleteRoom(Room room) async {
    try {
      final auth = StaticData.auth!;
      final String rawData;
      if (room.type == Room.privateRoom) {
        rawData = await _roomProvider.deleteGroup(auth, room.id);
      } else {
        rawData = await _roomProvider.deleteChannel(auth, room.id);
      }
      var decodeData = jsonDecode(rawData);
      if (decodeData['success'] == true) {
        roomLocalStorage.deleteRoom(room.id);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future leaveRoom(Room room) async {
    try {
      final auth = StaticData.auth!;
      final rawData = await _roomProvider.leaveRoom(auth, room.id);
      var decodeData = jsonDecode(rawData);
      if (decodeData['success'] == true) {
        await roomLocalStorage.deleteRoom(room.id);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> kickRoom(Room room, String userId) async {
    try {
      final auth = StaticData.auth!;
      final String rawData;
      if (room.type == Room.privateRoom) {
        rawData = await _roomProvider.kickGroup(auth, room.id, userId);
      } else {
        rawData = await _roomProvider.kickChannel(auth, room.id, userId);
      }
      var decodeData = jsonDecode(rawData);
      if (decodeData['success'] == true) {
        roomLocalStorage.deleteUserInRoom(userId, room.id);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}

enum CreateRoomStatus {
  success,
  duplicateName,
  unknown,
}
