// lib/features/auth/presentation/providers/auth_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:meal_plan_app/features/auth/domain/domain.dart';
import '../provider.dart';
part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  late final AuthRepository _authRepository;
  String? _snackbarMessage;

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
            state = const UnauthenticatedAuthState(); // <--- CAMBIADO
          }
          break;
        case sb.AuthChangeEvent.signedOut:
          state = const UnauthenticatedAuthState(); // <--- CAMBIADO
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
        case sb.AuthChangeEvent.userDeleted: // Asegúrate de tener este caso si existe en tu SDK
          state = const UnauthenticatedAuthState();
          showSnackbar('Tu cuenta ha sido eliminada.');
          break;
        default:
          // Opcional: loguear eventos no manejados
          // print('Unhandled AuthChangeEvent: $event');
          break;
      }
    });

    _checkAuthStatus();
    return const LoadingAuthState(); // <--- CAMBIADO
  }

  Future<void> _checkAuthStatus() async {
    state = const LoadingAuthState(); // <--- CAMBIADO
    try {
      final user = await _authRepository.getAuthenticatedUserProfile();
      state = AuthenticatedAuthState(user); // <--- CAMBIADO
    } catch (e) {
      state = const UnauthenticatedAuthState(); // <--- CAMBIADO
      // Opcional: showSnackbar('Error al cargar perfil tras autenticación: $e');
    }
  }

  Future<void> login(String email, String password) async {
    state = const LoadingAuthState(); // <--- CAMBIADO
    try {
      await _authRepository.logIn(email, password);
    } on Exception catch (e) {
      state = ErrorAuthState(e.toString()); // <--- CAMBIADO
      showSnackbar(e.toString());
    }
  }

  Future<void> signup(String email, String password) async {
    state = const LoadingAuthState(); // <--- CAMBIADO
    try {
      await _authRepository.signUp(email, password);
      showSnackbar('¡Registro exitoso! Revisa tu correo para verificar tu cuenta.');
      state = const UnauthenticatedAuthState(); // <--- CAMBIADO
    } on Exception catch (e) {
      state = ErrorAuthState(e.toString()); // <--- CAMBIADO
      showSnackbar(e.toString());
    }
  }

  Future<void> logout() async {
    state = const LoadingAuthState(); // <--- CAMBIADO
    try {
      await _authRepository.logOut();
    } on Exception catch (e) {
      state = ErrorAuthState(e.toString()); // <--- CAMBIADO
      showSnackbar(e.toString());
    }
  }

  Future<void> resetPassword(String email) async {
    state = const LoadingAuthState(); // <--- CAMBIADO
    try {
      await _authRepository.resetPassword(email);
      showSnackbar('Se ha enviado un correo para restablecer tu contraseña. Revisa tu bandeja de entrada.');
      state = const UnauthenticatedAuthState(); // <--- CAMBIADO
    } on Exception catch (e) {
      state = ErrorAuthState(e.toString()); // <--- CAMBIADO
      showSnackbar(e.toString());
    }
  }

  void showSnackbar(String message) {
    _snackbarMessage = message;
    Future.delayed(const Duration(milliseconds: 100), () {
      state = MessageAuthState(message); // <--- CAMBIADO
    });
  }
}