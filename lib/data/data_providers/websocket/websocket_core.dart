import 'dart:async';
import 'dart:convert';

import 'package:chat_app/data/data_providers/api/rocket_server.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Websocket extends RocketServer {
  static final Websocket _instance = Websocket._internal();
  late WebSocketChannel _channel;
  final StreamController _notificationStreamController =
      StreamController.broadcast();
  final StreamController _roomChangedStreamController =
      StreamController.broadcast();
  final StreamController _subChangedStreamController =
      StreamController.broadcast();
  final StreamController _roomMessageStreamController =
      StreamController.broadcast();
  Stream get roomChangedStream => _roomChangedStreamController.stream;
  Stream get notificationStream => _notificationStreamController.stream;
  Stream get roomMessageStream => _roomMessageStreamController.stream;
  Stream get subChangedStream => _subChangedStreamController.stream;
  late Stream _stream;
  factory Websocket() {
    return _instance;
  }

  Websocket._internal();

  void connectServer() {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(serverSocketAddr));
      _stream = _channel.stream
          .map((event) => json.decode(event))
          .asBroadcastStream();
      _stream.listen((event) {
        _mapEvent(event);
      });
    } catch (e) {
      print(e);
    }
  }

  void close() {
    _channel.sink.close();
  }

  void call(String data) {
    _channel.sink.add(data);
  }

  void _mapEvent(event) {
    if (event['collection'] == 'stream-notify-user' &&
        // event['fields']['eventName'].toString().contains('rooms-changed')
        event['fields']['eventName'].toString().contains('notification')) {
      _notificationStreamController.sink.add(event);
    } else if (event['collection'] == 'stream-notify-user' &&
        event['fields']['eventName'].toString().contains('rooms-changed')) {
      _roomChangedStreamController.sink.add(event);
    } else if (event['collection'] == 'stream-notify-user' &&
        event['fields']['eventName']
            .toString()
            .contains('subscriptions-changed')) {
      _subChangedStreamController.sink.add(event);
    } else if (event['collection'] == 'stream-room-messages') {
      _roomMessageStreamController.sink.add(event);
    }
  }

  Stream get stream => _stream;
}
