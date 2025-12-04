



import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';

/// Progress Indicator Widget
class ProgressIndicatorWidget extends StatelessWidget {
  final int currentServiceIndex;
  final int totalServices;

  const ProgressIndicatorWidget({
    required this.currentServiceIndex,
    required this.totalServices,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.cardBackground,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Service ${currentServiceIndex + 1} of $totalServices',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${(((currentServiceIndex + 1) / totalServices * 100).toInt())}% Complete',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: (currentServiceIndex + 1) / totalServices,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGold),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}

