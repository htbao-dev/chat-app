import 'package:chat_app/data/models/user.dart';

abstract class UserLocalStorage {
  Future<User> getUser(String userId);
  Future<User> getUsersOfRoom(String roomId);
  // Future<void> saveUser(User user);
  Future<void> saveUsers(List<User> user);

  Future<List<User>> getUsersInRoom(String roomId);
  // Future<void> clearUser();
}
