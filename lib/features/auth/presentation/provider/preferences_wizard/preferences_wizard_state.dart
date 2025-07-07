import '../../../domain/entities/user_preferences.dart';

class PreferencesWizardState {
  final int step;
  final List<String> dietaryRestrictions;
  final List<String> allergies;
  final List<String> preferredCuisines;
  final List<String> healthGoals;
  final String? cookingSkillLevel;
  final String? timeAvailability;
  final List<String> dislikedFoods;
  final List<String> likedFoods;
  final int householdSize;

  PreferencesWizardState({
    this.step = 0,
    this.dietaryRestrictions = const [],
    this.allergies = const [],
    this.preferredCuisines = const [],
    this.healthGoals = const [],
    this.cookingSkillLevel,
    this.timeAvailability,
    this.dislikedFoods = const [],
    this.likedFoods = const [],
    this.householdSize = 1,
  });

  PreferencesWizardState copyWith({
    int? step,
    List<String>? dietaryRestrictions,
    List<String>? allergies,
    List<String>? preferredCuisines,
    List<String>? healthGoals,
    String? cookingSkillLevel,
    String? timeAvailability,
    List<String>? dislikedFoods,
    List<String>? likedFoods,
    int? householdSize,
  }) {
    return PreferencesWizardState(
      step: step ?? this.step,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      allergies: allergies ?? this.allergies,
      preferredCuisines: preferredCuisines ?? this.preferredCuisines,
      healthGoals: healthGoals ?? this.healthGoals,
      cookingSkillLevel: cookingSkillLevel ?? this.cookingSkillLevel,
      timeAvailability: timeAvailability ?? this.timeAvailability,
      dislikedFoods: dislikedFoods ?? this.dislikedFoods,
      likedFoods: likedFoods ?? this.likedFoods,
      householdSize: householdSize ?? this.householdSize,
    );
  }

  UserPreferences toUserPreferences(String userId) {
    return UserPreferences(
      userId: userId,
      dietaryRestrictions: dietaryRestrictions,
      allergies: allergies,
      preferredCuisines: preferredCuisines,
      healthGoals: healthGoals,
      cookingSkillLevel: cookingSkillLevel,
      timeAvailability: timeAvailability,
      dislikedFoods: dislikedFoods,
      likedFoods: likedFoods,
      householdSize: householdSize,
    );
  }
} 