import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/features/event_owners/user_info/ui/widgets/logout_button_widget.dart'
    show LogoutButtonWidget;
import 'package:plan_z/features/event_owners/user_info/ui/widgets/profile_info_card.dart';
import 'package:plan_z/features/event_owners/user_info/ui/widgets/profile_setting_widget.dart';
import 'package:plan_z/features/event_owners/payment/ui/payment_and_invitation_screen.dart';

class ProfileScreenContent extends StatelessWidget {
  const ProfileScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ✅ Profile Info Card
        FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: const ProfileInfoCard(),
        ),
        const SizedBox(height: 24),

        // ✅ Settings Section Title
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: Text(
              'Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // ✅ Account Settings
        SlideInLeft(
          duration: const Duration(milliseconds: 700),
          delay: const Duration(milliseconds: 100),
          child: const ProfileSettingWidget(
            icon: Icons.settings,
            title: "Account Settings",
          ),
        ),

        // // ✅ Payment Methods
        // SlideInRight(
        //   duration: const Duration(milliseconds: 700),
        //   delay: const Duration(milliseconds: 200),
        //   child: ProfileSettingWidget(
        //     icon: Icons.payment_outlined,
        //     title: "Payment Methods",
        //     onTap: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => const PaymentAndInvitationsScreen(),
        //         ),
        //       );
        //     },
        //   ),
        // ),

        const SizedBox(height: 32),

        // ✅ Logout Button
        SlideInUp(
          duration: const Duration(milliseconds: 800),
          delay: const Duration(milliseconds: 400),
          child: const LogoutButtonWidget(),
        ),

        const SizedBox(height: 150),
      ],
    );
  }
}
