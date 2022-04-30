import 'package:chat_app/data/models/auth.dart';

abstract class AuthLocalStorage {
  Future<Auth?> getAuth();
  Future<void> saveAuth(Auth auth);
  Future<void> clearAuth();
}
