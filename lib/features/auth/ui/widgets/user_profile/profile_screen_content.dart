import 'package:flutter/material.dart';
import 'package:plan_z/features/auth/ui/widgets/user_profile/logout_button_widget.dart'
    show LogoutButtonWidget;
import 'package:plan_z/features/auth/ui/widgets/user_profile/profile_info_card.dart';
import 'package:plan_z/features/auth/ui/widgets/user_profile/profile_setting_widget.dart';

class ProfileScreenContent extends StatelessWidget {
  const ProfileScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      child: Column(
        children: [
          ProfileInfoCard(),
          ProfileSettingWidget(icon: Icons.settings, title: "Account Settings"),
          ProfileSettingWidget(
            icon: Icons.payment_outlined,
            title: "Payment Methods",
          ),
          ProfileSettingWidget(icon: Icons.history, title: "Event History"),
          SizedBox(height: 10),
          LogoutButtonWidget(),
        ],
      ),
    );
  }
}
