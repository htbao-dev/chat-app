abstract class RocketServer {
  static const String _addr = '192.168.1.13:3000';
  // static const String _addr = '103.92.29.62:3000';
  final String keyHeaderToken = 'X-Auth-Token';
  final String keyHeaderUserId = 'X-User-Id';
  late final String serverAddr = 'http://$_addr/';
  late final String serverSocketAddr = 'ws://$_addr/websocket';

  static String getServerAdd() {
    return 'http://$_addr';
  }
}
