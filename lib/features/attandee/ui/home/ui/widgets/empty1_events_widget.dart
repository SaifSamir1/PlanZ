// lib/features/attendee/presentation/widgets/my_events/empty_events_widget.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/attandee/ui/home/ui/screens/my_events_screen.dart';

class Empty1EventsWidget extends StatelessWidget {
  final EventFilter filterType;

  const Empty1EventsWidget({
    super.key,
    required this.filterType,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getEmptyConfig(filterType);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              config.icon,
              size: 80,
              color: Colors.grey[300],
            ),
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
              style: AppTextStyles.body.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {
                // Navigate back to invitations
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.mail_rounded,
                color: AppColors.buttonPrimary,
              ),
              label: Text(
                "Check Invitations",
                style: TextStyle(color: AppColors.buttonPrimary),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.buttonPrimary),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _EmptyConfig _getEmptyConfig(EventFilter filter) {
    switch (filter) {
      case EventFilter.all:
        return _EmptyConfig(
          icon: Icons.event_busy_rounded,
          title: "No Events Yet",
          message: "You haven't accepted any event invitations yet. Check your invitations!",
        );
      case EventFilter.upcoming:
        return _EmptyConfig(
          icon: Icons.event_available_rounded,
          title: "No Upcoming Events",
          message: "You don't have any events scheduled in the future.",
        );
      case EventFilter.past:
        return _EmptyConfig(
          icon: Icons.history_rounded,
          title: "No Past Events",
          message: "You haven't attended any events yet.",
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
