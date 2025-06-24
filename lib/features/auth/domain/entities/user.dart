
class UserProfile {
  final String id; // El ID del usuario de Supabase Auth
  final String email;
  final String? name; // Puede ser nulo
  final Map<String, dynamic>? profileData; // jsonb en la BD

  UserProfile({
    required this.id,
    required this.email,
    this.name,
    this.profileData,
  });

}