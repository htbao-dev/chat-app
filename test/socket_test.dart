import 'package:chat_app/data/models/auth.dart';
import 'package:chat_app/data/repositories/message_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('message socket', () {
    // SocketAuth socketAuth = SocketAuth();
    Auth auth = Auth(
        userId: 'gRvhHvNbXS47YSs8Q',
        token: 'lapZ4Ijg-ymQrrPYuKKGdFd1N7kqmv9FVkj-62nyWqU');
    // socketAuth.init();
    // socketAuth.connect(auth);
    // socketAuth.subcrNotifyUserMessage(auth);
    MessageRepository messageRepository = MessageRepository();
    test('test send mess', () async {
      var res = await messageRepository.sendMessage(auth,
          roomId: 'pnh2eLEzPB5MvD2o6', msg: 'test');
      expect(res, isNotNull);
    });
  });
}
