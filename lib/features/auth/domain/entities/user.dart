
import 'package:equatable/equatable.dart'; 

class UserProfile extends Equatable {
  final String id;
  final String email;
  final String? name;
  final Map<String, dynamic>? profileData;

  const UserProfile({
    required this.id,
    required this.email,
    this.name,
    this.profileData,
  });

  UserProfile copyWith({
    String? id,
    String? email,
    String? name,
    Map<String, dynamic>? profileData,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileData: profileData ?? this.profileData,
    );
  }

  @override
  List<Object?> get props => [id, email, name, profileData];
}