// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_plan_app/features/auth/presentation/provider/provider.dart';

class DietaryStep extends ConsumerWidget {
  const DietaryStep({super.key});

  final List<String> _dietOptions = const [
    'Vegetarian', 'Vegan', 'Pescatarian', 'Keto', 'Paleo', 'Mediterranean',
    'Low Carb', 'Low Fat', 'Gluten Free', 'Dairy Free', 'Nut Free', 'Halal', 'Kosher'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDiets = ref.watch(preferencesWizardProvider).dietaryRestrictions;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Icon(Icons.restaurant_menu, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text('Dietary Preferences & Restrictions', style: textTheme.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            alignment: WrapAlignment.center,
            children: _dietOptions.map((diet) {
              final isSelected = selectedDiets.contains(diet);
              return FilterChip(
                label: Text(diet),
                selected: isSelected,
                onSelected: (selected) {
                  final currentSelection = List<String>.from(selectedDiets);
                  if (selected) {
                    currentSelection.add(diet);
                  } else {
                    currentSelection.remove(diet);
                  }
                  ref.read(preferencesWizardProvider.notifier).updateDietaryRestrictions(currentSelection);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
