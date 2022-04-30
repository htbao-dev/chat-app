import 'package:chat_app/data/models/auth.dart';

abstract class UserProvider {
  Future<String> getUsers({required Auth auth, required String selector});
}
