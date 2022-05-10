import 'package:chat_app/utils/strings.dart';

const String tableUser = 'user';

List<Email>? emailsFromMap(List<dynamic>? json) {
  if (json == null) {
    return null;
  }
  return json.map((e) => Email.fromMap(e)).toList();
}

List<User> usersFromMap(List<dynamic>? json,
    [User Function(Map<String, dynamic>)? parser]) {
  parser ??= User.fromMap;
  if (json == null) {
    return [];
  }
  return json.map((e) => parser!(e)).toList();
}

class UserFields {
  static const String id = '_id';
  static const String name = 'name';
  static const String email = 'email';
  static const String username = 'username';
  static const String avatarUrl = 'avatarUrl';
}

class User {
  User({
    required this.id,
    this.name,
    this.emails,
    required this.username,
    this.avatarUrl,
  });

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      emails: emailsFromMap(json['emails']),
      username: json['username'],
      avatarUrl: json['avatarUrl'] != null
          ? json['avatarUrl'] + '?format=png'
          : getAvatarUrl(param: json['username'], isRoomOrTeam: false),
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map[UserFields.id] = id;
    map[UserFields.name] = name;
    map[UserFields.email] = emails?.first.address;
    map[UserFields.username] = username;
    map[UserFields.avatarUrl] = avatarUrl;
    return map;
  }

  String id;
  String? name;
  List<Email>? emails;
  String username;
  String? avatarUrl;
}

class Email {
  Email({
    required this.address,
    this.verified,
  });

  Email.fromMap(Map<String, dynamic> json)
      : this(
          address: json['address'] as String,
          verified: json['verified'] as bool?,
        );

  String address;
  bool? verified;
}
