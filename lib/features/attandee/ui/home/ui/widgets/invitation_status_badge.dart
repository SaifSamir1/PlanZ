// lib/features/attendee/presentation/widgets/invitations/invitation_status_badge.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_invitation_model.dart';

class InvitationStatusBadge extends StatelessWidget {
  final InvitationStatus status;

  const InvitationStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: config.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            config.icon,
            size: 14,
            color: config.color,
          ),
          const SizedBox(width: 4),
          Text(
            config.label,
            style: AppTextStyles.caption.copyWith(
              color: config.color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(InvitationStatus status) {
    switch (status) {
      case InvitationStatus.pending:
        return _StatusConfig(
          label: "Pending",
          icon: Icons.schedule_rounded,
          color: Colors.orange,
        );
      case InvitationStatus.accepted:
        return _StatusConfig(
          label: "Accepted",
          icon: Icons.check_circle_rounded,
          color: Colors.green,
        );
      case InvitationStatus.rejected:
        return _StatusConfig(
          label: "Rejected",
          icon: Icons.cancel_rounded,
          color: Colors.red,
        );
      case InvitationStatus.maybeAttending:
        return _StatusConfig(
          label: "Maybe",
          icon: Icons.help_outline_rounded,
          color: Colors.blue,
        );
    }
  }
}

class _StatusConfig {
  final String label;
  final IconData icon;
  final Color color;

  _StatusConfig({
    required this.label,
    required this.icon,
    required this.color,
  });
}
