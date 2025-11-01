// lib/features/attendee/presentation/widgets/home/quick_actions_section.dart

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/attandee/ui/home/ui/screens/my_events_screen.dart';
import 'package:plan_z/features/attandee/ui/home/ui/screens/my_invitations_screen.dart';

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
          child: Text(
            "Quick Actions",
            style: AppTextStyles.headline3,
          ),
        ),

        // Actions Row
        Row(
          children: [
            // Action 1: My Invitations
            Expanded(
              child: SlideInLeft(
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
            ),

            const SizedBox(width: 12),

            // Action 2: My Events
            Expanded(
              child: SlideInRight(
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
            ),
          ],
        ),
      ],
    );
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
    return SizedBox(
      height: 180,
      child: Card(
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
              padding: const EdgeInsets.all(16),
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
                    child: Icon(
                      icon,
                      color: AppColors.buttonPrimary,
                      size: 24,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Title
                  Text(
                    title,
                    style: AppTextStyles.subtitle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 4),

                  // Subtitle
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.grey[600],
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
      ),
    );
  }
}
