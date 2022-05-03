abstract class RocketServer {
  static const String _addr = '192.168.1.157:3000';
  // static const String _addr = '54.254.144.57:3000';
  final String keyHeaderToken = 'X-Auth-Token';
  final String keyHeaderUserId = 'X-User-Id';
  late final String serverAddr = 'http://$_addr/';
  late final String serverSocketAddr = 'ws://$_addr/websocket';

  static String getServerAdd() {
    return 'http://$_addr';
  }
}
