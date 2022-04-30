import 'package:chat_app/data/data_providers/api/rocket_message_provider.dart';
import 'package:chat_app/data/models/auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MessageProvider', () {
    test('loadHistory', () async {
      final auth = Auth(
        token: 'R9aqBFo9Xy4u_Zyk7gRHmt93xtb5oQhZllAsu33LggS',
        userId: 'gRvhHvNbXS47YSs8Q',
      );
      const roomId = 'pAEcfMqzuxAoNiXdd';
      final messageProvider = RocketMessageProvider();
      expect(await messageProvider.loadHistory(auth, roomId), '');
    }, timeout: const Timeout(Duration(seconds: 5)));
  });
}
