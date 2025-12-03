import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/features/auth/data/models/stakeholder_model.dart';
import 'package:plan_z/features/auth/data/models/user_model.dart';
import 'package:plan_z/features/on_boarding/ui/widgets/stake_holders_widget/stakeholder_card.dart';
import 'package:plan_z/features/on_boarding/ui/widgets/stake_holders_widget/welcome_widget.dart';

class StakeholdersScreenContent extends StatelessWidget {
  const StakeholdersScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final stakeholders = [
      StakeHolderModel(
        icon: Icons.manage_accounts,
        userType: UserType.eventOwner,
        titel: "stakeholder.event_owner_title".tr(),
        description: "stakeholder.event_owner_desc".tr(),
      ),
      StakeHolderModel(
        icon: Icons.business_center,
        userType: UserType.vendor,
        titel: "stakeholder.vendor_title".tr(),
        description: "stakeholder.vendor_desc".tr(),
      ),
      StakeHolderModel(
        icon: Icons.group,
        userType: UserType.attendee,
        titel: "stakeholder.attendee_title".tr(),
        description: "stakeholder.attendee_desc".tr(),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        children: [
          CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.17, // نسبة من الشاشة
            child: Image.asset("assets/images/logo-photoaidcom-cropped.jpg"),
          ),
          const SizedBox(height: 30),
          WelcomeWidget(),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: stakeholders.length,
              itemBuilder: (context, index) {
                final stakeholder = stakeholders[index];
                return StakeholderCard(stakeholder: stakeholder);
              },
            ),
          ),
        ],
      ),
    );
  }
}
