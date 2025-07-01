// lib/features/auth/presentation/providers/auth_state.dart

import 'package:meal_plan_app/features/auth/domain/domain.dart'; // Tu entidad UserProfile

// Clase base abstracta para el estado de autenticación
abstract class AuthState {
  const AuthState(); // Constructor constante
}

// 1. Estado inicial
class InitialAuthState extends AuthState {
  const InitialAuthState();

  @override
  String toString() => 'InitialAuthState';
}

// 2. Estado de carga
class LoadingAuthState extends AuthState {
  const LoadingAuthState();

  @override
  String toString() => 'LoadingAuthState';
}

// 3. Estado autenticado
class AuthenticatedAuthState extends AuthState {
  final UserProfile user;
  const AuthenticatedAuthState(this.user);

  @override
  String toString() => 'AuthenticatedAuthState(user: $user)';

  // Opcional: Si necesitas copiar este estado con un usuario diferente
  AuthenticatedAuthState copyWith({UserProfile? user}) {
    return AuthenticatedAuthState(user ?? this.user);
  }
}

// 4. Estado no autenticado
class UnauthenticatedAuthState extends AuthState {
  const UnauthenticatedAuthState();

  @override
  String toString() => 'UnauthenticatedAuthState';
}

// 5. Estado de error
class ErrorAuthState extends AuthState {
  final String message;
  const ErrorAuthState(this.message);

  @override
  String toString() => 'ErrorAuthState(message: $message)';

  // Opcional: Si necesitas copiar este estado con un mensaje diferente
  ErrorAuthState copyWith({String? message}) {
    return ErrorAuthState(message ?? this.message);
  }
}

// 6. Estado de mensaje (temporal para SnackBar)
class MessageAuthState extends AuthState {
  final String message;
  const MessageAuthState(this.message);

  @override
  String toString() => 'MessageAuthState(message: $message)';

  // Opcional: Si necesitas copiar este estado con un mensaje diferente
  MessageAuthState copyWith({String? message}) {
    return MessageAuthState(message ?? this.message);
  }
}