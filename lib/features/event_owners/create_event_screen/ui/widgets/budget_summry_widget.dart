


import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/event_owners/create_event_screen/ui/widgets/budget_item_widget.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_model.dart';

/// Budget Summary Widget
class BudgetSummaryWidget extends StatelessWidget {
  final Map<String, dynamic> currentService;
  final List<PackageModel> allPackages;
  final Map<String, PackageModel> selectedPackages;

  const BudgetSummaryWidget({
    required this.currentService,
    required this.allPackages,
    required this.selectedPackages,
  });

  @override
  Widget build(BuildContext context) {
    final currentServiceId = currentService['serviceId'];
    final selectedPackage = selectedPackages[currentServiceId];
    final spentAmount = selectedPackage?.price ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryDark,
            AppColors.primaryDark.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BudgetItemWidget(
            label: 'Selected',
            amount: spentAmount,
          ),
        ],
      ),
    );
  }
}

