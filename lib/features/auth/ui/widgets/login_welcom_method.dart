import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_stayls.dart';
import 'package:plan_z/features/auth/data/models/user_model.dart';

class LoginWelcomeMessage extends StatelessWidget {
  final UserType userType;

  const LoginWelcomeMessage({super.key, required this.userType});

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
          'Login to continue',
          style: AppTextStyles.subtitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _getWelcomeTitle() {
    switch (userType) {
      case UserType.vendor:
        return 'Welcome, Service Provider';
      case UserType.eventOwner:
        return 'Welcome, Event Organizer';
      case UserType.attendee:
        return 'Welcome, Attendee';
    }
  }
}
