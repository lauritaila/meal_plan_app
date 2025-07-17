import 'package:meal_plan_app/features/auth/presentation/provider/provider.dart';
import 'package:meal_plan_app/features/meal_plan/presentation/providers/provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meal_plan_save_provider.g.dart';

enum MealPlanSaveStatus { initial, saving, success, error }

class MealPlanSaveState {
  final MealPlanSaveStatus status;
  final String? errorMessage;

  MealPlanSaveState({
    this.status = MealPlanSaveStatus.initial,
    this.errorMessage,
  });

  MealPlanSaveState copyWith({
    MealPlanSaveStatus? status,
    String? errorMessage,
  }) {
    return MealPlanSaveState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@riverpod
class MealPlanSave extends _$MealPlanSave {
  @override
  MealPlanSaveState build() {
    return MealPlanSaveState();
  }

  Future<void> savePlan(Map<String, dynamic> generatedPlan) async {
    state = state.copyWith(status: MealPlanSaveStatus.saving);
    try {
      final authState = ref.read(authProvider);
      if (authState is! AuthenticatedAuthState) {
        throw Exception('User not authenticated');
      }
      final userId = authState.user.id;

      final mealPlanRepo = ref.read(mealPlanRepositoryProvider);
      await mealPlanRepo.saveGeneratedPlan(userId, generatedPlan);

      // Importante: Refrescar el estado del usuario para actualizar onboarding_complete
      await ref.read(authProvider.notifier).refreshUserStatus();

      state = state.copyWith(status: MealPlanSaveStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: MealPlanSaveStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}