import 'package:chat_app/data/data_providers/websocket/websocket_core.dart';
import 'package:flutter/material.dart';

class AppSocket {
  final _coreSocket = Websocket();
  void init() {
    _coreSocket.connectServer();
    _pong();
  }

  void _pong() {
    _coreSocket.stream.listen((event) {
      // print(event);
      if (event['msg'] == 'ping') {
        debugPrint('ping');
        _coreSocket.call('{"msg":"pong"}');
      }
    });
  }

  Stream get notificationStream => _coreSocket.notificationStream;
}
