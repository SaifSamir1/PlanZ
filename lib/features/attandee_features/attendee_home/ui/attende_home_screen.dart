import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/attandee_features/attendee_home/ui/attende_home_widgets/attende_home_screen_content.dart';
import 'package:animate_do/animate_do.dart';

class AttendeHomeScreen extends StatelessWidget {
  const AttendeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar:CustomAppBar(title: "EventFlow",
      actions: [
        
        SlideInRight(
          duration: const Duration(milliseconds: 700),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_outlined,
              color: AppColors.buttonPrimary,
            ),
          ),
        ),
        SlideInRight(
          duration: const Duration(milliseconds: 800),
          delay: const Duration(milliseconds: 100),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: const Color(0xfff8f9fa),
              radius: 19,
              child: Center(
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.person),
                  iconSize: 19,
                  color: AppColors.buttonPrimary,
                ),
              ),
            ),
          ),
        ),
      
      ], 
      ),
      body: const AttendeHomeScreenContent(),
    );
  }
}
