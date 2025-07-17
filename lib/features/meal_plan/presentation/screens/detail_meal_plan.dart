import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/provider.dart';

class DetailMealPlanScreen extends ConsumerWidget {
  final Map<String, dynamic>? generatedPlan;

  const DetailMealPlanScreen({super.key, this.generatedPlan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escuchamos el estado del guardado para navegar o mostrar errores
    ref.listen(mealPlanSaveProvider, (previous, next) {
      if (next.status == MealPlanSaveStatus.success) {
        // Cuando se guarda con éxito, GoRouter nos llevará a /home automáticamente
        // porque el estado de onboarding habrá cambiado.
        // Opcionalmente, podemos mostrar un SnackBar aquí.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plan saved successfully!')),
        );
      }
      if (next.status == MealPlanSaveStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? 'Failed to save plan')),
        );
      }
    });

    final saverState = ref.watch(mealPlanSaveProvider);
    final isSaving = saverState.status == MealPlanSaveStatus.saving;

    return Scaffold(
      appBar: AppBar(title: const Text('Approve Your New Plan')),
      body: Center(
        child: generatedPlan == null
            ? const Text('No plan data received.')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Plan Name: ${generatedPlan!['plan_name']}'),
                  const SizedBox(height: 20),
                  // TODO: Mostrar el plan detallado aquí.
                  ElevatedButton(
                    onPressed: isSaving ? null : () {
                      if (generatedPlan != null) {
                        ref.read(mealPlanSaveProvider.notifier).savePlan(generatedPlan!);
                      }
                    },
                    child: isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Approve and Save Plan'),
                  ),
                ],
              ),
      ),
    );
  }
}