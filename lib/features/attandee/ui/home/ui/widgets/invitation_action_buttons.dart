// lib/features/attendee/presentation/widgets/invitation_details/invitation_action_buttons.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/features/attandee/cubit/attendee_cubit.dart';
import 'package:plan_z/features/attandee/cubit/attendee_state.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_invitation_model.dart';

class InvitationActionButtons extends StatelessWidget {
  final EventInvitationModel invitation;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onMaybe;

  const InvitationActionButtons({
    super.key,
    required this.invitation,
    required this.onAccept,
    required this.onReject,
    required this.onMaybe,
  });

  @override
  Widget build(BuildContext context) {
    // If already responded, show response status
    if (invitation.status != InvitationStatus.pending) {
      return _buildResponseStatus();
    }

    // If pending, show action buttons
    return BlocBuilder<AttendeeCubit, AttendeeState>(
      builder: (context, state) {
        final isLoading = state is RespondToInvitationLoading;

        return Column(
          children: [
            // Accept Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : onAccept,
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.check_circle_rounded),
                label: Text(isLoading ? "Sending..." : "Accept Invitation"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Reject & Maybe Row
            Row(
              children: [
                // Reject Button
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: isLoading ? null : onReject,
                      icon: const Icon(Icons.cancel_rounded),
                      label: const Text("Reject"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Maybe Button
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: isLoading ? null : onMaybe,
                      icon: const Icon(Icons.help_outline_rounded),
                      label: const Text("Maybe"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        side: const BorderSide(color: Colors.blue, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildResponseStatus() {
    final config = _getStatusConfig(invitation.status);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: config.color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            config.icon,
            color: config.color,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            config.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: config.color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            config.message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          if (invitation.responseMessage != null &&
              invitation.responseMessage!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.message_rounded,
                    size: 16,
                    color: config.color,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      invitation.responseMessage!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  _ResponseStatusConfig _getStatusConfig(InvitationStatus status) {
    switch (status) {
      case InvitationStatus.accepted:
        return _ResponseStatusConfig(
          icon: Icons.check_circle_rounded,
          color: Colors.green,
          title: "Invitation Accepted",
          message: "You have confirmed your attendance to this event",
        );
      case InvitationStatus.rejected:
        return _ResponseStatusConfig(
          icon: Icons.cancel_rounded,
          color: Colors.red,
          title: "Invitation Rejected",
          message: "You have declined this invitation",
        );
      case InvitationStatus.maybeAttending:
        return _ResponseStatusConfig(
          icon: Icons.help_outline_rounded,
          color: Colors.blue,
          title: "Maybe Attending",
          message: "You marked this invitation as maybe",
        );
      case InvitationStatus.pending:
        return _ResponseStatusConfig(
          icon: Icons.schedule_rounded,
          color: Colors.orange,
          title: "Pending Response",
          message: "Please respond to this invitation",
        );
    }
  }
}

class _ResponseStatusConfig {
  final IconData icon;
  final Color color;
  final String title;
  final String message;

  _ResponseStatusConfig({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
  });
}
