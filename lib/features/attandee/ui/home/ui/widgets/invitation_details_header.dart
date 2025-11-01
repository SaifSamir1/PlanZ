// lib/features/attendee/presentation/widgets/invitation_details/invitation_details_header.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/invitation_status_badge.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_invitation_model.dart';

class InvitationDetailsHeader extends StatelessWidget {
  final EventInvitationModel invitation;

  const InvitationDetailsHeader({
    super.key,
    required this.invitation,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Event Image (placeholder if not available)
            Container(
              color: AppColors.buttonPrimary.withOpacity(0.1),
              child: const Icon(
                Icons.event_rounded,
                size: 80,
                color: Colors.grey,
              ),
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // Event Name + Status Badge
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InvitationStatusBadge(status: invitation.status),
                  const SizedBox(height: 8),
                  Text(
                    invitation.eventName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
