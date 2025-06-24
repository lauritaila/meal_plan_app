import '../domain.dart';

abstract class AuthDatasource {
  Future<bool> isAuthenticated();
  Future<User> logIn(String email, String password);
  Future<User> signUp(String email, String password);
  Future<void> logOut();
  Future<User> resetPassword(String email);
}