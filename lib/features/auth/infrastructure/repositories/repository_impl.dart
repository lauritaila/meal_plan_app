import 'package:meal_plan_app/config/errors/app_errors.dart';

import '../../domain/domain.dart';

class AuthRepositoryImpl implements AuthRepository {

  final AuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);
  
  @override
  Future<bool> isAuthenticated() {
    return datasource.isAuthenticated();
  }
  
  @override
  Future<UserProfile> resetPassword(String email) {
    return datasource.resetPassword(email);
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
  Future<UserProfile> signUp(String email, String password, String name) {
    return datasource.signUp(email, password, name);
  }

  @override
  Future<bool> resendVerificationEmail(String email) {
    return datasource.resendVerificationEmail(email);
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

}
  

