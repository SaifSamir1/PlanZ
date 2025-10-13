import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({super.key, required this.subtext, required this.text, required this.maxlines});
  final String text;
  final String subtext;
  final int maxlines ;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text, style: AppTextStyles.subtitle),
      subtitle: TextFormField(
        scrollPhysics: AlwaysScrollableScrollPhysics(),
        maxLines: maxlines,
        style: AppTextStyles.body,
        decoration: InputDecoration(
          hintText: subtext,
          hintStyle: AppTextStyles.body,
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
    );
  }
}
