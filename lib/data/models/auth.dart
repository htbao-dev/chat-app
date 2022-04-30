const String tableAuth = 'auth';

class AuthFields {
  static const String token = "token";
  static const String userId = "userId";
}

class Auth {
  final String token;
  final String userId;

  Auth({required this.token, required this.userId});
}
