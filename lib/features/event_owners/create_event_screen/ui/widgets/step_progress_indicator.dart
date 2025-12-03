


import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Progress Text
        Text(
          'Progress:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 12),

        // Progress Dots
        Expanded(
          child: Row(
            children: List.generate(
              totalSteps,
              (index) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 8,
                  decoration: BoxDecoration(
                    color: index < currentStep
                        ? AppColors.primaryGold
                        : AppColors.blue100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Step Counter
        Text(
          '($currentStep/$totalSteps)',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryGold,
          ),
        ),
      ],
    );
  }
}

