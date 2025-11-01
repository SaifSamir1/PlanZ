// lib/features/attendee/presentation/widgets/home/upcoming_events_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/features/attandee/cubit/attendee_cubit.dart';
import 'package:plan_z/features/attandee/cubit/attendee_state.dart';
import 'package:plan_z/features/attandee/ui/home/ui/screens/my_invitations_screen.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/attendee_event_card.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/empty_events_widget.dart';
import 'package:plan_z/features/attandee/ui/home/ui/widgets/loading_shimmer_home.dart';

class UpcomingEventsSection extends StatelessWidget {
  final String attendeeId;

  const UpcomingEventsSection({
    super.key,
    required this.attendeeId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Upcoming Events",
              style: AppTextStyles.headline3,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MyInvitationsScreen(),
                  ),
                );
              },
              child: const Text("See All"),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Events List
        BlocBuilder<AttendeeCubit, AttendeeState>(
          builder: (context, state) {
            if (state is GetUpcomingEventsLoading) {
              return const LoadingShimmerHome();
            }

            if (state is GetUpcomingEventsError) {
              return _buildErrorWidget(state.message, context);
            }

            if (state is GetUpcomingEventsSuccess) {
              final events = state.events;

              if (events.isEmpty) {
                return const EmptyEventsWidget();
              }

              // Show max 3 events
              final displayEvents = events.take(3).toList();

              return Column(
                children: displayEvents
                    .map((event) => AttendeeEventCard(event: event))
                    .toList(),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildErrorWidget(String message, BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.red[300],
              size: 40,
            ),
            const SizedBox(height: 8),
            Text(
              "Failed to load events",
              style: AppTextStyles.subtitle.copyWith(
                color: Colors.red[700],
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                context.read<AttendeeCubit>().getUpcomingEvents(attendeeId);
              },
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
