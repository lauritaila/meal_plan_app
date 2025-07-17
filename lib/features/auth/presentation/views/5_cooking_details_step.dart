// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_plan_app/features/auth/presentation/provider/provider.dart';

class CookingDetailsStep extends ConsumerWidget {
  const CookingDetailsStep({super.key});

  final List<String> _skillLevels = const ['Beginner', 'Intermediate', 'Advanced'];
  final List<String> _timeOptions = const ['15 min', '30 min', '1+ hour'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(preferencesWizardProvider);
    final notifier = ref.read(preferencesWizardProvider.notifier);
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Icon(Icons.soup_kitchen_outlined, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text('Cooking Details', style: textTheme.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 24),

          // Cooking Skill
          Text('Cooking Skill', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12.0,
            alignment: WrapAlignment.center,
            children: _skillLevels.map((level) {
              return ChoiceChip(
                label: Text(level),
                selected: state.cookingSkillLevel == level,
                onSelected: (_) => notifier.updateCookingSkillLevel(level),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Time Availability
          Text('Time Availability', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12.0,
            alignment: WrapAlignment.center,
            children: _timeOptions.map((time) {
              return ChoiceChip(
                label: Text(time),
                selected: state.timeAvailability == time,
                onSelected: (_) => notifier.updateTimeAvailability(time),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Household Size
          Text('Household Size', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: state.householdSize > 1 ? () => notifier.updateHouseholdSize(state.householdSize - 1) : null,
              ),
              Text(state.householdSize.toString(), style: textTheme.titleLarge),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => notifier.updateHouseholdSize(state.householdSize + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
