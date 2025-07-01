// lib/features/auth/presentation/providers/auth_provider.dart

import 'package:meal_plan_app/config/errors/app_errors.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:meal_plan_app/features/auth/domain/domain.dart';
import '../provider.dart';
part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  late final AuthRepository _authRepository;
  String? snackbarMessage;

  @override
  AuthState build() {
    _authRepository = ref.watch(authRepositoryProvider);

    sb.Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final sb.AuthChangeEvent event = data.event;
      final sb.Session? session = data.session;

      switch (event) {
        case sb.AuthChangeEvent.initialSession:
        case sb.AuthChangeEvent.signedIn:
          if (session != null) {
            _checkAuthStatus();
          } else {
            state = const UnauthenticatedAuthState(); 
          }
          break;
        case sb.AuthChangeEvent.signedOut:
          state = const UnauthenticatedAuthState();
          break;
        case sb.AuthChangeEvent.userUpdated:
          if (session != null) {
            _checkAuthStatus();
          }
          break;
        case sb.AuthChangeEvent.passwordRecovery:
          showSnackbar('Se ha solicitado un restablecimiento de contraseña. Revisa tu correo.');
          break;
        case sb.AuthChangeEvent.tokenRefreshed:
          break;
        default:
          // print('Unhandled AuthChangeEvent: $event');
          break;
      }
    });

    _checkAuthStatus();
    return const LoadingAuthState(); 
  }

  Future<void> _checkAuthStatus() async {
    state = const LoadingAuthState(); 
    try {
      final user = await _authRepository.getAuthenticatedUserProfile();
      state = AuthenticatedAuthState(user); 
    } catch (e) {
      state = const UnauthenticatedAuthState(); 
      // showSnackbar('Error on checking auth status: $e');
    }
  }

  Future<void> login(String email, String password) async {
    state = const LoadingAuthState(); 
    try {
      await _authRepository.logIn(email, password);
    } on AuthAppError catch (e) { 
      state = ErrorAuthState(e.message);
      showSnackbar(e.message); 
    } on NetworkAppError catch (e) {
      state = ErrorAuthState(e.message);
      showSnackbar(e.message);
    } catch (e) {
      state = ErrorAuthState('An unexpected error occurred: ${e.toString()}');
      showSnackbar('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> signup(String email, String password) async {
    state = const LoadingAuthState(); 
    try {
      await _authRepository.signUp(email, password);
      showSnackbar('¡Registro exitoso! Revisa tu correo para verificar tu cuenta.');
      state = const UnauthenticatedAuthState(); 
    } on AuthAppError catch (e) { 
      state = ErrorAuthState(e.message);
      showSnackbar(e.message); 
    } on NetworkAppError catch (e) {
      state = ErrorAuthState(e.message);
      showSnackbar(e.message);
    } catch (e) {
      state = ErrorAuthState('An unexpected error occurred: ${e.toString()}');
      showSnackbar('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    state = const LoadingAuthState(); 
    try {
      await _authRepository.logOut();
    } on AuthAppError catch (e) { 
      state = ErrorAuthState(e.message);
      showSnackbar(e.message); 
    } on NetworkAppError catch (e) {
      state = ErrorAuthState(e.message);
      showSnackbar(e.message);
    } catch (e) {
      state = ErrorAuthState('An unexpected error occurred: ${e.toString()}');
      showSnackbar('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> resetPassword(String email) async {
    state = const LoadingAuthState(); 
    try {
      await _authRepository.resetPassword(email);
      showSnackbar('Se ha enviado un correo para restablecer tu contraseña. Revisa tu bandeja de entrada.');
      state = const UnauthenticatedAuthState(); 
    } on AuthAppError catch (e) { 
      state = ErrorAuthState(e.message);
      showSnackbar(e.message); 
    } on NetworkAppError catch (e) {
      state = ErrorAuthState(e.message);
      showSnackbar(e.message);
    } catch (e) {
      state = ErrorAuthState('An unexpected error occurred: ${e.toString()}');
      showSnackbar('An unexpected error occurred: ${e.toString()}');
    }
  }

  void showSnackbar(String message) {
    snackbarMessage = message;
    Future.delayed(const Duration(milliseconds: 100), () {
      state = MessageAuthState(message); 
    });
  }
}