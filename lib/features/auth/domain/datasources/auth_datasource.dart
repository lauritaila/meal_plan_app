import '../domain.dart';

abstract class AuthDatasource {
  Future<bool> isAuthenticated();
  Future<UserProfile> logIn(String email, String password);
  Future<UserProfile> signUp(String email, String password, String name);
  Future<void> logOut();
  Future<bool> resendVerificationEmail(String email);
  Future<UserProfile> getAuthenticatedUserProfile();
  Future<void> signInWithOtp(String email);
  Future<UserProfile> verifyOtp(String email, String token);
  Future<void> saveUserPreference(UserPreferences userPreference, String userId);
}