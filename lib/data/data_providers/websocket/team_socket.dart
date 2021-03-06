import 'package:chat_app/data/data_providers/websocket/websocket_core.dart';

class TeamSocket {
  final _coreSocket = Websocket();

  Stream get subChangedStream => _coreSocket.subChangedStream;
  Stream get roomChangedStream => _coreSocket.roomChangedStream;
}
