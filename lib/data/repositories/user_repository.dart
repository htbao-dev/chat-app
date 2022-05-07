import 'dart:convert';

import 'package:chat_app/data/data_providers/api/rocket_user_provider.dart';
import 'package:chat_app/data/data_providers/api/user_provider.dart';
import 'package:chat_app/data/models/auth.dart';
import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:flutter/widgets.dart';

class UserRepository {
  final UserProvider _userProvider = RocketUserProvider();

  Future<User?> getUserInfo({required Auth auth}) async {
    try {
      final response = await _userProvider.getUserInfo(auth: auth);
      final user = User.fromMap(json.decode(response));
      return user;
    } catch (e, s) {
      print(e);
      print(s);
      return null;
    }
  }

  Future<User?> updateUserInfo(
      {String? name, String? email, String? password, String? username}) async {
    try {
      final auth = StaticData.auth!;
      final response = await _userProvider.updateUserInfo(
        auth: auth,
        name: name,
        email: email,
        password: password,
        username: username,
      );
      final user = User.fromMap(json.decode(response));
      return user;
    } catch (e, s) {
      print(e);
      print(s);
      return null;
    }
  }

  Future<List<User>> getUsers({String selector = ''}) async {
    try {
      final auth = StaticData.auth!;
      final rawData =
          await _userProvider.getUsers(auth: auth, selector: selector);
      var decodeData = jsonDecode(rawData);
      if (decodeData['success'] == true) {
        final users = usersFromMap(decodeData['items']);
        return users;
      }
      return [];
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
}
