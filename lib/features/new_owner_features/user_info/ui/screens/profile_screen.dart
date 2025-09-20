import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_stayls.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/new_owner_features/user_info/ui/widgets/profile_screen_content.dart';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/theming/text_stayls.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: const ProfileScreenContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xfff8f9fa),
      elevation: 0,
      centerTitle: true,
      title: FadeInDown(
        duration: const Duration(milliseconds: 600),
        child: Text(
          "Profile",
          style: AppTextStyles.headline1.copyWith(fontSize: 18),
        ),
      ),
      actions: [
        SlideInRight(
          duration: const Duration(milliseconds: 700),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: AppColors.background,
              child: IconButton(
                icon: Icon(Icons.person, color: AppColors.buttonPrimary),
                onPressed: () {},
              ),
            ),
          ),
        ),
      ],
    );
  }
}
