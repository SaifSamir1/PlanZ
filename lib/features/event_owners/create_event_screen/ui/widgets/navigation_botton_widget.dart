


import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_model.dart';

/// Navigation Buttons Widget
class NavigationButtonsWidget extends StatelessWidget {
  final int currentServiceIndex;
  final int totalServices;
  final Map<String, dynamic> currentService;
  final Map<String, PackageModel> selectedPackages;
  final VoidCallback onSkipService;
  final VoidCallback onNextService;
  final VoidCallback onFinishSelection;

  const NavigationButtonsWidget({
    required this.currentServiceIndex,
    required this.totalServices,
    required this.currentService,
    required this.selectedPackages,
    required this.onSkipService,
    required this.onNextService,
    required this.onFinishSelection,
  });

  @override
  Widget build(BuildContext context) {
    final isLastService = currentServiceIndex == totalServices - 1;
    final canSkip = currentService['required'] != true;
    final currentServiceId = currentService['serviceId'];
    // ✅ فقط تحقق من selectedPackages
    // في replacement mode، currentPackageId بتُستخدم فقط في البداية
    final hasSelected = selectedPackages.containsKey(currentServiceId);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (canSkip)
            Expanded(
              child: OutlinedButton(
                onPressed: onSkipService,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.primaryGold),
                ),
                child: const Text('Skip (Optional)'),
              ),
            ),
          if (canSkip) const SizedBox(width: 12),
          Expanded(
            flex: canSkip ? 1 : 2,
            child: ElevatedButton(
              onPressed: hasSelected
                  ? (isLastService ? onFinishSelection : onNextService)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGold,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                isLastService ? 'Finish Selection' : 'Next Service →',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

