import 'package:chat_app/data/data_providers/local_storage/sqlite_core.dart';
import 'package:chat_app/data/data_providers/local_storage/user_localstorage.dart';
import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/utils/strings.dart';
import 'package:sqflite/sqflite.dart';

class UserSqlite implements UserLocalStorage {
  final SqliteCore _localDb = SqliteCore();
  @override
  Future<User?> getUser(String userId) async {
    final Database db = await _localDb.database;
    List<Map<String, dynamic>> maps = await db.query(
      tableUser,
      where: '${UserFields.id} = ?',
      whereArgs: [userId],
    );
    if (maps.isNotEmpty) {
      return _userFromDbMap(maps.first);
    }
    return null;
  }

  @override
  Future<void> saveUsers(List<User> user) async {
    var db = await _localDb.database;
    var batch = db.batch();
    for (var user in user) {
      batch.insert(tableUser, _userToDbMap(user).remove(UserFields.email),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Map<String, dynamic> _userToDbMap(User user) {
    var map = user.toMap();
    return map;
  }

  @override
  Future<List<User>> getUsersInRoom(String roomId) async {
    var db = await _localDb.database;
    var userQuery = await db.rawQuery(
      'SELECT * FROM $tableUser as u JOIN (SELECT $tableRoomUser_user FROM $tableRoomUser WHERE $tableRoomUser_room= ?) as ru ON u.${UserFields.id} = ru.$tableRoomUser_user',
      [roomId],
    );
    return usersFromMap(userQuery, _userFromDbMap);
  }

  @override
  Future<void> saveUser(User user) async {
    var db = await _localDb.database;
    final map = _userToDbMap(user);
    await db.insert(tableUser, map,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

User _userFromDbMap(Map<String, dynamic> userMap) {
  return User(
    id: userMap['_id'],
    name: userMap['name'],
    emails: userMap['email'] != null
        ? [Email(address: userMap['email'], verified: null)]
        : null,
    username: userMap['username'],
    avatarUrl: userMap['avatarUrl'] ??
        getAvatarUrl(param: userMap['username'], isRoomOrTeam: false),
  );
}
