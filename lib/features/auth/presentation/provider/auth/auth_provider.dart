import 'dart:async';
import 'package:meal_plan_app/features/auth/presentation/provider/provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import 'package:meal_plan_app/config/config.dart';
import 'package:meal_plan_app/features/auth/domain/domain.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  late final AuthRepository _authRepository;
  StreamSubscription<sb.AuthState>? _authSubscription;

  @override
  AuthState build() {
    _authRepository = ref.watch(authRepositoryProvider);

    _authSubscription?.cancel();
    _authSubscription = sb.Supabase.instance.client.auth.onAuthStateChange
        .listen((data) {
          if (data.event == sb.AuthChangeEvent.signedOut) {
            state = const UnauthenticatedAuthState();
          }
        });

    ref.onDispose(() {
      _authSubscription?.cancel();
    });

    return const InitialAuthState();
  }

  Future<void> checkInitialStatus() async {
    if (state is! InitialAuthState) return;
    await refreshUserStatus(); 
  }

  Future<void> login(String email, String password) async {
    state = const LoadingAuthState();
    try {
      final user = await _authRepository.logIn(email, password);
      state = AuthenticatedAuthState(user);
    } on AppError catch (e) {
      state = ErrorAuthState(e.message);
    } catch (e) {
      state = const ErrorAuthState('An unexpected error occurred.');
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    state = const LoadingAuthState();
    try {
      await _authRepository.signUp(email, password, name);
      await _authRepository.signInWithOtp(email);
      state = AwaitingOtpInputState(email);
    } on AppError catch (e) {
      state = ErrorAuthState(e.message);
    } catch (e) {
      state = const ErrorAuthState(
        'An unexpected error occurred during sign up.',
      );
    }
  }

Future<void> sendOtp(String email) async {
    state = const LoadingAuthState();
    try {
      final exists = await _authRepository.userExists(email);
      if (!exists) {
        throw const AuthAppError.userNotFound();
      }
      await _authRepository.signInWithOtp(email);
      state = AwaitingOtpInputState(email);
    } on AppError catch (e) {
      state = ErrorAuthState(e.message);
    } catch (e) {
      state = const ErrorAuthState('Failed to send OTP. Please try again.');
    }
  }

  void cancelOtpFlow() {
    state = const UnauthenticatedAuthState();
  }

  Future<void> verifyOtp(String email, String token) async {
    state = const LoadingAuthState();
    try {
      final userProfile = await _authRepository.verifyOtp(email, token);
      state = AuthenticatedAuthState(userProfile);
    } on AppError catch (e) {
      state = ErrorAuthState(e.message);
      state = ErrorAuthState(e.message);
      state = AwaitingOtpInputState(email);
    } catch (e) {
      state = const ErrorAuthState('An unexpected error occurred.');
    }
  }

  Future<void> logOut() async {
    try {
      await _authRepository.logOut();
      state = const UnauthenticatedAuthState();
    } on AppError catch (e) {
      state = ErrorAuthState(e.message);
    }
  }

    Future<void> refreshUserStatus() async {
    try {
      final user = await _authRepository.getAuthenticatedUserProfile();
      state = AuthenticatedAuthState(user);
    } catch (_) {
      state = const UnauthenticatedAuthState();
    }
  }
}
