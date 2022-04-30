import 'package:chat_app/data/models/auth.dart';
import 'package:chat_app/data/repositories/team_repository.dart';
import 'package:chat_app/data/repositories/user_repository.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(
    () {},
  );
  group('team repo', () {
    test('test create team', () async {
      StaticData.auth = Auth(
        token: 'kaS0Fhrtych2qAYyKgipqN-LXvjweqB-D-pNs5mG7XG',
        userId: 'jcrGSB67R2Dg258rn',
      );
      TeamRepository teamRepo = TeamRepository();
      expect(await teamRepo.createTeam(name: 'Bao'),
          CreateTeamStatus.duplicateName);
    });

    test('test invite', () async {
      StaticData.auth = Auth(
        token: 'kaS0Fhrtych2qAYyKgipqN-LXvjweqB-D-pNs5mG7XG',
        userId: 'jcrGSB67R2Dg258rn',
      );
      // TeamRepository teamRepo = TeamRepository();
    });
  });

  group('user repo', () {
    test('get users', () async {
      StaticData.auth = Auth(
        token: 'kaS0Fhrtych2qAYyKgipqN-LXvjweqB-D-pNs5mG7XG',
        userId: 'jcrGSB67R2Dg258rn',
      );
      UserRepository userRepo = UserRepository();
      final users = await userRepo.getUsers();
      expect(users, isNotEmpty);
    });
  });
}
