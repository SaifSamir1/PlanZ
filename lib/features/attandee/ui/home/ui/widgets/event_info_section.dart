// lib/features/attendee/presentation/widgets/invitation_details/event_info_section.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_invitation_model.dart';

class EventInfoSection extends StatelessWidget {
  final EventInvitationModel invitation;

  const EventInfoSection({super.key, required this.invitation});

  @override
  Widget build(BuildContext context) {
    // ✅ Use data directly from EventInvitationModel
    return _buildEventDetailsCard();
  }

  // Event Details Card (using EventInvitationModel data)
  Widget _buildEventDetailsCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Text(
              'attendee.invitations_section_event_details_title'.tr(),
              style: AppTextStyles.subtitle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Event Date
            _buildInfoRow(
              icon: Icons.calendar_today_rounded,
              label: 'attendee.invitations_section_date_label'.tr(),
              value: DateFormat(
                'EEE, MMM d, y • h:mm a',
                'en_US',
              ).format(invitation.eventDate),
              color: AppColors.buttonPrimary,
            ),

            const SizedBox(height: 12),

            // Event Location
            if (invitation.eventLocation != null &&
                invitation.eventLocation!.isNotEmpty)
              _buildInfoRow(
                icon: Icons.location_on_rounded,
                label: 'attendee.invitations_section_location_label'.tr(),
                value: invitation.eventLocation!,
                color: Colors.red,
              ),

            // City (if available)
            if (invitation.eventCity != null &&
                invitation.eventCity!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.location_city_rounded,
                label: 'attendee.invitations_section_city_label'.tr(),
                value: invitation.eventCity!,
                color: Colors.orange,
              ),
            ],

            // Address (if available)
            if (invitation.eventAddress != null &&
                invitation.eventAddress!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.home_rounded,
                label: 'attendee.invitations_section_address_label'.tr(),
                value: invitation.eventAddress!,
                color: Colors.purple,
              ),
            ],

            const SizedBox(height: 12),

            // Guest Count Allowed
            _buildInfoRow(
              icon: Icons.people_rounded,
              label: 'attendee.invitations_section_guests_allowed_label'.tr(),
              value:
                  "${invitation.guestCount} ${invitation.guestCount == 1 ? 'attendee.invitations_section_guest_singular'.tr() : 'attendee.invitations_section_guest_plural'.tr()}",
              color: Colors.green,
            ),

            if (invitation.confirmedGuestCount != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.check_circle_rounded,
                label: 'attendee.confirmed'.tr(),
                value:
                    "${invitation.confirmedGuestCount} ${invitation.confirmedGuestCount == 1 ? 'attendee.invitations_section_guest_singular'.tr() : 'attendee.invitations_section_guest_plural'.tr()}",
                color: Colors.blue,
              ),
            ],

            // Expected Guest Count (from Invitation)
            if (invitation.expectedGuestCount != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.group_rounded,
                label: 'attendee.invitations_section_total_expected_guests'
                    .tr(),
                value:
                    "${invitation.expectedGuestCount} ${'attendee.invitations_section_guest_plural'.tr()}",
                color: Colors.teal,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
