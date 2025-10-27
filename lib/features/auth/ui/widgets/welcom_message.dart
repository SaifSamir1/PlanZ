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
          'Create an account to get started!',
          style: AppTextStyles.subtitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _getWelcomeTitle() {
    switch (userType) {
      case UserType.vendor:
        return 'Welcome Vendor';
      case UserType.eventOwner:
        return 'Welcome Event Owner';
      case UserType.attendee:
        return 'Welcome Attendee';
      case UserType.admin:
        return 'Welcome Admin';
    }
  }
}
