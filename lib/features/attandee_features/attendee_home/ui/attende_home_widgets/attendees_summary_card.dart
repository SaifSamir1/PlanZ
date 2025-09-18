import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_stayls.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class AttendeesSummaryCard extends StatelessWidget {
  const AttendeesSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.3,
      color: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("456", style: AppTextStyles.headline1),

                SizedBox(width: 20),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Attendees Checked In Today",
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.primaryDark,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Icon(Icons.people_outlined, color: Colors.amber, size: 30),
              ],
            ),
            Text(
              "Total confirmed entries for all active events.",
              style: AppTextStyles.body.copyWith(color: AppColors.primaryDark),
            ),
          ],
        ),
      ),
    );
  }
}
