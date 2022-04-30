abstract class AuthProvider {
  Future<String> loginWithUsernameAndPassword(String email, String password);
  Future<String> registerWithUsernameAndPassword(
      String username, String password, String name, String email);
  Future<void> logout(String token, String userId);
  Future<String> checkAuth(String token);
}
