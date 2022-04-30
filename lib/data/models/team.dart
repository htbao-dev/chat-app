// To parse this JSON data, do
//
// final team = teamFromMap(jsonString);
import 'dart:convert';

const tableTeam = "team";

List<Team> teamsFromMap(List<dynamic> list) =>
    List<Team>.from(list.map((x) => Team.fromMap(x)));

class TeamFields {
  static const String id = "_id";
  static const String name = "name";
  static const String createdAt = "createdAt";
  static const String createdBy = "createdBy";
  static const String updatedAt = "_updatedAt";
  static const String roomId = "roomId";
  static const String isOwner = "isOwner";
  static const String type = 'type';
}

class Team {
  Team({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.roomId,
    required this.isOwner,
  });

  String id;
  String name;
  int type;
  DateTime createdAt;
  CreatedBy createdBy;
  DateTime updatedAt;
  String roomId;
  bool isOwner;

  factory Team.fromJson(String str) => Team.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Team.fromMap(Map<String, dynamic> json) => Team(
        id: json["_id"],
        name: json["name"],
        type: json["type"],
        createdAt: DateTime.parse(json["createdAt"]),
        createdBy: CreatedBy.fromMap(json["createdBy"]),
        updatedAt: DateTime.parse(json["_updatedAt"]),
        roomId: json["roomId"],
        isOwner: json["isOwner"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "name": name,
        "type": type,
        "createdAt": createdAt.toIso8601String(),
        "createdBy": createdBy.toMap(),
        "_updatedAt": updatedAt.toIso8601String(),
        "roomId": roomId,
        "isOwner": isOwner,
      };
}

class CreatedBy {
  CreatedBy({
    required this.id,
    this.username,
  });

  String id;
  String? username;

  factory CreatedBy.fromJson(String str) => CreatedBy.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CreatedBy.fromMap(Map<String, dynamic> json) => CreatedBy(
        id: json["_id"],
        username: json["username"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "username": username,
      };
}
