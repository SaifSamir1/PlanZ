// lib/features/attendee/presentation/widgets/invitations/empty_invitations_widget.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_invitation_model.dart';

class EmptyInvitationsWidget extends StatelessWidget {
  final InvitationStatus? filterStatus;

  const EmptyInvitationsWidget({super.key, this.filterStatus});

  @override
  Widget build(BuildContext context) {
    final config = _getEmptyConfig(filterStatus);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(config.icon, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 24),
            Text(
              config.title,
              style: AppTextStyles.headline3.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              config.message,
              style: AppTextStyles.body.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (filterStatus == null)
              OutlinedButton.icon(
                onPressed: () {
                  // Navigate back to home
                  Navigator.pop(context);
                },
                icon: Icon(Icons.home_rounded, color: AppColors.buttonPrimary),
                label: Text(
                  'attendee.empty_invitations_go_home'.tr(),
                  style: TextStyle(color: AppColors.buttonPrimary),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.buttonPrimary),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _EmptyConfig _getEmptyConfig(InvitationStatus? status) {
    if (status == null) {
      return _EmptyConfig(
        icon: Icons.mail_outline_rounded,
        title: 'attendee.empty_invitations_none_title'.tr(),
        message: 'attendee.empty_invitations_none_message'.tr(),
      );
    }

    switch (status) {
      case InvitationStatus.pending:
        return _EmptyConfig(
          icon: Icons.schedule_rounded,
          title: 'attendee.empty_invitations_pending_title'.tr(),
          message: 'attendee.empty_invitations_pending_message'.tr(),
        );
      case InvitationStatus.accepted:
        return _EmptyConfig(
          icon: Icons.check_circle_outline_rounded,
          title: 'attendee.empty_invitations_accepted_title'.tr(),
          message: 'attendee.empty_invitations_accepted_message'.tr(),
        );
      case InvitationStatus.rejected:
        return _EmptyConfig(
          icon: Icons.cancel_outlined,
          title: 'attendee.empty_invitations_rejected_title'.tr(),
          message: 'attendee.empty_invitations_rejected_message'.tr(),
        );
      case InvitationStatus.maybeAttending:
        return _EmptyConfig(
          icon: Icons.help_outline_rounded,
          title: 'attendee.empty_invitations_maybe_title'.tr(),
          message: 'attendee.empty_invitations_maybe_message'.tr(),
        );
    }
  }
}

class _EmptyConfig {
  final IconData icon;
  final String title;
  final String message;

  _EmptyConfig({
    required this.icon,
    required this.title,
    required this.message,
  });
}
