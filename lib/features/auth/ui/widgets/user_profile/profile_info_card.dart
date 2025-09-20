import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_stayls.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 0.3,
        color: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey[200]!, width: 0.5),
        ),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.background,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.person),
                  color: AppColors.buttonPrimary,
                ),
              ),
              SizedBox(width: 10),
              Column(
                children: [
                  Text("Jane Doe", style: AppTextStyles.title),
                  Text(
                    "Manage your account and privacy.",
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.edit_note,
                    color: AppColors.buttonPrimary,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
