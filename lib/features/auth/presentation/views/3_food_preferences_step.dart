// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meal_plan_app/features/auth/presentation/provider/provider.dart';

class FoodPreferencesStep extends ConsumerStatefulWidget {
  const FoodPreferencesStep({super.key});

  @override
  ConsumerState<FoodPreferencesStep> createState() => _FoodPreferencesStepState();
}

class _FoodPreferencesStepState extends ConsumerState<FoodPreferencesStep> {
  late final TextEditingController _dislikedController;
  late final TextEditingController _likedController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(preferencesWizardProvider);
    _dislikedController = TextEditingController(text: state.dislikedFoods.join(', '));
    _likedController = TextEditingController(text: state.likedFoods.join(', '));
  }

  @override
  void dispose() {
    _dislikedController.dispose();
    _likedController.dispose();
    super.dispose();
  }
  
  void _updateFoods() {
      final disliked = _dislikedController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      final liked = _likedController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      ref.read(preferencesWizardProvider.notifier).updateDislikedFoods(disliked);
      ref.read(preferencesWizardProvider.notifier).updateLikedFoods(liked);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Icon(Icons.fastfood_outlined, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text('Food Preferences', style: textTheme.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          
          Text('Disliked Foods', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          TextFormField(
            controller: _dislikedController,
            decoration: const InputDecoration(
              hintText: 'List foods you dislike or want to avoid...',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            onEditingComplete: _updateFoods,
          ),
          
          const SizedBox(height: 24),
          
          Text('Liked Foods', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          TextFormField(
            controller: _likedController,
            decoration: const InputDecoration(
              hintText: 'List your favorite foods and ingredients...',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            onEditingComplete: _updateFoods,
          ),
        ],
      ),
    );
  }
}
