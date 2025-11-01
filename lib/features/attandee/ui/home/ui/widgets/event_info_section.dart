// lib/features/attendee/presentation/widgets/invitation_details/event_info_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/cubits/create_event_cubit/create_event_cubit.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/cubits/create_event_cubit/create_event_state.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_invitation_model.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_model.dart';

class EventInfoSection extends StatefulWidget {
  final EventInvitationModel invitation;

  const EventInfoSection({
    super.key,
    required this.invitation,
  });

  @override
  State<EventInfoSection> createState() => _EventInfoSectionState();
}

class _EventInfoSectionState extends State<EventInfoSection> {
  @override
  void initState() {
    super.initState();
    // Fetch Event Details using EventOwnerCubit
    context.read<EventOwnerCubit>().getEventById(widget.invitation.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventOwnerCubit, EventOwnerState>(
      builder: (context, state) {
        // Loading State
        if (state is GetEventByIdLoading) {
          return _buildLoadingCard();
        }

        // Error State
        if (state is GetEventByIdError) {
          return _buildErrorCard(state.message);
        }

        // Success State
        if (state is GetEventByIdSuccess) {
          return _buildEventDetailsCard(state.event);
        }

        // Default State (shouldn't happen but just in case)
        return _buildLoadingCard();
      },
    );
  }

  // Loading Card
  Widget _buildLoadingCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  // Error Card
  Widget _buildErrorCard(String message) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.red, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 8),
            Text(
              "Failed to load event details",
              style: AppTextStyles.subtitle.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: AppTextStyles.caption.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                // Retry fetching event
                context
                    .read<EventOwnerCubit>()
                    .getEventById(widget.invitation.eventId);
              },
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Event Details Card (Success State)
  Widget _buildEventDetailsCard(EventModel event) {
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
              "Event Details",
              style: AppTextStyles.subtitle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Event Date
            _buildInfoRow(
              icon: Icons.calendar_today_rounded,
              label: "Date",
              value: DateFormat('EEE, MMM d, yyyy - hh:mm a').format(event.eventDate),
              color: AppColors.buttonPrimary,
            ),

            const SizedBox(height: 12),

            // Event Location
            _buildInfoRow(
              icon: Icons.location_on_rounded,
              label: "Location",
              value: event.location,
              color: Colors.red,
            ),

            // City (if available)
            if (event.city != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.location_city_rounded,
                label: "City",
                value: event.city!,
                color: Colors.orange,
              ),
            ],

            // Address (if available)
            if (event.address != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.home_rounded,
                label: "Address",
                value: event.address!,
                color: Colors.purple,
              ),
            ],

            const SizedBox(height: 12),

            // Guest Count Allowed
            _buildInfoRow(
              icon: Icons.people_rounded,
              label: "Guests Allowed",
              value: "${widget.invitation.guestCount} ${widget.invitation.guestCount == 1 ? 'Guest' : 'Guests'}",
              color: Colors.green,
            ),

            if (widget.invitation.confirmedGuestCount != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.check_circle_rounded,
                label: "Confirmed Guests",
                value: "${widget.invitation.confirmedGuestCount} ${widget.invitation.confirmedGuestCount == 1 ? 'Guest' : 'Guests'}",
                color: Colors.blue,
              ),
            ],

            // Expected Guest Count (from Event)
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.group_rounded,
              label: "Total Expected Guests",
              value: "${event.expectedGuestCount} Guests",
              color: Colors.teal,
            ),
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
                style: AppTextStyles.caption.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
