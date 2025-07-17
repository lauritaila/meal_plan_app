import 'package:meal_plan_app/features/auth/domain/domain.dart';
import 'package:meal_plan_app/features/meal_plan/domain/domain.dart';

class MealPlanRepositoryImpl extends MealPlanRepository {
  final MealPlanDatasource datasource;

  MealPlanRepositoryImpl(this.datasource);

  // ... (otros métodos se mantienen igual)

  // --- IMPLEMENTACIÓN DEL NUEVO MÉTODO ---
  @override
  Future<void> saveGeneratedPlan(String userId, Map<String, dynamic> generatedPlan) {
    return datasource.saveGeneratedPlan(userId, generatedPlan);
  }

  @override
  Future<Map<String, dynamic>> generateMealPlan({
    required Map<String, dynamic> userPreferences,
    required Map<String, dynamic> planRequirements,
    required String userComments,
  }) {
    return datasource.generateMealPlan(
      userPreferences: userPreferences,
      planRequirements: planRequirements,
      userComments: userComments,
    );
  }

  @override
  Future<UserPreferences> getUserPreferences(String userId) {
    return datasource.getUserPreferences(userId);
  }
}