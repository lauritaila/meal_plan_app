import 'package:meal_plan_app/config/errors/app_errors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/domain.dart';
import '../infrastructure.dart';

class SupabaseDatasourceImpl implements AuthDatasource {
   final SupabaseClient _supabaseClient;

  SupabaseDatasourceImpl(this._supabaseClient);

  @override
  Future<bool> isAuthenticated() async {
    final session = _supabaseClient.auth.currentSession;
    return session != null && session.accessToken.isNotEmpty;
  }

  @override
  Future<UserProfile> logIn(String email, String password) async {
    try {
      final AuthResponse res = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final User? supabaseAuthUser = res.user;
      if (supabaseAuthUser == null) {
        throw AuthAppError('Login failed: Could not get user from Supabase.');
      }
      return _loadUserProfile(supabaseAuthUser.id, supabaseAuthUser.email);
    } on AuthException catch (e) {
      if (e.statusCode == '400' && e.message.contains('Invalid login credentials')) {
        throw const AuthAppError.invalidCredentials();
      }
      if (e.message.contains('Email not confirmed')) { 
        throw const AuthAppError.emailNotVerified();
      }
      if (e.message.contains('User not found')) {
        throw const AuthAppError.userNotFound();
      }
      throw AuthAppError(e.message, code: e.statusCode); 
    } on PostgrestException catch (e) { 
      throw DataAppError(e.message, code: e.code);
    } catch (e) {
      throw NetworkAppError('Network or unexpected error: ${e.toString()}'); // Usamos NetworkAppError
    }
  }

  @override
  Future<UserProfile> signUp(String email, String password) async {
    try {
      final AuthResponse res = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      final User? supabaseAuthUser = res.user;
      if (supabaseAuthUser == null) {
        throw AuthAppError('Sign up failed: Could not get user from Supabase.');
      }
      await _supabaseClient.from('user_profiles').insert({
        'id': supabaseAuthUser.id, 
        'name': null, 
        'profile_data': {}, 
      });

      final freePlan = await _supabaseClient
          .from('subscription_plans')
          .select('id')
          .eq('name', 'Free')
          .single();


      await _supabaseClient.from('user_subscriptions').insert({
        'user_id': supabaseAuthUser.id,
        'plan_id': freePlan['id'],
        'status': 'active',
      });

      return _loadUserProfile(supabaseAuthUser.id, supabaseAuthUser.email);
    } on AuthException catch (e) {
      if (e.statusCode == '400' && e.message.contains('User already registered')) {
        throw const AuthAppError.emailAlreadyInUse();
      }
      throw AuthAppError(e.message, code: e.statusCode);
    } on PostgrestException catch (e) {
      throw DataAppError(e.message, code: e.code);
    } catch (e) {
      throw NetworkAppError('Network or unexpected error during sign up: ${e.toString()}');
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await _supabaseClient.auth.signOut();
} on AuthException catch (e) {
      throw AuthAppError(e.message, code: e.statusCode);
    } catch (e) {
      throw AuthAppError('Unexpected error during logout: ${e.toString()}'); 
    }
  }

  @override
  Future<UserProfile> resetPassword(String email) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(
        email,
        redirectTo: '/',  //TODO: configure deeplink here
      );

      return UserProfile(id: "", email: email);
} on AuthException catch (e) {
      throw AuthAppError(e.message, code: e.statusCode);
    } catch (e) {
      throw AuthAppError.passwordResetFailed(); // Más específico aquí
    }
  }

  @override
  Future<bool> resendVerificationEmail(String email) async {
    try {
      await _supabaseClient.auth.resend(
          type: OtpType.signup,
          email: email,
      );

      return true;
    } on AuthException catch (e) {
      throw AuthAppError(e.message, code: e.statusCode);
    } catch (e) {
      throw AuthAppError.resendVerificationFailed(); // Más específico aquí
    }
  }


  Future<UserProfile> _loadUserProfile(String userId, String? email) async {
    if (email == null) {
      throw Exception('User email is null. Cannot load profile.');
    }
    try {
      final response = await _supabaseClient
          .from('user_profiles')
          .select()
          .eq('id', userId)
          .single();

    return UserMapper.fromJson({...response, 'email': email});
 } on PostgrestException catch (e) { // Captura errores de la base de datos Supabase
      throw DataAppError(e.message, code: e.code);
    } catch (e) {
      throw AuthAppError('An unexpected error occurred while loading profile: ${e.toString()}');
    }
  }

    @override
  Future<UserProfile> getAuthenticatedUserProfile() async {
    final supabaseUser = _supabaseClient.auth.currentUser;
    if (supabaseUser == null || supabaseUser.email == null) {
      throw const PermissionAppError.unauthorized();
    }
    return _loadUserProfile(supabaseUser.id, supabaseUser.email);
  }
}

