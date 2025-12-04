// lib/features/attendee/presentation/widgets/invitations/invitation_card.dart

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/invitation_status_badge.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_invitation_model.dart';

class InvitationCard extends StatelessWidget {
  final EventInvitationModel invitation;
  final VoidCallback onTap;

  const InvitationCard({
    super.key,
    required this.invitation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 1,
        color: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Event Name + Status Badge
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        invitation.eventName,
                        style: AppTextStyles.subtitle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    InvitationStatusBadge(status: invitation.status),
                  ],
                ),

                const SizedBox(height: 12),

                // Event Owner
                _buildInfoRow(
                  icon: Icons.person_outline_rounded,
                  text: 'attendee.invitation_card_hosted_by'.tr(
                    args: [invitation.eventOwnerName],
                  ),
                ),

                const SizedBox(height: 6),

                // Sent Date
                _buildInfoRow(
                  icon: Icons.access_time_rounded,
                  text: 'attendee.invitation_card_sent_prefix'.tr(
                    args: [_formatDate(invitation.sentAt)],
                  ),
                ),

                // Personal Message (if exists)
                if (invitation.personalMessage != null &&
                    invitation.personalMessage!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.buttonPrimary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.buttonPrimary.withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.message_outlined,
                          size: 16,
                          color: AppColors.buttonPrimary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            invitation.personalMessage!,
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.grey[700],
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(color: Colors.grey[600]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'attendee.invitation_time_minutes_ago'.tr(
          args: [difference.inMinutes.toString()],
        );
      }
      return 'attendee.invitation_time_hours_ago'.tr(
        args: [difference.inHours.toString()],
      );
    } else if (difference.inDays == 1) {
      return 'attendee.invitation_time_yesterday'.tr();
    } else if (difference.inDays < 7) {
      return 'attendee.invitation_time_days_ago'.tr(
        args: [difference.inDays.toString()],
      );
    } else {
      return DateFormat(
        'attendee.invitation_time_date_format'.tr(),
      ).format(date);
    }
  }
}
