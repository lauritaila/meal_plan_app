import 'package:meal_plan_app/features/auth/domain/domain.dart'; 

abstract class AuthState {
  const AuthState(); 
}

// 1. init state
class InitialAuthState extends AuthState {
  const InitialAuthState();

  @override
  String toString() => 'InitialAuthState';
}

// 2. loading state
class LoadingAuthState extends AuthState {
  const LoadingAuthState();

  @override
  String toString() => 'LoadingAuthState';
}

// 3. authenticated state
class AuthenticatedAuthState extends AuthState {
  final UserProfile user;
  const AuthenticatedAuthState(this.user);

  @override
  String toString() => 'AuthenticatedAuthState(user: $user)';

  // Optional: for if you need to copy with a different user
  AuthenticatedAuthState copyWith({UserProfile? user}) {
    return AuthenticatedAuthState(user ?? this.user);
  }
}

// 4. No authenticated state
class UnauthenticatedAuthState extends AuthState {
  const UnauthenticatedAuthState();

  @override
  String toString() => 'UnauthenticatedAuthState';
}

// 5. Error state
class ErrorAuthState extends AuthState {
  final String message;
  const ErrorAuthState(this.message);

  @override
  String toString() => 'ErrorAuthState(message: $message)';

  // Optional: for if you need to copy with a different user
  ErrorAuthState copyWith({String? message}) {
    return ErrorAuthState(message ?? this.message);
  }
}

// 6. Message state
class MessageAuthState extends AuthState {
  final String message;
  const MessageAuthState(this.message);

  @override
  String toString() => 'MessageAuthState(message: $message)';

  // Optional: for if you need to copy with a different user
  MessageAuthState copyWith({String? message}) {
    return MessageAuthState(message ?? this.message);
  }
}