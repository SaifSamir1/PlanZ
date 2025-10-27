import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
  import 'package:plan_z/features/attandee_features/attendee_home/ui/attende_home_widgets/alert_notification_widget.dart';
import 'package:plan_z/features/attandee_features/attendee_home/ui/attende_home_widgets/attendees_summary_card.dart';
 import 'package:plan_z/features/attandee_features/attendee_home/ui/attende_home_widgets/update_notification_widget.dart';
import 'package:plan_z/features/attandee_features/attendee_home/ui/attende_home_widgets/quick_actions_widget.dart';
import 'package:plan_z/features/attandee_features/attendee_home/ui/attende_home_widgets/upcoming_events_widget.dart';


class AttendeHomeScreenContent extends StatelessWidget {
  const AttendeHomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        children: [
          FadeInUp(
            duration: const Duration(milliseconds: 600),
            child: const AttendeesSummaryCard(),
          ),
          const SizedBox(height: 20),
          SlideInLeft(
            duration: const Duration(milliseconds: 700),
            delay: const Duration(milliseconds: 200),
            child: const AlertNotificationWidget(),
          ),
          const SizedBox(height: 20),
          SlideInRight(
            duration: const Duration(milliseconds: 700),
            delay: const Duration(milliseconds: 400),
            child: const UpdateNotificationWidget(),
          ),
          const SizedBox(height: 20),
          FadeInUp(
            duration: const Duration(milliseconds: 800),
            delay: const Duration(milliseconds: 600),
            child: const QuickActionsWidget(),
          ),
          const SizedBox(height: 20),
          SlideInUp(
            duration: const Duration(milliseconds: 800),
            delay: const Duration(milliseconds: 800),
            child: UpComingEventsWidget(),
          ),
        ],
      ),
    );
  }
}

