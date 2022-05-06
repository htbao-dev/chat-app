const String tableUser = 'user';

List<Email>? emailsFromMap(List<dynamic>? json) {
  if (json == null) {
    return null;
  }
  return json.map((e) => Email.fromMap(e)).toList();
}

List<String>? rolesFromMap(List<dynamic>? json) {
  if (json == null) {
    return null;
  }
  return json.map((e) => e.toString()).toList();
}

List<User> usersFromMap(List<dynamic>? json) {
  if (json == null) {
    return [];
  }
  return json.map((e) => User.fromMap(e)).toList();
}

class UserFields {
  static const String id = '_id';
  static const String name = 'name';
  static const String email = 'email';
  static const String password = 'password';
  static const String avatar = 'avatar';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
}

class User {
  User({
    required this.id,
    this.name,
    this.emails,
    this.status,
    this.statusConnection,
    required this.username,
    this.utcOffset,
    this.active,
    this.roles,
    this.settings,
    this.avatarUrl,
  });

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      emails: emailsFromMap(json['emails']),
      status: json['status'],
      statusConnection: json['statusConnection'],
      username: json['username'],
      utcOffset: json['utcOffset'],
      active: json['active'],
      roles: (rolesFromMap(json['roles'])),
      settings:
          json['settings'] != null ? Settings.fromMap(json['settings']) : null,
      avatarUrl:
          json['avatarUrl'] != null ? json['avatarUrl'] + '?format=png' : null,
    );
  }

  String id;
  String? name;
  List<Email>? emails;
  String? status;
  String? statusConnection;
  String username;
  int? utcOffset;
  bool? active;
  List<String>? roles;
  Settings? settings;
  String? avatarUrl;
}

class Email {
  Email({
    required this.address,
    required this.verified,
  });

  Email.fromMap(Map<String, dynamic> json)
      : this(
          address: json['address'] as String,
          verified: json['verified'] as bool,
        );

  String address;
  bool verified;
}

class Settings {
  Settings({
    required this.preferences,
  });

  Settings.fromMap(Map<String, dynamic> json)
      : this(
          preferences: Preferences.fromMap(json['preferences']),
        );

  Preferences preferences;
}

class Preferences {
  Preferences();

  factory Preferences.fromMap(Map<String, dynamic> json) => Preferences();
}
