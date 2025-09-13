import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_stayls.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/auth/ui/widgets/attende_home_widgets/attende_home_screen_content.dart';

class AttendeHomeScreen extends StatelessWidget {
  const AttendeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Color(0xfff8f9fa),
        title: Center(
          child: Text(
            "EventFlow",
            style: AppTextStyles.headline1.copyWith(fontSize: 18),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_outlined,
              color: AppColors.buttonPrimary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Color(0xfff8f9fa),
              radius: 19,
              child: Center(
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.person),
                  iconSize: 19,
                  color: AppColors.buttonPrimary,
                  // color: AppColors.primaryDark,
                ),
              ),
            ),
          ),
        ],
      ),
      body: AttendeHomeScreenContent(),
    );
  }
}
