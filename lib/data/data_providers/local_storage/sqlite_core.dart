import 'dart:async';

import 'package:chat_app/data/models/auth.dart';
import 'package:chat_app/data/models/message.dart';
import 'package:chat_app/data/models/room.dart';
import 'package:chat_app/data/models/team.dart';
import 'package:chat_app/data/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

const String databaseName = 'chat_app.db';
const String tableRoomUser = tableRoom + '_' + tableUser;
// ignore: constant_identifier_names
const String tableRoomUser_room = 'roomId';
// ignore: constant_identifier_names
const String tableRoomUser_user = 'userId';

class SqliteCore {
  static final SqliteCore _instance = SqliteCore._internal();
  static Database? _database;

  factory SqliteCore() {
    return _instance;
  }

  SqliteCore._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase(databaseName);
    return _database!;
  }

  Future<Database> _initDatabase(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  FutureOr _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableUser (
        ${UserFields.id} TEXT PRIMARY KEY,
        ${UserFields.name} TEXT,
        ${UserFields.email} TEXT,
        ${UserFields.username} TEXT,
        ${UserFields.avatarUrl} TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableAuth (
        ${AuthFields.token} TEXT,
        ${AuthFields.userId} TEXT PRIMARY KEY
      )
    ''');
    await db.execute('''
      CREATE TABLE $tableTeam (
        ${TeamFields.id} TEXT PRIMARY KEY,
        ${TeamFields.name} TEXT,
        ${TeamFields.roomId} TEXT,
        ${TeamFields.type} INTEGER,
        ${TeamFields.createdAt} TEXT,
        ${TeamFields.createdBy} TEXT,
        ${TeamFields.updatedAt} TEXT,
        ${TeamFields.isOwner} INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableRoom (
        ${RoomFields.id} TEXT PRIMARY KEY,
        ${RoomFields.name} TEXT,
        ${RoomFields.teamId} TEXT,
        ${RoomFields.type} TEXT,
        ${RoomFields.description} TEXT,
        FORIEGN KEY ${RoomFields.teamId} REFERENCES $tableTeam(${TeamFields.id})
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableMessage (
        ${MessageFields.id} TEXT PRIMARY KEY,
        ${MessageFields.roomId} TEXT NOT NULL REFERENCES $tableRoom(${RoomFields.id}),
        ${MessageFields.userId} TEXT NOT NULL REFERENCES $tableUser(${UserFields.id}),
        ${MessageFields.msg} TEXT,
        ${MessageFields.type} TEXT,
        ${MessageFields.attachments} TEXT,
        ${MessageFields.timestamp} TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableRoomUser (
        $tableRoomUser_room TEXT NOT NULL REFERENCES $tableRoom(${RoomFields.id}),
        $tableRoomUser_user TEXT NOT NULL REFERENCES $tableUser(${UserFields.id}),
        PRIMARY KEY ($tableRoomUser_room, $tableRoomUser_user)
      )
    ''');
  }

  Future close() async {
    final db = await _instance.database;
    db.close();
  }
}
