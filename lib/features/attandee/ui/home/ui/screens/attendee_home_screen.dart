// lib/features/attendee/presentation/screens/attendee_home_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/attandee/cubit/attendee_cubit.dart';
import 'package:plan_z/features/attandee/ui/home/ui/screens/attandee_notification.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/attendee_stats_card.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/quick_actions_section.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/upcoming_events_section.dart';
import 'package:plan_z/features/auth/data/models/user_manager.dart';
import 'package:plan_z/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:plan_z/features/auth/logic/auth_cubit/auth_state.dart';
import 'package:plan_z/features/on_boarding/ui/on_boarding_view.dart';
import 'package:plan_z/features/event_owners/chat_bot/cubits/chat_cubit.dart';
import 'package:plan_z/features/event_owners/chat_bot/ui/chat_bot_screen.dart';

class AttendeeHomeScreen extends StatefulWidget {
  const AttendeeHomeScreen({super.key});

  @override
  State<AttendeeHomeScreen> createState() => _AttendeeHomeScreenState();
}

class _AttendeeHomeScreenState extends State<AttendeeHomeScreen> {
  UserManager userManager = UserManager();

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  void _loadData() {
    final cubit = context.read<AttendeeCubit>();
    cubit.getAttendeeStats(userManager.currentUser!.id);
    cubit.getUpcomingEvents(userManager.currentUser!.id);
  }

  Future<void> _onRefresh() async {
    _loadData();
    // Wait for both states to complete
    await Future.delayed(const Duration(seconds: 1));
  }

  /// ============================================
  /// Logout Confirmation Dialog
  /// ============================================
  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "attendee.logout_confirmation".tr(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'attendee.logout_message'.tr(),
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'attendee.cancel'.tr(),
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _performLogout();
              },
              child: Text(
                'attendee.logout'.tr(),
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// ============================================
  /// Perform Logout
  /// ============================================
  void _performLogout() {
    debugPrint('🔴 [AttendeeHomeScreen._performLogout] Starting logout...');
    context.read<AuthCubit>().signOut();
  }

  /// ============================================
  /// Chat Floating Action Button
  /// ============================================
  Widget _buildChatFAB() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => ChatCubit(),
              child: const ChatScreen(),
            ),
          ),
        );
      },
      backgroundColor: AppColors.buttonPrimary,
      foregroundColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tooltip: 'attendee.chat_tooltip'.tr(),
      child: const Icon(Icons.chat_bubble_rounded, size: 26),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: _buildChatFAB(),
      appBar: CustomAppBar(
        title: "EventFlow",
        actions: [
          // Notification Icon
          SlideInRight(
            duration: const Duration(milliseconds: 700),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                );
              },

              icon: Icon(
                Icons.notifications_outlined,
                color: AppColors.buttonPrimary,
              ),
            ),
          ),
          // User Avatar - Logout on Tap
          SlideInRight(
            duration: const Duration(milliseconds: 800),
            delay: const Duration(milliseconds: 100),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: _showLogoutConfirmation,
                child: CircleAvatar(
                  backgroundColor: const Color(0xfff8f9fa),
                  radius: 19,
                  child: Icon(
                    Icons.person_outline,
                    color: AppColors.buttonPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listenWhen: (previous, current) => current is AuthSignOutSuccess,
        listener: (context, state) {
          if (state is AuthSignOutSuccess) {
            debugPrint(
              '✅ [BlocListener] Logout successful, navigating to OnBoarding',
            );
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
              (route) => false,
            );
          }
        },
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppColors.buttonPrimary,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Welcome Card
                _buildWelcomeCard(),
                const SizedBox(height: 32),

                // ✅ Introduction Section with Animated Text
                _buildIntroductionSection(),
                const SizedBox(height: 32),

                // Stats Card
                FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  child: AttendeeStatsCard(
                    attendeeId: userManager.currentUser!.id,
                  ),
                ),

                const SizedBox(height: 28),

                // Quick Actions
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 100),
                  child: const QuickActionsSection(),
                ),

                const SizedBox(height: 28),

                // Upcoming Events
                FadeInUp(
                  duration: const Duration(milliseconds: 700),
                  delay: const Duration(milliseconds: 200),
                  child: UpcomingEventsSection(
                    attendeeId: userManager.currentUser!.id,
                  ),
                ),

                const SizedBox(height: 150),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ============================================
  /// Welcome Card - Enhanced Professional Design
  /// ============================================
  Widget _buildWelcomeCard() {
    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.buttonPrimary,
              AppColors.buttonPrimary.withOpacity(0.75),
            ],
            stops: const [0.0, 1.0],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.buttonPrimary.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: AppColors.buttonPrimary.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'attendee.welcome_back'.tr(),
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userManager.userName ?? 'attendee.guest'.tr(),
                    style: AppTextStyles.title.copyWith(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'attendee.ready_to_discover'.tr(),
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.celebration_rounded,
                color: Colors.white.withOpacity(0.9),
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ============================================
  /// Introduction Section - Enhanced Professional Design
  /// ============================================
  Widget _buildIntroductionSection() {
    return FadeInUp(
      duration: const Duration(milliseconds: 500),
      delay: const Duration(milliseconds: 100),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.buttonPrimary.withOpacity(0.06),
              AppColors.buttonPrimary.withOpacity(0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.buttonPrimary.withOpacity(0.12),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.buttonPrimary.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Animated Title
            SizedBox(
              height: 48,
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    'attendee.discover_amazing_events'.tr(),
                    textStyle: AppTextStyles.title.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.buttonPrimary,
                      letterSpacing: -0.3,
                    ),
                    speed: const Duration(milliseconds: 45),
                  ),
                ],
                totalRepeatCount: 1,
                pause: const Duration(milliseconds: 500),
              ),
            ),
            const SizedBox(height: 14),
            // ✅ Description
            Text(
              'attendee.intro_description'.tr(),
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.6,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 18),
            // ✅ Features Grid
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.45,
              children: [
                _buildFeatureItem(
                  Icons.event_rounded,
                  'attendee.browse_events'.tr(),
                ),
                _buildFeatureItem(
                  Icons.favorite_border_rounded,
                  'attendee.save_favorites'.tr(),
                ),
                _buildFeatureItem(
                  Icons.people_rounded,
                  'attendee.connect'.tr(),
                ),
                _buildFeatureItem(
                  Icons.notifications_rounded,
                  'attendee.get_updates'.tr(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Feature Item Widget - Enhanced Professional Design
  Widget _buildFeatureItem(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.buttonPrimary.withOpacity(0.12),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.buttonPrimary.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.buttonPrimary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.buttonPrimary, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
