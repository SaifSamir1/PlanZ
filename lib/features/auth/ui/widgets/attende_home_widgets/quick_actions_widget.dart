import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_stayls.dart';
import 'package:plan_z/features/auth/ui/widgets/attende_home_widgets/quick_action_card.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Quick Actions", style: AppTextStyles.headline3),
        Row(
          children: [
            Expanded(
              child: QuickActionCard(
                icon: Icons.qr_code_scanner,
                title: "Check In Attendees",
                subtitle: "Quick scan for event entry.",
              ),
            ),
            Expanded(
              child: QuickActionCard(
                icon: Icons.list_alt,
                title: "View Attendance Logs",
                subtitle: "Review past check-in records.",
              ),
            ),
          ],
        ),
      ],
    );
  }
}
