import 'dart:convert';
import 'package:chat_app/constants/enums.dart';
import 'package:chat_app/constants/exceptions.dart';
import 'package:chat_app/constants/values.dart';
import 'package:chat_app/data/data_providers/api/auth_provider.dart';
import 'package:chat_app/data/data_providers/api/rocket_auth_provider.dart';
import 'package:chat_app/data/data_providers/local_storage/auth_localstorage.dart';
import 'package:chat_app/data/data_providers/local_storage/auth_sqlilte.dart';
import 'package:chat_app/data/models/auth.dart';
import 'package:chat_app/data/models/user.dart';

import 'package:chat_app/utils/static_data.dart';

class AuthRepository {
  final AuthLocalStorage _authLocalStorage = AuthSqlite();
  final AuthProvider _authProvider = RocketAuthProvider();
  Future<Auth> loginWithUsernameAndPassword(
      String username, String password) async {
    try {
      String rawData =
          await _authProvider.loginWithUsernameAndPassword(username, password);
      Map<String, dynamic> decodeData = jsonDecode(rawData);
      // Map<String, dynamic> json = decodeData['data']['me'];
      Auth auth = Auth(
          token: decodeData['data']['authToken'],
          userId: decodeData['data']['userId']);
      await _authLocalStorage.saveAuth(auth);
      return auth;
    } catch (_) {
      rethrow;
    }
  }

  Future<User> registerWithUsernameAndPassword(
      String username, String name, String email, String password) async {
    try {
      String rawData = await _authProvider.registerWithUsernameAndPassword(
          username, name, email, password);
      Map<String, dynamic> decodeData = jsonDecode(rawData);
      return User.fromMap(decodeData['user']);
    } on ServerException catch (e) {
      var decodeData = jsonDecode(e.message);
      e.message = decodeData['errorType'] ?? RegisterStatus.usernameExists;
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  Future<Auth?> checkAuth() async {
    final _auth = await _authLocalStorage.getAuth();
    if (_auth == null) {
      return null;
    } else {
      if (StaticData.internetStatus == InternetStatus.disconnected) {
        return _auth;
      }
      try {
        final rawData = await _authProvider.checkAuth(_auth.token);
        Map<String, dynamic> decodeData = jsonDecode(rawData);
        Auth auth = Auth(
            token: decodeData['data']['authToken'],
            userId: decodeData['data']['userId']);
        await _authLocalStorage.saveAuth(auth);
        return auth;
      } on ServerException catch (e) {
        if (e.statusCode == RequestStatusCode.unauthorized) {
          await _authLocalStorage.clearAuth();
          return null;
        }
        rethrow;
      } catch (_) {
        rethrow;
      }
    }
  }

  Future<void> logout() async {
    final _auth = await _authLocalStorage.getAuth();
    if (_auth == null) {
      return;
    } else {
      try {
        await _authLocalStorage.clearAuth();
        if (StaticData.internetStatus == InternetStatus.connected) {
          await _authProvider.logout(_auth.token, _auth.userId);
        }
      } on ServerException catch (e) {
        if (e.statusCode == RequestStatusCode.unauthorized) {
          await _authLocalStorage.clearAuth();
          return;
        }
        rethrow;
      } catch (_) {
        rethrow;
      }
    }
  }
}
