// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:plan_z/core/utils/app_colors.dart';

class ProfileSettingWidget extends StatelessWidget {
  final IconData icon;
  final String title;

  const ProfileSettingWidget({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Card(
        elevation: 0.3,
        color: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey[200]!, width: 0.5),
        ),
        child: ListTile(
          leading: Icon(icon, color: AppColors.buttonPrimary),
          title: Text(title, style: TextStyle(color: AppColors.primaryDark)),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {},
        ),
      ),
    );
  }
}
