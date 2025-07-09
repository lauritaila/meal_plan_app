abstract class AppError implements Exception {
  final String message;
  final String? code;

  const AppError(this.message, {this.code});

  @override
  String toString() => '$runtimeType: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Exception for errors related to authentication.
class AuthAppError extends AppError {
  const AuthAppError(super.message, {super.code});

  const AuthAppError.invalidCredentials() : super('Invalid credentials. Please check your email and password.', code: 'AUTH_INVALID_CREDENTIALS');
  const AuthAppError.emailNotVerified() : super('Your email has not been verified. Please check your inbox.', code: 'AUTH_EMAIL_NOT_VERIFIED');
  const AuthAppError.userNotFound() : super('User not found.', code: 'AUTH_USER_NOT_FOUND');
  const AuthAppError.emailAlreadyInUse() : super('This email is already registered.', code: 'AUTH_EMAIL_IN_USE');
  const AuthAppError.passwordResetFailed() : super('Could not reset password. Please try again later.', code: 'AUTH_PASSWORD_RESET_FAILED');
  const AuthAppError.resendVerificationFailed() : super('Could not resend verification email.', code: 'AUTH_RESEND_VERIFICATION_FAILED');
  const AuthAppError.invalidOtp() : super('The code you entered is invalid or has expired.', code: 'AUTH_INVALID_OTP');
  const AuthAppError.unexpected({String? message}) : super(message ?? 'An unexpected authentication error occurred.', code: 'AUTH_UNEXPECTED');
}

/// Exception for errors related to the network.
class NetworkAppError extends AppError {
  const NetworkAppError(super.message, {super.code});

  const NetworkAppError.timeout() : super('The request timed out. Please check your internet connection.', code: 'NETWORK_TIMEOUT');
  const NetworkAppError.noConnection() : super('No internet connection. Please connect and try again.', code: 'NETWORK_NO_CONNECTION');
  const NetworkAppError.serverError() : super('Server error. Please try again later.', code: 'NETWORK_SERVER_ERROR');
  const NetworkAppError.badResponse({String? details}) : super('Unexpected response from the server${details != null ? ': $details' : ''}.', code: 'NETWORK_BAD_RESPONSE');
}

/// Exception for errors related to data handling.
class DataAppError extends AppError {
  const DataAppError(super.message, {super.code});

  const DataAppError.notFound(String entity) : super('$entity not found.', code: 'DATA_NOT_FOUND');
  const DataAppError.invalidData(String details) : super('Invalid data: $details', code: 'DATA_INVALID');
  const DataAppError.creationFailed(String entity) : super('Failed to create $entity.', code: 'DATA_CREATION_FAILED');
  const DataAppError.updateFailed(String entity) : super('Failed to update $entity.', code: 'DATA_UPDATE_FAILED');
  const DataAppError.fetchFailed(String entity) : super('Failed to fetch $entity.', code: 'DATA_FETCH_FAILED');
}

/// Exception for errors related to permissions.
class PermissionAppError extends AppError {
  const PermissionAppError(super.message, {super.code});

  const PermissionAppError.unauthorized() : super('Unauthorized. Please sign in again.', code: 'PERMISSION_UNAUTHORIZED');
  const PermissionAppError.forbidden() : super('You do not have permission to perform this action.', code: 'PERMISSION_FORBIDDEN');
}