// lib/features/attendee/presentation/widgets/invitation_details/event_owner_info_section.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_invitation_model.dart';

class EventOwnerInfoSection extends StatelessWidget {
  final EventInvitationModel invitation;

  const EventOwnerInfoSection({
    super.key,
    required this.invitation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Owner Avatar
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.buttonPrimary.withOpacity(0.1),
              child: Icon(
                Icons.person_rounded,
                color: AppColors.buttonPrimary,
                size: 32,
              ),
            ),

            const SizedBox(width: 16),

            // Owner Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hosted by",
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    invitation.eventOwnerName,
                    style: AppTextStyles.subtitle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // // Contact Button
            // IconButton(
            //   onPressed: () {
            //     _showContactOptions(context);
            //   },
            //   icon: Icon(
            //     Icons.message_rounded,
            //     color: AppColors.buttonPrimary,
            //   ),
            //   style: IconButton.styleFrom(
            //     backgroundColor: AppColors.buttonPrimary.withOpacity(0.1),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // void _showContactOptions(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) => Padding(
  //       padding: const EdgeInsets.all(24),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Text(
  //             "Contact Host",
  //             style: AppTextStyles.headline3,
  //           ),
  //           const SizedBox(height: 24),
  //           ListTile(
  //             leading: const Icon(Icons.email_rounded),
  //             title: const Text("Send Email"),
  //             onTap: () {
  //               // TODO: Open email
  //               Navigator.pop(context);
  //             },
  //           ),
  //           ListTile(
  //             leading: const Icon(Icons.phone_rounded),
  //             title: const Text("Call"),
  //             onTap: () {
  //               // TODO: Open phone
  //               Navigator.pop(context);
  //             },
  //           ),
  //           ListTile(
  //             leading: const Icon(Icons.message_rounded),
  //             title: const Text("Send Message"),
  //             onTap: () {
  //               // TODO: Open messaging
  //               Navigator.pop(context);
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }


}
