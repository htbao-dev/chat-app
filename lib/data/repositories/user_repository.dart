import 'dart:convert';

import 'package:chat_app/data/data_providers/api/rocket_user_provider.dart';
import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:flutter/widgets.dart';

class UserRepository {
  final RocketUserProvider _userProvider = RocketUserProvider();
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
