import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_stayls.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/auth/data/models/user_model.dart';
import 'package:plan_z/features/auth/ui/screens/sign_up_screen.dart';

class SignUpRedirect extends StatelessWidget {
  final UserType userType;

  const SignUpRedirect({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?", style: AppTextStyles.caption),
        const SizedBox(width: 4.0),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpScreen(userType: userType),
              ),
            );
          },
          child: Text(
            'Sign Up',
            style:
                AppTextStyles.withColor(
                  AppTextStyles.caption,
                  AppColors.primaryGold,
                ).copyWith(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
          ),
        ),
      ],
    );
  }
}
