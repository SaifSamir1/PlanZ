import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/features/new_owner_features/user_info/ui/widgets/logout_button_widget.dart'
    show LogoutButtonWidget;
import 'package:plan_z/features/new_owner_features/user_info/ui/widgets/profile_info_card.dart';
import 'package:plan_z/features/new_owner_features/user_info/ui/widgets/profile_setting_widget.dart';
import 'package:plan_z/features/new_owner_features/payment/ui/payment_and_invitation_screen.dart';

class ProfileScreenContent extends StatelessWidget {
  const ProfileScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            child: const ProfileInfoCard(),
          ),
          const SizedBox(height: 8),
          SlideInLeft(
            duration: const Duration(milliseconds: 700),
            delay: const Duration(milliseconds: 100),
            child: const ProfileSettingWidget(
              icon: Icons.settings,
              title: "Account Settings",
            ),
          ),
          SlideInRight(
            duration: const Duration(milliseconds: 700),
            delay: const Duration(milliseconds: 200),
            child: ProfileSettingWidget(
              icon: Icons.payment_outlined,
              title: "Payment Methods",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentAndInvitationsScreen(),
                  ),
                );
              },
            ),
          ),
          SlideInLeft(
            duration: const Duration(milliseconds: 700),
            delay: const Duration(milliseconds: 300),
            child: const ProfileSettingWidget(
              icon: Icons.history,
              title: "Event History",
            ),
          ),
          const SizedBox(height: 20),
          SlideInUp(
            duration: const Duration(milliseconds: 800),
            delay: const Duration(milliseconds: 400),
            child: const LogoutButtonWidget(),
          ),
        ],
      ),
    );
  }
}
