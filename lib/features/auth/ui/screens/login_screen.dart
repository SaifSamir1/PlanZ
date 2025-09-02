import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_button.dart';
import 'package:plan_z/features/auth/data/models/user_model.dart';
import 'package:plan_z/features/auth/ui/widgets/app_logo.dart';
import 'package:plan_z/features/auth/ui/widgets/login_form.dart';
import 'package:plan_z/features/auth/ui/widgets/login_welcom_method.dart';
import 'package:plan_z/features/auth/ui/widgets/sign_up_redirect.dart';

class LoginScreen extends StatelessWidget {
  final UserType userType;

  const LoginScreen({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                // App Logo with animation
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: const AppLogo(),
                ),
                const SizedBox(height: 24.0),
                // Welcome message with animation
                FadeInLeft(
                  duration: const Duration(milliseconds: 1000),
                  delay: const Duration(milliseconds: 200),
                  child: LoginWelcomeMessage(userType: userType),
                ),
                const SizedBox(height: 32.0),
                // Login form with animation
                FadeInUp(
                  duration: const Duration(milliseconds: 1200),
                  delay: const Duration(milliseconds: 400),
                  child: LoginForm(userType: userType),
                ),
                const SizedBox(height: 24.0),
                const SizedBox(height: 16.0),
                // Sign up redirect with animation
                FadeIn(
                  duration: const Duration(milliseconds: 1600),
                  delay: const Duration(milliseconds: 800),
                  child: SignUpRedirect(userType: userType),
                ),
                // Login button with animation
                FadeInUp(
                  duration: const Duration(milliseconds: 1400),
                  delay: const Duration(milliseconds: 600),
                  child: AppButton(
                    text: 'Login',
                    onPressed: () {
                      // Login logic here
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
