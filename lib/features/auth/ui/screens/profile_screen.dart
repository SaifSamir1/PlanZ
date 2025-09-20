import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_stayls.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/auth/ui/widgets/user_profile/logout_button_widget.dart';
import 'package:plan_z/features/auth/ui/widgets/user_profile/profile_info_card.dart';
import 'package:plan_z/features/auth/ui/widgets/user_profile/profile_screen_content.dart';
import 'package:plan_z/features/auth/ui/widgets/user_profile/profile_setting_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Color(0xfff8f9fa),
        title: Center(
          child: Text(
            "Profile",
            style: AppTextStyles.headline1.copyWith(fontSize: 18),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: AppColors.background,
              child: IconButton(
                icon: Icon(Icons.person, color: AppColors.buttonPrimary),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: ProfileScreenContent(),
    );
  }
}
