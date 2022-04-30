import 'package:chat_app/data/data_providers/local_storage/auth_localstorage.dart';
import 'package:chat_app/data/data_providers/local_storage/sqlite_core.dart';
import 'package:chat_app/data/models/auth.dart';
import 'package:sqflite/sqflite.dart';

class AuthSqlite implements AuthLocalStorage {
  final SqliteCore _localDb = SqliteCore();
  @override
  Future<Auth?> getAuth() async {
    Auth? _auth;
    final db = await _localDb.database;
    final authQuery = await db.query(tableAuth);
    if (authQuery.isNotEmpty) {
      var token = (authQuery.first[AuthFields.token] as String);
      var userId = (authQuery.first[AuthFields.userId] as String);
      _auth = Auth(token: token, userId: userId);
    }

    return _auth;
  }

  @override
  Future<void> saveAuth(Auth auth) async {
    try {
      final db = await _localDb.database;
      await db.insert(
        tableAuth,
        {
          AuthFields.token: auth.token,
          AuthFields.userId: auth.userId,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> clearAuth() async {
    try {
      final db = await _localDb.database;
      await db.delete(tableAuth);
    } catch (e) {
      rethrow;
    }
  }
}
