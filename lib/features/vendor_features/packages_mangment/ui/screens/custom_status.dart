import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class CustomStatus extends StatelessWidget {
  const CustomStatus({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(
          side: BorderSide(color: AppColors.primaryGold),
          value: 'active',
          groupValue: 'status',
          activeColor: AppColors.primaryGold,
        ),
        Text(text, style: AppTextStyles.bodyBold),
      ],
    );
  }
}
