import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_button.dart';
import 'package:plan_z/features/auth/data/models/user_model.dart';
import 'package:plan_z/features/auth/ui/widgets/app_logo.dart';
import 'package:plan_z/features/auth/ui/widgets/login_redirect.dart';
import 'package:plan_z/features/auth/ui/widgets/sign_up_form.dart';
import 'package:plan_z/features/auth/ui/widgets/welcom_message.dart';

class SignUpScreen extends StatelessWidget {
  final UserType userType;

  const SignUpScreen({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                // الشعار مع تأثير حركي
                FadeInDown(
                  duration: const Duration(milliseconds: 600),
                  child: const AppLogo(),
                ),
                const SizedBox(height: 24.0),
                // الرسالة الترحيبية مع تأثير حركي
                FadeInLeft(
                  duration: const Duration(milliseconds: 800),
                  delay: const Duration(milliseconds: 100),
                  child: WelcomeMessage(userType: userType),
                ),
                const SizedBox(height: 32.0),
                // نموذج التسجيل مع تأثير حركي
                FadeInUp(
                  duration: const Duration(milliseconds: 1000),
                  delay: const Duration(milliseconds: 200),
                  child: SignUpForm(userType: userType),
                ),
                const SizedBox(height: 16.0),
                // الانتقال لتسجيل الدخول مع تأثير حركي
                FadeIn(
                  duration: const Duration(milliseconds: 1200),
                  delay: const Duration(milliseconds: 400),
                  child: LoginRedirect(userType: userType),
                ),
                const SizedBox(height: 24.0),
                // زر إنشاء الحساب مع تأثير حركي
                FadeInUp(
                  duration: const Duration(milliseconds: 1400),
                  delay: const Duration(milliseconds: 600),
                  child: AppButton(
                    text: 'Create Account',
                    onPressed: () {
                      // منطق إنشاء الحساب
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
