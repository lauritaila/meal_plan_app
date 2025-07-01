import '../domain.dart';

abstract class AuthRepository {
  Future<bool> isAuthenticated();
  Future<UserProfile> logIn(String email, String password);
  Future<UserProfile> signUp(String email, String password);
  Future<void> logOut();
  Future<UserProfile> resetPassword(String email);
  Future<bool> resendVerificationEmail(String email);
  Future<UserProfile> getAuthenticatedUserProfile();
}