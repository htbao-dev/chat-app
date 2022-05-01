import 'package:chat_app/data/data_providers/websocket/websocket_core.dart';
import 'package:chat_app/data/models/auth.dart';
import 'package:chat_app/utils/static_data.dart';

class AuthSocket {
  final _coreSocket = Websocket();
  void connect(Auth auth) {
    _coreSocket.call(
        '{"msg": "connect", "version": "1", "support": ["1", "pre2", "pre1"]}');
    _resume(auth);
  }

  void _resume(Auth auth) {
    _coreSocket.call(
        '{"msg": "method","method": "login","id": "${StaticData.idRandom}","params":[{ "resume": "${auth.token}" }]}');
    // _coreSocket.call(
    //     "{\"msg\":\"method\",\"id\":\"1\",\"method\":\"login\",\"params\":[{\"resume\":\"aIkEfKZELB3qb5dl-lRo8kTCFkhJ1hC6LhUVJyhWiKE\"}]}");
  }

  void subcrNotifyUserMessage(Auth auth) {
    // //message event
    // _coreSocket.call(
    //     '{"msg":"sub","id":"${StaticData.idRandom}","name":"stream-notify-user","params":["${auth.userId}/message",{"useCollection":false,"args":[]}]}');
    // //subscriptions-changed
    _coreSocket.call(
        '{"msg":"sub","id":"${StaticData.idRandom}","name":"stream-notify-user","params":["${auth.userId}/subscriptions-changed",{"useCollection":false,"args":[]}]}');

    //notification
    _coreSocket.call(
        '{"msg":"sub","id":"${StaticData.idRandom}","name":"stream-notify-user","params":["${auth.userId}/notification",{"useCollection":false,"args":[]}]}');
    _coreSocket.call(
        '{"msg":"sub","id":"${StaticData.idRandom}","name":"stream-notify-user","params":["${auth.userId}/rooms-changed",{"useCollection":false,"args":[]}]}');
  }

  void logout() {
    _coreSocket.call(
        '{"msg":"method","id":"${StaticData.idRandom}","method":"logout","params":[]}');
  }
}
