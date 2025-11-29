import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_text_form.dart';
import 'package:plan_z/features/auth/data/models/user_model.dart';
import 'package:plan_z/features/auth/ui/widgets/password_text_form_filed.dart';

class SignUpForm extends StatefulWidget {
  final UserType userType;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const SignUpForm({
    super.key,
    required this.userType,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          // Name field
          AppTextField(
            hintText: 'auth.full_name'.tr(),
            controller: widget.nameController,
            prefixIcon: const Icon(Icons.person, color: AppColors.textHint),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'auth.enter_full_name'.tr();
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          // Email field
          AppTextField(
            hintText: 'auth.email'.tr(),
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
          // Phone field
          AppTextField(
            hintText: 'auth.phone_number'.tr(),
            controller: widget.phoneController,
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone, color: AppColors.textHint),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'auth.enter_phone'.tr();
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
              if (value.length < 6) {
                return 'auth.password_min_length'.tr();
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          // Confirm password field
          AppPasswordTextField(
            hintText: 'auth.confirm_password'.tr(),
            controller: widget.confirmPasswordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'auth.confirm_password_req'.tr();
              }
              if (value != widget.passwordController.text) {
                return 'auth.passwords_do_not_match'.tr();
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
