import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class CustomItem extends StatelessWidget {
  const CustomItem({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            style: AppTextStyles.body,
            decoration: InputDecoration(
              hintText: text,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primaryGold),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primaryGold),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.delete, color: AppColors.error),
        ),
      ],
    );
  }
}
