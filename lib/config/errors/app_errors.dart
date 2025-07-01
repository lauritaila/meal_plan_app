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
  
  const AuthAppError.invalidCredentials() : super('Credenciales inválidas. Por favor, verifica tu email y contraseña.', code: 'AUTH_INVALID_CREDENTIALS');
  const AuthAppError.emailNotVerified() : super('Tu correo electrónico no ha sido verificado. Revisa tu bandeja de entrada.', code: 'AUTH_EMAIL_NOT_VERIFIED');
  const AuthAppError.userNotFound() : super('Usuario no encontrado.', code: 'AUTH_USER_NOT_FOUND');
  const AuthAppError.emailAlreadyInUse() : super('Este correo electrónico ya está registrado.', code: 'AUTH_EMAIL_IN_USE');
  const AuthAppError.passwordResetFailed() : super('No se pudo restablecer la contraseña. Inténtalo de nuevo más tarde.', code: 'AUTH_PASSWORD_RESET_FAILED');
  const AuthAppError.resendVerificationFailed() : super('No se pudo reenviar el correo de verificación.', code: 'AUTH_RESEND_VERIFICATION_FAILED');
}

/// Exception for errors related to the network.
class NetworkAppError extends AppError {
  const NetworkAppError(super.message, {super.code});

  const NetworkAppError.timeout() : super('La solicitud ha tardado demasiado tiempo. Verifica tu conexión a internet.', code: 'NETWORK_TIMEOUT');
  const NetworkAppError.noConnection() : super('No hay conexión a internet. Por favor, conéctate y vuelve a intentarlo.', code: 'NETWORK_NO_CONNECTION');
  const NetworkAppError.serverError() : super('Error del servidor. Por favor, inténtalo de nuevo más tarde.', code: 'NETWORK_SERVER_ERROR');
  const NetworkAppError.badResponse(String details) : super('Respuesta inesperada del servidor: $details', code: 'NETWORK_BAD_RESPONSE');
}

/// Exception for errors related to data.
class DataAppError extends AppError {
  const DataAppError(super.message, {super.code});

  const DataAppError.notFound(String entity) : super('$entity no encontrado.', code: 'DATA_NOT_FOUND');
  const DataAppError.invalidData(String details) : super('Datos inválidos: $details', code: 'DATA_INVALID');
  const DataAppError.creationFailed(String entity) : super('Fallo al crear $entity.', code: 'DATA_CREATION_FAILED');
}

/// Exception for errors related to permissions.
class PermissionAppError extends AppError {
  const PermissionAppError(super.message, {super.code});

  const PermissionAppError.unauthorized() : super('No autorizado. Por favor, inicia sesión de nuevo.', code: 'PERMISSION_UNAUTHORIZED');
  const PermissionAppError.forbidden() : super('No tienes permisos para realizar esta acción.', code: 'PERMISSION_FORBIDDEN');
}