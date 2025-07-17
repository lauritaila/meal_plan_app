import 'package:meal_plan_app/features/auth/domain/domain.dart';

abstract class MealPlanDatasource {
  Future<UserPreferences> getUserPreferences(String userId);
  Future<Map<String, dynamic>> generateMealPlan({
    required Map<String, dynamic> userPreferences,
    required Map<String, dynamic> planRequirements,
    required String userComments,
  });
  Future<void> saveGeneratedPlan(String userId, Map<String, dynamic> generatedPlan);
} 