import 'package:flutter/material.dart';
import 'package:plan_z/features/attandee_features/attendee_home/ui/attende_home_widgets/system_notifaction_card.dart';

class UpdateNotificationWidget extends StatelessWidget {
  const UpdateNotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SystemNotifactionCard(
      icon: Icons.check_circle_outline_outlined,
      title: "Entry Pass System Update Complete",
      subtitle:
          "Our entry pass validation system has been successfully updated for improved speed and reliability.",
      date: "Oct 26, 2024, 10:00 AM",
    );
  }
}
