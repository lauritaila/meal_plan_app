import 'package:meal_plan_app/config/config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:meal_plan_app/features/auth/domain/domain.dart';
import 'package:meal_plan_app/features/auth/infrastructure/infrastructure.dart';
import 'package:meal_plan_app/features/meal_plan/domain/domain.dart';

class SupabaseMealPlanDatasource extends MealPlanDatasource {
  final SupabaseClient _supabaseClient;

  SupabaseMealPlanDatasource(this._supabaseClient);

  @override
  Future<void> saveGeneratedPlan(String userId, Map<String, dynamic> generatedPlan) async {
    try {
      await _supabaseClient.rpc('transactional_plan_insert', params: {
        'p_user_id': userId,
        'p_plan_data': generatedPlan
      });

    } catch (e) {
      throw DataAppError.creationFailed('meal plan');
    }
  }

  @override
  Future<Map<String, dynamic>> generateMealPlan({
    required Map<String, dynamic> userPreferences,
    required Map<String, dynamic> planRequirements,
    required String userComments,
  }) async {
    try {
      final response = await _supabaseClient.functions.invoke(
        'generate-meal-plan',
        body: {
          'user_preferences': userPreferences,
          'plan_requirements': planRequirements,
          'user_comments': userComments,
        },
      );

      if (response.status != 200) {
        throw DataAppError.creationFailed('meal plan');
      }
      
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw NetworkAppError.serverError();
    }
  }

  @override
  Future<UserPreferences> getUserPreferences(String userId) async {
    try {
      final response = await _supabaseClient
          .from('user_preferences')
          .select()
          .eq('user_id', userId)
          .single();
      return UserPreferencesMapper.fromMap(response);
    } catch (e) {
      throw DataAppError.fetchFailed('user preferences');
    }
  }
}