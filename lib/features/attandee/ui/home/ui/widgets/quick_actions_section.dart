// lib/features/attendee/presentation/widgets/home/quick_actions_section.dart

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/attandee/ui/home/ui/screens/my_events_screen.dart';
import 'package:plan_z/features/attandee/ui/home/ui/screens/my_invitations_screen.dart';
import 'package:plan_z/core/services/notification_service.dart';
import 'package:plan_z/features/auth/data/models/user_manager.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text("Quick Actions", style: AppTextStyles.headline3),
        ),

        // Actions Grid
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1, // Increased to prevent overflow
          children: [
            // Action 1: My Invitations
            SlideInLeft(
              duration: const Duration(milliseconds: 700),
              delay: const Duration(milliseconds: 200),
              child: _QuickActionCard(
                icon: Icons.mail_outline_rounded,
                title: "My Invitations",
                subtitle: "View & respond to invites",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MyInvitationsScreen(),
                    ),
                  );
                },
              ),
            ),

            // Action 2: My Events
            SlideInRight(
              duration: const Duration(milliseconds: 700),
              delay: const Duration(milliseconds: 300),
              child: _QuickActionCard(
                icon: Icons.event_rounded,
                title: "My Events",
                subtitle: "See accepted events",
                onTap: () {
                  // Navigate to My Events Screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const MyEventsScreen(),
                    ),
                  );
                },
              ),
            ),

            // Action 3: Test Notification
            SlideInLeft(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 200),
              child: _QuickActionCard(
                icon: Icons.notifications_active,
                title: "Test Notification",
                subtitle: "Send test notification",
                onTap: () => _testNotification(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// ============================================
  /// Test Notification Method
  /// ============================================
  Future<void> _testNotification(BuildContext context) async {
    final userId = UserManager().userId;

    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('❌ User ID not found')));
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('📤 Sending Test Notification'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Sending notification to your account...'),
          ],
        ),
      ),
    );

    try {
      // 1. Send notification to Firestore
      await NotificationService.sendNotification(
        receiverId: userId,
        receiverRole: 'attendee',
        title: '✅ Test Notification',
        body: 'This is a test notification from PlanZ app!',
        type: 'test',
        data: {
          'testId': DateTime.now().millisecondsSinceEpoch.toString(),
          'message': 'Test notification successfully sent!',
        },
        // fcmToken: '...', // Optional: Add token if needed for specific testing
      );

      // 2. Show local notification immediately (for instant feedback)
      await NotificationService.showLocalNotification(
        title: '✅ Test Notification',
        body: 'This is a test notification from PlanZ app!',
      );

      // Close loading dialog
      if (context.mounted) Navigator.pop(context);

      // Show success snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Notification sent successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
      debugPrint('✅ [Test Notification] Sent successfully to $userId');
    } catch (e) {
      // Close loading dialog
      if (context.mounted) Navigator.pop(context);

      // Show error snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      debugPrint('❌ [Test Notification] Error: $e');
    }
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon Container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.buttonPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.buttonPrimary, size: 24),
                ),

                const SizedBox(height: 7),

                // Title
                Text(
                  title,
                  style: AppTextStyles.subtitle.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 12
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 4),

                // Subtitle
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.grey[600],
                    fontSize: 10
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
