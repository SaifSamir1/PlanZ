import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/features/attandee_features/attendee_home/ui/attende_home_widgets/quick_action_card.dart';
import 'package:plan_z/features/attandee_features/invitations/ui/screens/invitation_screen.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text("Quick Actions", style: AppTextStyles.headline3),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: SlideInLeft(
                duration: const Duration(milliseconds: 700),
                delay: const Duration(milliseconds: 200),
                child:  QuickActionCard(
                  icon: Icons.qr_code_scanner_rounded,
                  title: "Check In Attendees",
                  subtitle: "Quick scan for event entry.",
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => InvitationScreen(),));
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SlideInRight(
                duration: const Duration(milliseconds: 700),
                delay: const Duration(milliseconds: 200),
                child: const QuickActionCard(
                  icon: Icons.list_alt_rounded,
                  title: "View Attendance Logs",
                  subtitle: "Review past check-in records.",
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
