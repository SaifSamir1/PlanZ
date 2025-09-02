import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_stayls.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/auth/data/models/user_model.dart';

class LoginRedirect extends StatelessWidget {
  final UserType userType;

  const LoginRedirect({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Already have an account?', style: AppTextStyles.caption),
        const SizedBox(width: 4.0),
        GestureDetector(
          onTap: () {
            // Will navigate to login screen later
            // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(userType: userType)));
          },
          child: Text(
            'Login',
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
