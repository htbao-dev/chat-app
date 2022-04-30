import 'dart:async';
import 'dart:convert';

import 'package:chat_app/data/data_providers/api/rocket_server.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Websocket extends RocketServer {
  static final Websocket _instance = Websocket._internal();
  late WebSocketChannel _channel;
  final StreamController _notificationStreamController = StreamController();
  final StreamController _roomChangedStreamController = StreamController();
  final StreamController _roomMessageStreamController = StreamController();
  late Stream _notificationStream;
  late Stream _roomChangedStream;
  late Stream _roomMessageStream;
  Stream get roomChangedStream => _roomChangedStream;
  Stream get notificationStream => _notificationStream;
  Stream get roomMessageStream => _roomMessageStream;
  late Stream _stream;
  factory Websocket() {
    return _instance;
  }

  Websocket._internal() {
    _notificationStream =
        _notificationStreamController.stream.asBroadcastStream();
    _roomChangedStream =
        _roomChangedStreamController.stream.asBroadcastStream();
    _roomMessageStream =
        _roomMessageStreamController.stream.asBroadcastStream();
  }

  void connectServer() {
    _channel = WebSocketChannel.connect(Uri.parse(serverSocketAddr));
    _stream =
        _channel.stream.map((event) => json.decode(event)).asBroadcastStream();
    _stream.listen((event) {
      _mapEvent(event);
    });
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
    } else if (event['collection'] == 'stream-room-messages') {
      _roomMessageStreamController.sink.add(event);
    }
  }

  Stream get stream => _stream;
}
