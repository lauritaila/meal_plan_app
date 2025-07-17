// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_plan_app/features/auth/presentation/provider/provider.dart';

class GoalsStep extends ConsumerWidget {
  const GoalsStep({super.key});

  final List<String> _goalOptions = const [
    'Weight Loss', 'Weight Gain', 'Muscle Building', 'Heart Health', 
    'Diabetes Management', 'High Protein', 'Low Sodium', 'Anti-Inflammatory'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGoals = ref.watch(preferencesWizardProvider).healthGoals;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Icon(Icons.flag_outlined, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text('Dietary Choices & Goals', style: textTheme.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            alignment: WrapAlignment.center,
            children: _goalOptions.map((goal) {
              final isSelected = selectedGoals.contains(goal);
              return FilterChip(
                label: Text(goal),
                selected: isSelected,
                onSelected: (selected) {
                  final currentSelection = List<String>.from(selectedGoals);
                  if (selected) {
                    currentSelection.add(goal);
                  } else {
                    currentSelection.remove(goal);
                  }
                  ref.read(preferencesWizardProvider.notifier).updateHealthGoals(currentSelection);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
