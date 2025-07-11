import 'package:meal_plan_app/config/config.dart';

import '../../domain/domain.dart';

class AuthRepositoryImpl implements AuthRepository {

  final AuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);
  
  @override
  Future<bool> isAuthenticated() {
    return datasource.isAuthenticated();
  }
  
  @override
  Future<UserProfile> logIn(String email, String password) {
    return datasource.logIn(email, password);
  }
  
  @override
  Future<void> logOut() {
    return datasource.logOut();
  }
  
  @override
  Future<void> signUp(String email, String password, String name) {
    return datasource.signUp(email, password, name);
  }

  @override
  Future<UserProfile> getAuthenticatedUserProfile() async {
    final isAuthenticated = await datasource.isAuthenticated();
    if (isAuthenticated) {
      try {
        return await datasource.getAuthenticatedUserProfile();
      } catch (e) {
        await datasource.logOut(); 
        throw AuthAppError('Failed to check auth status: ${e.toString()}');
      }
    }
    throw Exception('No authenticated');
  }
  
  @override
  Future<void> saveUserPreference(UserPreferences userPreference, String userId) {
    return datasource.saveUserPreference(userPreference, userId);
  }

  @override
  Future<void> signInWithOtp(String email) {
    return datasource.signInWithOtp(email);
  }

  @override
  Future<UserProfile> verifyOtp(String email, String token) {
    return datasource.verifyOtp(email, token);
  }
  
  @override
  Future<bool> userExists(String email) {
    return datasource.userExists(email);
  }

}
  

