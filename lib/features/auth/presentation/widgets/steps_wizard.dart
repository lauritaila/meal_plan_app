import 'package:flutter/material.dart';

class StepsWizard extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  const StepsWizard({super.key, required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            height: 2.0,
            color: Colors.grey[300],
          ),
        ),
        const SizedBox(width: 8.0),
        Text(
          'Step $currentStep of $totalSteps',
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Container(
            height: 2.0,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }
}