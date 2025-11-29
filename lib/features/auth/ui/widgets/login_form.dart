import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_text_form.dart';
import 'package:plan_z/features/auth/data/models/user_model.dart';
import 'package:plan_z/features/auth/ui/widgets/password_text_form_filed.dart';

class LoginForm extends StatefulWidget {
  final UserType userType;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const LoginForm({
    super.key,
    required this.userType,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  // ignore: library_private_types_in_public_api
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          // Email field
          AppTextField(
            hintText: 'auth.email_address'.tr(),
            controller: widget.emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email, color: AppColors.textHint),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'auth.enter_email'.tr();
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'auth.enter_valid_email'.tr();
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          // Password field
          AppPasswordTextField(
            controller: widget.passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'auth.enter_password'.tr();
              }
              return null;
            },
          ),
          const SizedBox(height: 8.0),
          // Forgot password link
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'auth.forgot_password'.tr(),
              style:
                  AppTextStyles.withColor(
                    AppTextStyles.caption,
                    AppColors.primaryGold,
                  ).copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primaryGold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
