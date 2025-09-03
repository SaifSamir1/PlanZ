import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_stayls.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/auth/data/models/stakeholder_model.dart';

class StakeholderCard extends StatelessWidget {
  StakeHolderModel stakeholder;
  StakeholderCard({super.key, required this.stakeholder});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // زوايا مستديرة
        side: BorderSide(
          color: Colors.grey.shade400, // لون الخط الخارجي
          width: 0.2, // سمك الخط
        ),
      ),
      color: AppColors.background,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(stakeholder.icon),
                  color: AppColors.buttonPrimary,
                  iconSize: 35,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  stakeholder.titel,
                  style: AppTextStyles.subtitle.copyWith(
                    color: Color(0xFF21225b),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              stakeholder.description,
              style: AppTextStyles.caption.copyWith(
                color: Color(0xFF565d6d),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 10),
            Divider(thickness: 1, color: Color(0xFF565d6d)),
            TextButton.icon(
              onPressed: () {},
              label: Text(
                "Get Statrted",
                style: TextStyle(color: Color(0xFF21225b)),
              ),
              icon: Icon(Icons.arrow_forward, color: Color(0xFF21225b)),
            ),
          ],
        ),
      ),
    );
  }
}
