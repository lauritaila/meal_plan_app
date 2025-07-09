
import 'package:equatable/equatable.dart'; 

class UserProfile extends Equatable {
  final String id;
  final String email;
  final String? name;
  final Map<String, dynamic>? profileData;
  final bool onboardingComplete;

  const UserProfile({
    required this.onboardingComplete,
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
    bool? onboardingComplete,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileData: profileData ?? this.profileData,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }

  @override
  List<Object?> get props => [id, email, name, profileData];
}