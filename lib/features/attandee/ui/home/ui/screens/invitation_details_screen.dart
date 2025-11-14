// lib/features/attendee/presentation/screens/invitation_details_screen.dart

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/attandee/cubit/attendee_cubit.dart';
import 'package:plan_z/features/attandee/cubit/attendee_state.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/event_info_section.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/event_owner_info_section.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/guest_count_input.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/invitation_action_buttons.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/invitation_details_header.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/invitation_details_loading.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/personal_message_section.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/response_message_input.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_invitation_model.dart';

class InvitationDetailsScreen extends StatefulWidget {
  final String invitationId;

  const InvitationDetailsScreen({
    super.key,
    required this.invitationId,
  });

  @override
  State<InvitationDetailsScreen> createState() =>
      _InvitationDetailsScreenState();
}

class _InvitationDetailsScreenState extends State<InvitationDetailsScreen> {
  final TextEditingController _guestCountController = TextEditingController();
  final TextEditingController _responseMessageController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInvitation();
  }

  void _loadInvitation() {
    context.read<AttendeeCubit>().getInvitationById(widget.invitationId);
  }

  @override
  void dispose() {
    _guestCountController.dispose();
    _responseMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<AttendeeCubit, AttendeeState>(
        listener: (context, state) {
          // Handle Respond Success
          if (state is RespondToInvitationSuccess) {
            _showSuccessDialog();
          }

          // Handle Respond Error
          if (state is RespondToInvitationError) {
            _showErrorSnackbar(state.message);
          }
        },
        builder: (context, state) {
          // Loading State
          if (state is GetInvitationByIdLoading) {
            return const InvitationDetailsLoading();
          }

          // Error State
          if (state is GetInvitationByIdError) {
            return _buildErrorWidget(state.message);
          }

          // Success State
          if (state is GetInvitationByIdSuccess) {
            return _buildInvitationDetails(state.invitation);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildInvitationDetails(EventInvitationModel invitation) {
    // Set initial values for already responded invitations
    if (invitation.status != InvitationStatus.pending) {
      _guestCountController.text =
          invitation.confirmedGuestCount?.toString() ?? '';
      _responseMessageController.text = invitation.responseMessage ?? '';
    }

    return CustomScrollView(
      slivers: [
        // Header with Image
        InvitationDetailsHeader(invitation: invitation),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Info Section
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 100),
                  child: EventInfoSection(invitation: invitation),
                ),

                const SizedBox(height: 20),

                // Event Owner Info Section
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 200),
                  child: EventOwnerInfoSection(invitation: invitation),
                ),

                const SizedBox(height: 20),

                // Personal Message Section (if exists)
                if (invitation.personalMessage != null &&
                    invitation.personalMessage!.isNotEmpty)
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 300),
                    child: PersonalMessageSection(invitation: invitation),
                  ),

                if (invitation.personalMessage != null &&
                    invitation.personalMessage!.isNotEmpty)
                  const SizedBox(height: 20),

                // Guest Count Input (for pending invitations)
                if (invitation.status == InvitationStatus.pending)
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 400),
                    child: GuestCountInput(
                      controller: _guestCountController,
                      maxGuests: invitation.guestCount,
                    ),
                  ),

                if (invitation.status == InvitationStatus.pending)
                  const SizedBox(height: 16),

                // Response Message Input (optional)
                if (invitation.status == InvitationStatus.pending)
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 500),
                    child: ResponseMessageInput(
                      controller: _responseMessageController,
                    ),
                  ),

                if (invitation.status == InvitationStatus.pending)
                  const SizedBox(height: 24),

                // Action Buttons
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 600),
                  child: InvitationActionButtons(
                    invitation: invitation,
                    onAccept: () => _handleResponse(
                      invitation,
                      InvitationStatus.accepted,
                    ),
                    onReject: () => _handleResponse(
                      invitation,
                      InvitationStatus.rejected,
                    ),
                    onMaybe: () => _handleResponse(
                      invitation,
                      InvitationStatus.maybeAttending,
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _handleResponse(
    EventInvitationModel invitation,
    InvitationStatus status,
  ) {
    // Validate guest count for Accept/Maybe
    if (status == InvitationStatus.accepted ||
        status == InvitationStatus.maybeAttending) {
      final guestCount = int.tryParse(_guestCountController.text.trim());
      if (guestCount == null || guestCount <= 0) {
        _showErrorSnackbar("Please enter a valid guest count");
        return;
      }
      if (guestCount > invitation.guestCount) {
        _showErrorSnackbar(
          "Guest count cannot exceed ${invitation.guestCount}",
        );
        return;
      }
    }

    // Call Cubit
    context.read<AttendeeCubit>().respondToInvitation(
          invitationId: invitation.invitationId,
          status: status,
          confirmedGuestCount: int.tryParse(_guestCountController.text.trim()),
          responseMessage: _responseMessageController.text.trim().isEmpty
              ? null
              : _responseMessageController.text.trim(),
        );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              "Failed to load invitation",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadInvitation,
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.check_circle_rounded,
          size: 64,
          color: Colors.green,
        ),
        title: const Text("Success!"),
        content: const Text("Your response has been sent successfully."),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to invitations screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonPrimary,
            ),
            child: const Text("Done"),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
