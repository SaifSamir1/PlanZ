import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_stayls.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/auth/ui/widgets/attende_home_widgets/system_notifaction_card.dart';

class AlertNotificationWidget extends StatelessWidget {
  const AlertNotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SystemNotifactionCard(
      icon: Icons.warning_amber_rounded,
      title: "Urgent: Venue Change for Tech Summit!",
      subtitle:
          "The 'Annual Tech Summit 2024' venue has been moved due to unforeseen circumstances. Please check new details.",
      date: "Oct 26, 2024, 10:00 AM",
    );
  }
}
