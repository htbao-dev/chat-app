import 'package:http/http.dart' as http;

import 'package:chat_app/data/data_providers/api/rocket_server.dart';
import 'package:chat_app/data/data_providers/api/user_provider.dart';
import 'package:chat_app/data/models/auth.dart';

class RocketUserProvider extends RocketServer implements UserProvider {
  final String _getUsersRoute = '/api/v1/users.autocomplete';

  @override
  Future<String> getUsers(
      {required Auth auth, required String selector}) async {
    try {
      final response = await http.get(
        Uri.parse('$serverAddr$_getUsersRoute?selector={"term": "$selector"}'),
        headers: {
          keyHeaderToken: auth.token,
          keyHeaderUserId: auth.userId,
        },
      );
      return response.body;
    } catch (e) {
      rethrow;
    }
  }
}
