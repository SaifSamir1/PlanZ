// lib/features/attendee/presentation/widgets/home/empty_events_widget.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/attandee/ui/home/ui/screens/my_invitations_screen.dart';

class EmptyEventsWidget extends StatelessWidget {
  const EmptyEventsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy_rounded, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'attendee.empty_events_title'.tr(),
              style: AppTextStyles.subtitle.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'attendee.empty_events_message'.tr(),
                style: AppTextStyles.caption.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MyInvitationsScreen(),
                  ),
                );
              },
              icon: Icon(
                Icons.mail_outline_rounded,
                color: AppColors.buttonPrimary,
              ),
              label: Text(
                'attendee.empty_events_view_invitations'.tr(),
                style: TextStyle(color: AppColors.buttonPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
