import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_stayls.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Welcome to",
          style: AppTextStyles.headline1.copyWith(color: Colors.black),
        ),
        Text("EventFlow", style: AppTextStyles.headline1),
        SizedBox(height: 10),
        Text(
          "Seamless event management at your fingertips.",
          style: AppTextStyles.subtitle,
        ),
      ],
    );
  }
}
