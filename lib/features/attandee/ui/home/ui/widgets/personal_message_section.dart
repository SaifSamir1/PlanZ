// lib/features/attendee/presentation/widgets/invitation_details/personal_message_section.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_invitation_model.dart';

class PersonalMessageSection extends StatelessWidget {
  final EventInvitationModel invitation;

  const PersonalMessageSection({
    super.key,
    required this.invitation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.buttonPrimary.withOpacity(0.3), width: 1),
      ),
      color: AppColors.buttonPrimary.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.format_quote_rounded,
                  color: AppColors.buttonPrimary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  "Personal Message",
                  style: AppTextStyles.subtitle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.buttonPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              invitation.personalMessage!,
              style: AppTextStyles.body.copyWith(
                fontStyle: FontStyle.italic,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
