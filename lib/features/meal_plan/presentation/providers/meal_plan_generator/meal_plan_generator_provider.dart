import 'package:meal_plan_app/features/auth/presentation/provider/provider.dart';
import 'package:meal_plan_app/features/meal_plan/presentation/providers/provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meal_plan_generator_provider.g.dart';

// Enum para el estado del formulario
enum MealPlanGeneratorStatus { initial, loading, success, error }

// Clase de estado
class MealPlanGeneratorState {
  final MealPlanGeneratorStatus status;
  final String? errorMessage;
  final Map<String, dynamic>? generatedPlan; // Aquí guardaremos el plan de la IA

  MealPlanGeneratorState({
    this.status = MealPlanGeneratorStatus.initial,
    this.errorMessage,
    this.generatedPlan,
  });

  MealPlanGeneratorState copyWith({
    MealPlanGeneratorStatus? status,
    String? errorMessage,
    Map<String, dynamic>? generatedPlan,
  }) {
    return MealPlanGeneratorState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      generatedPlan: generatedPlan ?? this.generatedPlan,
    );
  }
}

// El provider
@riverpod
class MealPlanGenerator extends _$MealPlanGenerator {
  @override
  MealPlanGeneratorState build() {
    return MealPlanGeneratorState();
  }

  Future<void> generatePlan({
    required String comments,
    int durationDays = 7, // Valor por defecto
  }) async {
    state = state.copyWith(status: MealPlanGeneratorStatus.loading);

    try {
      final authState = ref.read(authProvider);
      if (authState is! AuthenticatedAuthState) {
        throw Exception('User not authenticated');
      }
      final userId = authState.user.id;

      // Obtenemos las preferencias del usuario
      final mealPlanRepo = ref.read(mealPlanRepositoryProvider);
      final preferences = await mealPlanRepo.getUserPreferences(userId);
      
      // TODO: Necesitamos un Mapper para UserPreferences -> Map<String, dynamic>
      // Por ahora, lo simulamos. Deberías crear este mapper.
      final preferencesMap = {
        "dietary_restrictions": preferences.dietaryRestrictions,
        "allergies": preferences.allergies,
        "preferred_cuisines": preferences.preferredCuisines,
        "health_goals": preferences.healthGoals,
        "cooking_skill_level": preferences.cookingSkillLevel,
        "time_availability": preferences.timeAvailability,
        "disliked_foods": preferences.dislikedFoods,
        "liked_foods": preferences.likedFoods,
        "household_size": preferences.householdSize,
      };

      final planRequirements = {
        "duration_days": durationDays,
        "start_date": DateTime.now().toIso8601String().split('T')[0],
      };

      final generatedPlan = await mealPlanRepo.generateMealPlan(
        userPreferences: preferencesMap,
        planRequirements: planRequirements,
        userComments: comments,
      );

      state = state.copyWith(
        status: MealPlanGeneratorStatus.success,
        generatedPlan: generatedPlan,
      );
    } catch (e) {
      state = state.copyWith(
        status: MealPlanGeneratorStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}