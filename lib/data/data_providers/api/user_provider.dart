import 'dart:io';

import 'package:chat_app/data/models/auth.dart';

abstract class UserProvider {
  Future<String> getUsers({required Auth auth, required String selector});

  Future<String> getUserInfo({required Auth auth});
  Future<String> updateUserInfo(
      {required Auth auth,
      String? name,
      String? email,
      String? password,
      String? username});
  Future<String> setAvatar({required Auth auth, required File image});
}
