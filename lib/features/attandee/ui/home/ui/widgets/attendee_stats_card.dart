// lib/features/attendee/presentation/widgets/home/attendee_stats_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/attandee/cubit/attendee_cubit.dart';
import 'package:plan_z/features/attandee/cubit/attendee_state.dart';
import 'package:shimmer/shimmer.dart';

class AttendeeStatsCard extends StatelessWidget {
  final String attendeeId;

  const AttendeeStatsCard({
    super.key,
    required this.attendeeId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendeeCubit, AttendeeState>(
      builder: (context, state) {
        if (state is GetAttendeeStatsLoading) {
          return _buildLoadingShimmer();
        }

        if (state is GetAttendeeStatsError) {
          return _buildErrorCard(state.message, context);
        }

        if (state is GetAttendeeStatsSuccess) {
          return _buildStatsCard(state.stats);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStatsCard(Map<String, dynamic> stats) {
    final totalInvitations = stats['totalInvitations'] ?? 0;
    final pendingInvitations = stats['pendingInvitations'] ?? 0;
    final upcomingEvents = stats['upcomingEvents'] ?? 0;
    final acceptedInvitations = stats['acceptedInvitations'] ?? 0;

    return Card(
      elevation: 2,
      color: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Main Stats Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Total Invitations
                Text(
                  "$totalInvitations",
                  style: AppTextStyles.headline1,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Invitations",
                        style: AppTextStyles.subtitle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "All events you've been invited to",
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Divider
            Divider(
              color: Colors.grey[200],
              thickness: 1,
            ),

            const SizedBox(height: 16),

            // Stats Grid
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.schedule_rounded,
                    value: "$pendingInvitations",
                    label: "Pending",
                    color: Colors.orange,
                    hasBadge: pendingInvitations > 0,
                  ),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.grey[200],
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.check_circle_outline_rounded,
                    value: "$acceptedInvitations",
                    label: "Accepted",
                    color: Colors.green,
                  ),
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.grey[200],
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.event_rounded,
                    value: "$upcomingEvents",
                    label: "Upcoming",
                    color: AppColors.buttonPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    bool hasBadge = false,
  }) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            if (hasBadge)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.headline3.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoadingShimmer() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(20),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 150,
                          height: 12,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message, BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.red[300],
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              "Failed to load stats",
              style: AppTextStyles.subtitle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                context.read<AttendeeCubit>().getAttendeeStats(attendeeId);
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
