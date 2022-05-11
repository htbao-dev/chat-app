const String tableRoom = 'room';

List<Room> roomsFromMap(List<dynamic> map) {
  return map.map((e) => Room.fromJson(e)).toList();
}

class RoomFields {
  static const String id = '_id';
  static const String name = 'name';
  static const String type = 't';
  static const String teamId = 'teamId';
  static const String description = 'description';
}

class Room {
  static const String publicRoom = 'c';
  static const String privateRoom = 'p';
  String id;
  String name;
  String description;
  String type;
  String teamId;

  Room(
      {required this.id,
      required this.name,
      required this.description,
      required this.type,
      required this.teamId});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      type: json['t'],
      teamId: json['teamId'],
    );
  }
}
