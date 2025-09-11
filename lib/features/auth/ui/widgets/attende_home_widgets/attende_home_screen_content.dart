import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_stayls.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/auth/ui/widgets/attende_home_widgets/alert_notification_widget.dart';
import 'package:plan_z/features/auth/ui/widgets/attende_home_widgets/attendees_summary_card.dart';
import 'package:plan_z/features/auth/ui/widgets/attende_home_widgets/event_card.dart';
import 'package:plan_z/features/auth/ui/widgets/attende_home_widgets/update_notification_widget.dart';
import 'package:plan_z/features/auth/ui/widgets/attende_home_widgets/quick_actions_widget.dart';
import 'package:plan_z/features/auth/ui/widgets/attende_home_widgets/upcoming_events_widget.dart';

class AttendeHomeScreenContent extends StatelessWidget {
  const AttendeHomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        child: Column(
          children: [
            AttendeesSummaryCard(),
            SizedBox(height: 20),
            AlertNotificationWidget(),
            SizedBox(height: 20),
            UpdateNotificationWidget(),
            SizedBox(height: 20),
            QuickActionsWidget(),
            SizedBox(height: 20),
            UpComingEventsWidget(),
          ],
        ),
      ),
    );
  }
}
