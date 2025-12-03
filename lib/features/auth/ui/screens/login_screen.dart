import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_button.dart';
import 'package:plan_z/features/app_owner/ui/screens/owner_dashboard_screen.dart';
import 'package:plan_z/features/attandee/ui/home/ui/screens/attendee_home_screen.dart';
import 'package:plan_z/features/auth/data/models/user_model.dart';
import 'package:plan_z/features/auth/ui/widgets/app_logo.dart';
import 'package:plan_z/features/auth/ui/widgets/login_form.dart';
import 'package:plan_z/features/auth/ui/widgets/login_welcom_method.dart';
import 'package:plan_z/features/auth/ui/widgets/sign_up_redirect.dart';
import 'package:plan_z/features/event_owners/event_owner_home/ui/screens/navigation_screen.dart';
import 'package:plan_z/features/vendor_features/vendor_home/ui/screens/vendor_home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:plan_z/features/auth/logic/auth_cubit/auth_state.dart';

class LoginScreen extends StatefulWidget {
  final UserType userType;
  const LoginScreen({super.key, required this.userType});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _attemptLogin() {
    if (_formKey.currentState!.validate()) {
      // استدعاء الـ Cubit لتسجيل الدخول
      context.read<AuthCubit>().signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
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
      case UserType.admin:
        destination = const OwnerDashboardScreen();
        break;
    }

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => destination));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          // معالجة حالات النجاح والفشل
          if (state is AuthSignInSuccess) {
            // التحقق من أن نوع المستخدم يطابق الشاشة
            _navigateBasedOnUserType(state.user);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'auth.welcome_back_user'.tr(args: [state.user.name]),
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is AuthSignInError) {
            // إظهار رسالة الخطأ
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
          final isLoading = state is AuthSignInLoading;

          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20.0),

                    // App Logo with animation
                    FadeInDown(
                      duration: const Duration(milliseconds: 400),
                      child: const AppLogo(),
                    ),

                    const SizedBox(height: 24.0),

                    // Welcome message with animation
                    FadeInLeft(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 100),
                      child: LoginWelcomeMessage(userType: widget.userType),
                    ),

                    const SizedBox(height: 32.0),

                    // Login form with animation
                    FadeInUp(
                      duration: const Duration(milliseconds: 800),
                      delay: const Duration(milliseconds: 200),
                      child: LoginForm(
                        emailController: _emailController,
                        passwordController: _passwordController,
                        formKey: _formKey,
                        userType: widget.userType,
                      ),
                    ),

                    const SizedBox(height: 24.0),

                    // Login button with loading state
                    FadeInUp(
                      duration: const Duration(milliseconds: 1200),
                      delay: const Duration(milliseconds: 400),
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : AppButton(
                              text: 'auth.login_btn'.tr(),
                              onPressed: _attemptLogin,
                            ),
                    ),

                    const SizedBox(height: 16.0),

                    // Sign up redirect with animation
                    FadeIn(
                      duration: const Duration(milliseconds: 1000),
                      delay: const Duration(milliseconds: 300),
                      child: SignUpRedirect(userType: widget.userType),
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
