import 'dart:async';

import 'package:chat_app/constants/exceptions.dart';
import 'package:chat_app/data/data_providers/api/auth_provider.dart';
import 'package:chat_app/data/data_providers/api/rocket_server.dart';
import 'package:http/http.dart' as http;

class RocketAuthProvider extends RocketServer implements AuthProvider {
  final _loginRoute = '/api/v1/login';
  final _registerRoute = '/api/v1/users.register';
  final _logoutRoute = '/api/v1/logout';

  @override
  Future<String> loginWithUsernameAndPassword(
      String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$serverAddr$_loginRoute'),
        headers: {
          // 'Content-Type': 'application/json',
        },
        body: {
          'user': username,
          'password': password,
        },
      ).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.body,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout(String token, String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$serverAddr$_logoutRoute'),
        headers: {
          keyHeaderToken: token,
          keyHeaderUserId: userId,
        },
      );
      if (response.statusCode == 200) {
        return;
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.body,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> registerWithUsernameAndPassword(
      String username, String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$serverAddr$_registerRoute'),
        headers: {
          // 'Content-Type': 'application/json',
        },
        body: {
          'username': username,
          'name': name,
          'email': email,
          'pass': password,
        },
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.body,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> checkAuth(String token) async {
    try {
      var response =
          await http.post(Uri.parse('$serverAddr$_loginRoute'), body: {
        'resume': token,
      });
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.body,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
