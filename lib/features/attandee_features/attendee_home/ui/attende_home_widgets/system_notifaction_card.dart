import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_stayls.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class SystemNotifactionCard extends StatelessWidget {
  const SystemNotifactionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.date,
  });
  final IconData icon;
  final  String title;
  final String subtitle;
  final String date;

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
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.buttonPrimary, size: 30),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTextStyles.body.copyWith(color: AppColors.primaryDark),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.date_range_outlined, color: AppColors.buttonPrimary),
                SizedBox(width: 5),
                Text(
                  date,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
