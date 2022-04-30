import 'package:chat_app/data/data_providers/local_storage/room_localstorage.dart';
import 'package:chat_app/data/data_providers/local_storage/sqlite_core.dart';
import 'package:chat_app/data/models/room.dart';
import 'package:sqflite/sqflite.dart';

class RoomSqlite implements RoomLocalStorage {
  final SqliteCore _localDb = SqliteCore();

  @override
  Future saveListRooms(List<Room> rooms, String teamId) async {
    var db = await _localDb.database;
    var batch = db.batch();
    for (var room in rooms) {
      batch.insert(tableRoom, _roomToDbMap(room, teamId),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<Room>> listRooms(String teamId) async {
    var db = await _localDb.database;
    var roomQuery = await db.query(tableRoom,
        where: '${RoomFields.teamId} = ?', whereArgs: [teamId]);
    return _roomsFromDbMap(roomQuery);
  }

  @override
  Future saveRoom(Room room, {String? teamId}) async {
    var db = await _localDb.database;
    await db.insert(tableRoom, _roomToDbMap(room, teamId),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  List<Room> _roomsFromDbMap(List<Map<String, dynamic>> roomMaps) {
    return roomsFromMap(roomMaps);
  }

  Map<String, Object?> _roomToDbMap(Room room, String? teamId) {
    return {
      RoomFields.id: room.id,
      RoomFields.name: room.name,
      RoomFields.type: room.type,
      RoomFields.teamId: teamId,
      RoomFields.description: room.description,
    };
  }

  @override
  Future<Room> getRoomInfo(String roomId) async {
    final db = await _localDb.database;
    final roomQuery = await db
        .query(tableRoom, where: '${RoomFields.id} = ?', whereArgs: [roomId]);
    final Room room = Room.fromJson(roomQuery.first);
    return room;
  }
}
