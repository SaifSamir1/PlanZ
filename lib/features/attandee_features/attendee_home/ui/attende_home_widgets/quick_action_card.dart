import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final  String subtitle;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Card(
        elevation: 0.3,
        color: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey[200]!, width: 0.5),
        ),

        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                CircleAvatar(
                  backgroundColor: AppColors.buttonPrimary,
                  child: IconButton(
                    icon: Icon(icon, color: AppColors.background),
                    onPressed: () {},
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.blue900,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(color: AppColors.neutralGray),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
