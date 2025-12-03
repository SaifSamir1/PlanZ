import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/features/auth/data/models/user_model.dart';

class WelcomeMessage extends StatelessWidget {
  final UserType userType;

  const WelcomeMessage({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _getWelcomeTitle(),
          style: AppTextStyles.headline2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8.0),
        Text(
          'auth.create_account_subtitle'.tr(),
          style: AppTextStyles.subtitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _getWelcomeTitle() {
    switch (userType) {
      case UserType.vendor:
        return 'auth.welcome_vendor'.tr();
      case UserType.eventOwner:
        return 'auth.welcome_event_owner'.tr();
      case UserType.attendee:
        return 'auth.welcome_attendee'.tr();
      case UserType.admin:
        return 'auth.welcome_admin'.tr();
    }
  }
}
