import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_text_form.dart';
import 'package:plan_z/features/auth/data/models/user_model.dart';
import 'package:plan_z/features/auth/ui/widgets/password_text_form_filed.dart';

class SignUpForm extends StatefulWidget {
  final UserType userType;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController ;
  final TextEditingController emailController ;
  final TextEditingController phoneController ;
  final TextEditingController passwordController ;
  final TextEditingController confirmPasswordController ;


  const SignUpForm({super.key, required this.userType, required this.formKey, required this.nameController, required this.emailController, required this.phoneController, required this.passwordController, required this.confirmPasswordController});

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
            hintText: 'Full Name',
            controller: widget.nameController,
            prefixIcon: const Icon(Icons.person, color: AppColors.textHint),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          // Email field
          AppTextField(
            hintText: 'Email',
            controller: widget.emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email, color: AppColors.textHint),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          // Phone field
          AppTextField(
            hintText: 'Phone Number',
            controller: widget.phoneController,
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone, color: AppColors.textHint),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
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
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          // Confirm password field
          AppPasswordTextField(
            hintText: 'Confirm Password',
            controller: widget.confirmPasswordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != widget.passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
