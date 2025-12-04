



import 'package:flutter/material.dart';
import 'package:plan_z/features/event_owners/create_event_screen/ui/screens/browse_packages_screen.dart';

/// Budget Item Widget
class BudgetItemWidget extends StatelessWidget {
  final String label;
  final double amount;

  const BudgetItemWidget({
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
        const SizedBox(height: 3),
        Text(
          'EGP ${formatNumberStatic(amount.toInt())}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

