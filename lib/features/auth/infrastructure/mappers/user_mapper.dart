import 'package:meal_plan_app/features/auth/domain/domain.dart';

class UserMapper {
  
  static UserProfile fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      profileData: json['profile_data'] as Map<String, dynamic>?,
      onboardingComplete: json['onboarding_complete'] as bool? ?? false,
    );
  }
  
  static Map<String, dynamic> toJson(UserProfile user) {
    return {
      'id': user.id,
      'name': user.name,
      'profile_data': user.profileData,
    };
  }
}