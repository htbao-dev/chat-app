import 'package:http/http.dart' as http;

import 'package:chat_app/data/data_providers/api/rocket_server.dart';
import 'package:chat_app/data/data_providers/api/user_provider.dart';
import 'package:chat_app/data/models/auth.dart';

class RocketUserProvider extends RocketServer implements UserProvider {
  final String _getUsersRoute = '/api/v1/users.autocomplete';
  final String _getUserInfoRoute = '/api/v1/me';
  final String _updateUserInfoRoute = '/api/v1/users.update';

  @override
  Future<String> getUsers(
      {required Auth auth, required String selector}) async {
    try {
      final response = await http.get(
        Uri.parse('$serverAddr$_getUsersRoute?selector={"term": "$selector"}'),
        headers: {
          keyHeaderToken: auth.token,
          keyHeaderUserId: auth.userId,
        },
      );
      return response.body;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> getUserInfo({required Auth auth}) async {
    try {
      final response = await http.get(
        Uri.parse('$serverAddr$_getUserInfoRoute'),
        headers: {
          keyHeaderToken: auth.token,
          keyHeaderUserId: auth.userId,
        },
      );
      return response.body;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> updateUserInfo(
      {required Auth auth,
      String? name,
      String? email,
      String? password,
      String? username}) async {
    try {
      final response = await http.post(
        Uri.parse('$serverAddr$_updateUserInfoRoute'),
        headers: {
          keyHeaderToken: auth.token,
          keyHeaderUserId: auth.userId,
          'Content-Type': 'application/json',
        },
        body: {
          'userId': auth.userId,
          'data': {
            if (name != null) 'name': name,
            if (email != null) 'email': email,
            if (password != null) 'password': password,
            if (username != null) 'username': username,
          }
        },
      );
      return response.body;
    } catch (e) {
      rethrow;
    }
  }
}
