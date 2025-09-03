import 'package:flutter/material.dart';
import 'package:plan_z/features/auth/data/models/stakeholder_model.dart';
import 'package:plan_z/features/auth/ui/widgets/stakeholder_card.dart';
import 'package:plan_z/features/auth/ui/widgets/welcome_widget.dart';

class StakeholdersScreenContent extends StatelessWidget {
  const StakeholdersScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final stakeholders = [
      StakeHolderModel(
        icon: Icons.manage_accounts,
        titel: "Event Owner",
        description:
            "Plan and manage your events with ease, from vendor selection to invitations.",
      ),
      StakeHolderModel(
        icon: Icons.business_center,
        titel: "Vendor",
        description:
            "Showcase your packages, manage bookings, and connect with event owners.",
      ),
      StakeHolderModel(
        icon: Icons.group,
        titel: "Event Attendee",
        description:
            "View your invitations, RSVP, and stay updated on event details.",
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: ListView(
        children: [
          CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.13, // نسبة من الشاشة
            child: Image.asset("assets/images/logo-photoaidcom-cropped.jpg"),
          ),
          WelcomeWidget(),
          const SizedBox(height: 20),
          ...stakeholders.map((s) => StakeholderCard(stakeholder: s)),
        ],
      ),
    );
  }
}
