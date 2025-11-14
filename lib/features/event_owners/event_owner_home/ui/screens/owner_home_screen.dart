// lib/features/event_owner/presentation/screens/owner_home_screen.dart

import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/auth/data/models/user_manager.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_model_enum.dart';
import 'package:plan_z/features/event_owners/create_event_screen/ui/screens/my_events_list_screen.dart';
import 'package:plan_z/features/event_owners/event_owner_home/ui/screens/services_screen.dart';
import 'owner_notification_screen.dart';

class OwnerHomeScreen extends StatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  State<OwnerHomeScreen> createState() => _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends State<OwnerHomeScreen> {
  late GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

  @override
  void initState() {
    super.initState();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  }

  /// ✅ Refresh the events list
  Future<void> _onRefresh() async {
    debugPrint('🔃 User initiated refresh');
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Home',
        actions: [
          // Notification Icon
          SlideInRight(
            duration: const Duration(milliseconds: 700),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 24,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OwnerNotificationScreen(),
                  ),
                );
              },
            ),
          ),
          // Profile Avatar
          SlideInRight(
            duration: const Duration(milliseconds: 800),
            delay: const Duration(milliseconds: 100),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
              ),
              child: CircleAvatar(
                radius: 18,
                child: Text(
                  UserManager().getUserInitials(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _onRefresh,
        color: AppColors.primaryGold,
        backgroundColor: Colors.white,
        strokeWidth: 2.5,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeCard(),
              const SizedBox(height: 28),
              _buildIntroductionSection(),
              const SizedBox(height: 28),
              _buildQuickActionsSection(context),
              const SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }

  /// ============================================
  /// Welcome Card Section
  /// ============================================
  Widget _buildWelcomeCard() {
    final userName = UserManager().userName ?? 'User';

    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $userName! 👋',
                    style: AppTextStyles.headline3,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Welcome back to PlanZ.',
                    style: TextStyle(
                      color: AppColors.primaryDark.withOpacity(0.6),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
              ),
              child: CircleAvatar(
                radius: 22,
                child: Text(
                  UserManager().getUserInitials(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ============================================
  /// Introduction Section with Animated Text
  /// ============================================
  Widget _buildIntroductionSection() {
    return FadeInUp(
      duration: const Duration(milliseconds: 700),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryGold.withOpacity(0.1),
              AppColors.primaryGold.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryGold.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animated Title
            SizedBox(
              height: 50,
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    'Welcome to Event Owner Dashboard',
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                    speed: const Duration(milliseconds: 50),
                  ),
                ],
                totalRepeatCount: 1,
                pause: const Duration(milliseconds: 500),
              ),
            ),
            const SizedBox(height: 12),
            // Description
            Text(
              'Manage your events, track payments, and coordinate with vendors all in one place. Create memorable events with ease.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.primaryDark.withOpacity(0.7),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),
            // Features Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.2,
              children: [
                _buildFeatureItem(Icons.event_note, 'Create Events'),
                _buildFeatureItem(Icons.payment, 'Track Payments'),
                _buildFeatureItem(Icons.people, 'Manage Vendors'),
                _buildFeatureItem(Icons.analytics, 'View Analytics'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ============================================
  /// Feature Item Widget
  /// ============================================
  Widget _buildFeatureItem(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primaryGold.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.primaryGold,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryDark,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Quick Actions Section
  /// ============================================
  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: Text("Quick Actions", style: AppTextStyles.headline3),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
          children: [
            // My Events Action
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyEventsListScreen(),
                  ),
                );
              },
              child: SlideInLeft(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 100),
                child: _quickAction(
                  Icons.calendar_month_outlined,
                  "My Events",
                  "View and manage all your events",
                ),
              ),
            ),
            // Services Action
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ServicesScreen(),
                  ),
                );
              },
              child: SlideInRight(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 100),
                child: _quickAction(
                  Icons.miscellaneous_services_outlined,
                  "Services",
                  "Browse available services",
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }


  /// ============================================
  /// Quick Action Card Widget
  /// ============================================
  Widget _quickAction(IconData icon, String label, [String? description]) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ Icon with gradient background
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryGold.withOpacity(0.15),
                    AppColors.primaryGold.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryGold.withOpacity(0.2),
                ),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryGold,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            // ✅ Label
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primaryDark,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // ✅ Description (optional)
            if (description != null) ...[
              const SizedBox(height: 6),
              Text(
                description,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryDark.withOpacity(0.6),
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }


  /// ============================================
  /// Helper Methods
  /// ============================================
  Color _getStatusColor(EventStatus status) {
    switch (status) {
      case EventStatus.draft:
        return Colors.grey;
      case EventStatus.pending:
        return Colors.orange;
      case EventStatus.approved:
        return Colors.blue;
      case EventStatus.partiallyPaid:
        return Colors.amber;
      case EventStatus.confirmed:
        return Colors.green;
      case EventStatus.cancelled:
        return Colors.red;
      case EventStatus.completed:
        return Colors.teal;
    }
  }

  String _getStatusLabel(EventStatus status) {
    switch (status) {
      case EventStatus.draft:
        return 'Draft';
      case EventStatus.pending:
        return 'Pending';
      case EventStatus.approved:
        return 'Approved';
      case EventStatus.partiallyPaid:
        return 'Partial';
      case EventStatus.confirmed:
        return 'Confirmed';
      case EventStatus.cancelled:
        return 'Cancelled';
      case EventStatus.completed:
        return 'Completed';
    }
  }
}
