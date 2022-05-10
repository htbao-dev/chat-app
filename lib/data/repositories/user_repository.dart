import 'dart:convert';
import 'dart:io';

import 'package:chat_app/data/data_providers/api/rocket_user_provider.dart';
import 'package:chat_app/data/data_providers/api/user_provider.dart';
import 'package:chat_app/data/data_providers/local_storage/user_localstorage.dart';
import 'package:chat_app/data/data_providers/local_storage/user_sqlite.dart';
import 'package:chat_app/data/models/auth.dart';
import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:flutter/widgets.dart';

class UserRepository {
  final UserProvider _userProvider = RocketUserProvider();
  final UserLocalStorage _userLocalStorage = UserSqlite();

  Future<bool> setAvatar(File image) async {
    final auth = StaticData.auth!;
    try {
      final rawData = await _userProvider.setAvatar(auth: auth, image: image);
      final json = jsonDecode(rawData);
      return json['success'];
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      return false;
    }
  }

  Future<User?> getUserInfo({required Auth auth}) async {
    try {
      final response = await _userProvider.getUserInfo(auth: auth);
      final user = User.fromMap(json.decode(response));
      return user;
    } catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);
      return null;
    }
  }

  Future<bool> updateUserInfo(
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
      final decodeData = json.decode(response);
      final data = jsonDecode(decodeData['message']);
      final success =
          (decodeData['success'] == true) && (data['error'] == null);

      return success;
    } catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);

      return false;
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

  Future<void> loadUsers() async {
    try {
      final auth = StaticData.auth!;
      final rawData = await _userProvider.getUsers(auth: auth, selector: '');
      var decodeData = jsonDecode(rawData);
      if (decodeData['success'] == true) {
        final users = usersFromMap(decodeData['items']);
        await _userLocalStorage.saveUsers(users);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
