import 'package:chat_app/constants/enums.dart';
import 'package:chat_app/data/data_providers/websocket/websocket_core.dart';
import 'package:chat_app/utils/static_data.dart';

class ChatSocket {
  final _coreSocket = Websocket();

  Stream get roomMessageStream => _coreSocket.roomMessageStream;

  int subStreamRoomMessage(String roomId) {
    final int id = StaticData.idRandom;

    if (StaticData.internetStatus == InternetStatus.connected) {
      _coreSocket.call(
          '{"msg":"sub","id":"$id","name":"stream-room-messages","params":["$roomId",{"useCollection":false,"args":[]}]}');
    }

    return id;
  }

  void unsubStreamRoomMessage(int id) {
    if (StaticData.internetStatus == InternetStatus.connected) {
      _coreSocket.call('{"msg":"unsub","id":"$id"}');
    }
  }
}
