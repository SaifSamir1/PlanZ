import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_button.dart';
import 'package:plan_z/features/attandee/ui/home/ui/screens/attendee_home_screen.dart';
import 'package:plan_z/features/auth/data/models/user_model.dart';
import 'package:plan_z/features/auth/ui/widgets/app_logo.dart';
import 'package:plan_z/features/auth/ui/widgets/login_redirect.dart';
import 'package:plan_z/features/auth/ui/widgets/sign_up_form.dart';
import 'package:plan_z/features/auth/ui/widgets/welcom_message.dart';
import 'package:plan_z/features/vendor_features/vendor_home/ui/screens/vendor_home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:plan_z/features/auth/logic/auth_cubit/auth_state.dart';
import 'package:plan_z/features/event_owners/event_owner_home/ui/screens/navigation_screen.dart';

class SignUpScreen extends StatefulWidget {
  final UserType userType;
  const SignUpScreen({super.key, required this.userType});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _attemptSignUp() {
    if (_formKey.currentState!.validate()) {
      // التحقق من تطابق كلمات المرور
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // استدعاء الـ Cubit لإنشاء حساب
      context.read<AuthCubit>().signUp(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            userType: widget.userType,
            phoneNumber: _phoneController.text.trim().isEmpty 
                ? null 
                : _phoneController.text.trim(),
          );
    }
  }

  void _navigateBasedOnUserType(UserModel user) {
    Widget destination;

    switch (user.userType) {
      case UserType.vendor:
        destination = const VendorHomeScreen();
        break;
      case UserType.eventOwner:
        destination = const NavigationScreen();
        break;
      case UserType.attendee:
        destination = const AttendeeHomeScreen();
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unknown user type'),
            backgroundColor: Colors.red,
          ),
        );
        return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSignUpSuccess) {
            _navigateBasedOnUserType(state.user);
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Welcome, ${state.user.name}!'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is AuthSignUpError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthSignUpLoading;

          return SafeArea(
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
                      child: WelcomeMessage(userType: widget.userType),
                    ),
                    
                    const SizedBox(height: 32.0),
                    
                    // نموذج التسجيل مع تأثير حركي
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      delay: const Duration(milliseconds: 200),
                      child: SignUpForm(
                        nameController: _nameController,
                        emailController: _emailController,
                        phoneController: _phoneController,
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                        userType: widget.userType,
                        formKey: _formKey,
                      ),
                    ),
                    
                    const SizedBox(height: 16.0),
                    
                    // الانتقال لتسجيل الدخول مع تأثير حركي
                    FadeIn(
                      duration: const Duration(milliseconds: 1200),
                      delay: const Duration(milliseconds: 400),
                      child: LoginRedirect(userType: widget.userType),
                    ),
                    
                    const SizedBox(height: 24.0),
                    
                    // زر إنشاء الحساب مع تأثير حركي
                    FadeInUp(
                      duration: const Duration(milliseconds: 1400),
                      delay: const Duration(milliseconds: 600),
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : AppButton(
                              text: 'Create Account',
                              onPressed: _attemptSignUp,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
