import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_plan_app/features/meal_plan/presentation/providers/provider.dart';

class NewMealPlanScreen extends ConsumerStatefulWidget {
  const NewMealPlanScreen({super.key});

  @override
  ConsumerState<NewMealPlanScreen> createState() => _NewMealPlanScreenState();
}

class _NewMealPlanScreenState extends ConsumerState<NewMealPlanScreen> {
  final _commentsController = TextEditingController();

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(mealPlanGeneratorProvider, (previous, next) {
      if (next.status == MealPlanGeneratorStatus.success) {
        // Navega a la pantalla de aprobación cuando el plan esté listo.
        // Pasamos el plan generado como un extra.
        context.push('/meal_plan/approve', extra: next.generatedPlan);
      }
      if (next.status == MealPlanGeneratorStatus.error) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(next.errorMessage ?? 'An error occurred')));
      }
    });

    final state = ref.watch(mealPlanGeneratorProvider);
    final isLoading = state.status == MealPlanGeneratorStatus.loading;

    return Scaffold(
      appBar: AppBar(title: const Text('Generate New Meal Plan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Any additional comments?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Let the AI know if you have specific requests for this week (e.g., "use up the chicken in my fridge", "I want a pasta night", "keep it budget-friendly").'
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentsController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Type your comments here...',
              ),
              maxLines: 5,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      ref.read(mealPlanGeneratorProvider.notifier).generatePlan(
                            comments: _commentsController.text,
                          );
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Generate My Plan'),
            ),
          ],
        ),
      ),
    );
  }
}