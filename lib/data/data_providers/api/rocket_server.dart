abstract class RocketServer {
  // static const String _addr = '192.168.1.13:3000';
  static const String _addr = 'husc1.rocket.chat';
  // static const String _addr = '51.81.11.137:3000';
  final String keyHeaderToken = 'X-Auth-Token';
  final String keyHeaderUserId = 'X-User-Id';
  late final String serverAddr = 'https://$_addr/';
  // late final String serverAddr = 'http://$_addr/';
  late final String serverSocketAddr = 'ws://$_addr/websocket';

  static String getServerAdd() {
    return 'http://$_addr';
  }
}
