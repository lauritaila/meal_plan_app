// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_plan_app/features/auth/presentation/provider/preferences_wizard/preferences_wizard_provider.dart';
import 'package:meal_plan_app/features/auth/presentation/provider/provider.dart';

class AllergiesStep extends ConsumerWidget {
  const AllergiesStep({super.key});

  final List<String> _allergyOptions = const [
    'Nuts', 'Dairy', 'Eggs', 'Soy', 'Wheat', 'Fish', 'Shellfish', 'Sesame'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAllergies = ref.watch(preferencesWizardProvider).allergies;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Icon(Icons.warning_amber_rounded, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text('Allergies', style: textTheme.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            alignment: WrapAlignment.center,
            children: _allergyOptions.map((allergy) {
              final isSelected = selectedAllergies.contains(allergy);
              return FilterChip(
                label: Text(allergy),
                selected: isSelected,
                onSelected: (selected) {
                  final currentSelection = List<String>.from(selectedAllergies);
                  if (selected) {
                    currentSelection.add(allergy);
                  } else {
                    currentSelection.remove(allergy);
                  }
                  ref.read(preferencesWizardProvider.notifier).updateAllergies(currentSelection);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text('Other allergies', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Please specify any other allergies...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            // You might want to handle this text field's state separately
            // or add an "Other" string to the list and show the field when selected.
          ),
        ],
      ),
    );
  }
}
