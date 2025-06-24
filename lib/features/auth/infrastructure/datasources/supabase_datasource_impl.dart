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

      final Session? session = res.session;
      final User? supabaseUser = res.user;

      if (session == null || supabaseUser == null) {
        throw Exception('Inicio de sesión fallido: No se pudo obtener la sesión o el usuario.');
      }

      // Obtener los datos del perfil del usuario de nuestra tabla user_profiles
      final response = await _supabaseClient
          .from('user_profiles')
          .select()
          .eq('id', supabaseUser.id)
          .single();

      return UserMapper.fromJson({
        ...response, // Datos de user_profiles
        'email': supabaseUser.email, // Añadimos el email del usuario de Supabase Auth
      });

    } on AuthException catch (e) {
      throw Exception('Error de autenticación: ${e.message}');
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }


  /// Crea también la entrada en 'user_profiles' y 'user_subscriptions'.
  @override
  Future<UserProfile> signUp(String email, String password) async {
    try {
      final AuthResponse res = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      final Session? session = res.session;
      final User? supabaseUser = res.user;

      if (session == null || supabaseUser == null) {
        throw Exception('Registro fallido: No se pudo obtener la sesión o el usuario.');
      }

      // 1. Crear el perfil del usuario en la tabla 'user_profiles'
      await _supabaseClient.from('user_profiles').insert({
        'id': supabaseUser.id, // El ID de auth.users
        'name': null, // O un nombre por defecto si lo pides en el registro
        'profile_data': {}, // Inicializar si es necesario
      });

      // 2. Asignar el plan gratuito por defecto en 'user_subscriptions'
      final freePlan = await _supabaseClient
          .from('subscription_plans')
          .select('id')
          .eq('name', 'Free') // Asegúrate de tener un plan con nombre 'Free'
          .single();


      await _supabaseClient.from('user_subscriptions').insert({
        'user_id': supabaseUser.id,
        'plan_id': freePlan['id'],
        'status': 'active',
      });

      // Devolver la entidad User creada
      return UserProfile(id: supabaseUser.id, email: supabaseUser.email!);
    } on AuthException catch (e) {
      // Manejar errores específicos de autenticación (ej. email ya registrado)
      throw Exception('Error de autenticación al registrar: ${e.message}');
    } catch (e) {
      throw Exception('Error al registrar usuario: $e');
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      throw Exception('Error al cerrar sesión: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado al cerrar sesión: $e');
    }
  }

  /// Envía un correo de recuperación de contraseña.
  @override
  Future<UserProfile> resetPassword(String email) async {
    //TODO: Implementar la lógica de restablecimiento de contraseña
    throw UnimplementedError('resetPassword no está implementado en SupabaseDatasourceImpl');
  }
  
  @override
  Future<bool> resendVerificationEmail(String email) async {
    try {
      await _supabaseClient.auth.resend(type: OtpType.signup, email: email);
      return true;
    } catch (e) {
      return false;
    }
  }
}
 
