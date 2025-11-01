// lib/features/attendee/presentation/widgets/my_events/event_date_badge.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class EventDateBadge extends StatelessWidget {
  final DateTime date;
  final bool isPast;

  const EventDateBadge({
    super.key,
    required this.date,
    this.isPast = false,
  });

  @override
  Widget build(BuildContext context) {
    final month = DateFormat('MMM').format(date).toUpperCase();
    final day = DateFormat('d').format(date);

    return Container(
      width: 60,
      height: 70,
      decoration: BoxDecoration(
        color: isPast ? Colors.grey[200] : AppColors.buttonPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPast ? Colors.grey[400]! : AppColors.buttonPrimary,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            month,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isPast ? Colors.grey[600] : AppColors.buttonPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            day,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isPast ? Colors.grey[700] : AppColors.buttonPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
