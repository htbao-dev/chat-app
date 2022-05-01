import 'dart:convert';
import 'dart:io';

import 'package:chat_app/constants/exceptions.dart';
import 'package:chat_app/data/data_providers/api/message_provider.dart';
import 'package:chat_app/data/data_providers/api/rocket_server.dart';
import 'package:chat_app/data/models/auth.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

class RocketMessageProvider extends RocketServer implements MessageProvider {
  final String _loadHistoryUrl = 'api/v1/method.call/loadHistory/';
  final String _sendMessageUrl = 'api/v1/method.call/sendMessage/';

  String _sendFilesMessageUrl(String roomId) {
    return '/api/v1/rooms.upload/$roomId';
  }

  @override
  Future<String> loadHistory(Auth auth, String roomId,
      [DateTime? from, int quantity = 50]) async {
    from ??= DateTime.now();
    try {
      String messageBody = '{"msg":"method","method":"loadHistory","params":'
          '["$roomId",null,$quantity,{"\$date":${from.millisecondsSinceEpoch}},false]}';
      final response = await http.post(Uri.parse('$serverAddr$_loadHistoryUrl'),
          headers: {
            keyHeaderToken: auth.token,
            keyHeaderUserId: auth.userId,
          },
          body: {'message': messageBody},
          encoding: Encoding.getByName('csutf8'));
      if (response.statusCode == 200) {
        var decoded = const Utf8Decoder().convert(response.bodyBytes);
        return decoded;
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.body,
        );
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<String> sendMessage(Auth auth,
      {required String roomId, required String msg}) async {
    try {
      final response = await http.post(
        Uri.parse('$serverAddr$_sendMessageUrl'),
        headers: {
          keyHeaderToken: auth.token,
          keyHeaderUserId: auth.userId,
        },
        body: {
          "message":
              '{"msg":"method","id":"${StaticData.idRandom}","method":"sendMessage","params":[{"rid":"$roomId","msg":"$msg"}]}'
        },
      );
      if (response.statusCode == 200) {
        var decoded = const Utf8Decoder().convert(response.bodyBytes);
        return decoded;
      } else {
        throw ServerException(
          statusCode: response.statusCode,
          message: response.body,
        );
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<String> sendFilesMessage(
    Auth auth, {
    required String roomId,
    required String msg,
    required File file,
  }) async {
    try {
      String url = serverAddr + _sendFilesMessageUrl(roomId);
      final uri = Uri.parse(url);
      final request = http.MultipartRequest(
        'POST',
        uri,
      );
      request.headers.addAll({
        keyHeaderToken: auth.token,
        keyHeaderUserId: auth.userId,
        'Content-Type': 'multipart/form-data',
      });
      request.fields.addAll({
        'msg': msg,
      });
      final subType = _getSubtype(file.path);
      final type = _getType(subType);
      final multipartFile = await http.MultipartFile.fromPath(
        'file',
        file.path,
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

  String _getType(String subType) {
    if (subType.contains('jpeg')) {
      return 'image';
    }
    if (subType.contains('png')) {
      return 'image';
    }
    if (subType.contains('gif')) {
      return 'image';
    }
    if (subType.contains('mp4')) {
      return 'video';
    }
    if (subType.contains('mp3')) {
      return 'audio';
    }
    return 'file';
  }

  String _getSubtype(String path) {
    return path.split('.').last;
  }
}