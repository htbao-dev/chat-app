import 'dart:io';

import 'package:chat_app/constants/exceptions.dart';
import 'package:chat_app/utils/formatter.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:chat_app/data/data_providers/api/rocket_server.dart';
import 'package:chat_app/data/data_providers/api/user_provider.dart';
import 'package:chat_app/data/models/auth.dart';

class RocketUserProvider extends RocketServer implements UserProvider {
  final String _getUsersRoute = '/api/v1/users.autocomplete';
  final String _getUserInfoRoute = '/api/v1/me';
  final String _updateUserInfoRoute = 'api/v1/method.call/saveUserProfile';
  final String _setAvatarRoute = '/api/v1/users.setAvatar';

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
      final response = await http
          .post(Uri.parse('$serverAddr$_updateUserInfoRoute'), headers: {
        keyHeaderToken: auth.token,
        keyHeaderUserId: auth.userId,
      }, body: {
        'message':
            '{"msg":"method","id":"${StaticData.idRandom}","method":"saveUserProfile","params":[{"realname":"${name ?? ""}","newPassword":"${password ?? ""}","username":"${username ?? ""}","statusText":"","statusType":"online","nickname":"","bio":""},{}]}'
      });
      return response.body;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> setAvatar({
    required Auth auth,
    required File image,
  }) async {
    try {
      String url = serverAddr + _setAvatarRoute;
      final uri = Uri.parse(url);
      final request = http.MultipartRequest(
        'POST',
        uri,
      );
      request.headers.addAll({
        keyHeaderToken: auth.token,
        keyHeaderUserId: auth.userId,
        // 'Content-Type': 'multipart/form-data',
      });
      final subType = getSubtype(image.path);
      final type = getType(subType);

      final multipartFile = await http.MultipartFile.fromPath(
        'image',
        image.path,
        filename: image.path,
        contentType: MediaType(type, subType),
      );
      request.files.add(multipartFile);
      final response = await request.send();

      final respStr = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return respStr;
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: respStr,
        );
      }
    } catch (_) {
      rethrow;
    }
  }
}
