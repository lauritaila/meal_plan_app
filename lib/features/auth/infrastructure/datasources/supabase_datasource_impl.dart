import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/domain.dart';
import '../infrastructure.dart';

//TODO: IMPLEMENT BETTER ERROR MESSAGE 

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
        throw Exception('Login failed: Could not get user. Please try again.');
      }
      return _loadUserProfile(supabaseAuthUser.id, supabaseAuthUser.email);
    } on AuthException catch (e) {
      throw Exception('Authentication error: ${e.message}');
    } catch (e) {
      throw Exception('Login failed unexpectedly: $e');
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
        throw Exception('Sign up failed: Could not get user from Supabase. Please try again.');
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
      throw Exception('Registration error: ${e.message}');
    } catch (e) {
      throw Exception('Sign up failed unexpectedly: $e');
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      throw Exception('Logout error: ${e.message}');
    } catch (e) {
      throw Exception('Logout failed unexpectedly: $e');
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
      throw Exception('Password reset request error: ${e.message}');
    } catch (e) {
      throw Exception('Password reset request failed unexpectedly: $e');
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
      throw Exception('Resend verification email error: ${e.message}');
    } catch (e) {
      throw Exception('Resend verification email failed unexpectedly: $e');
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
    } catch (e) {
      throw Exception('Failed to load user profile: $e');
    }
  }

    @override
  Future<UserProfile> getAuthenticatedUserProfile() async {
    final supabaseUser = _supabaseClient.auth.currentUser;
    if (supabaseUser == null || supabaseUser.email == null) {
      throw Exception('There is not a user');
    }
    return _loadUserProfile(supabaseUser.id, supabaseUser.email);
  }
}

