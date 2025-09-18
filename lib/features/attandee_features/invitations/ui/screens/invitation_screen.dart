import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_stayls.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/attandee_features/invitations/ui/widgets/invitation_widget.dart';

class InvitationScreen extends StatelessWidget {
  InvitationScreen({super.key});

  final List<Map<String, dynamic>> invitations = [
    {
      'image': 'assets/images/invitation1.png',
      'title': 'EventFlow Charity Gala',
      'host': 'Hosted by EventFlow Team.',
      'time': '7:00 PM - 10:00 PM',
      'date': 'Sat, Nov 23',
      'location': 'The Grand Ballroom, City Convention Center, 123 Main St, Anytown',
      'status': 'Pending',
    },
    {
      'image': 'assets/images/invitation2.png',
      'title': 'Annual Tech Conference 2024',
      'host': 'Hosted by Global Innovations Inc.',
      'time': '9:00 AM - 5:00 PM',
      'date': 'Tue, Dec 10',
      'location': 'Silicon Valley Tech Hub, 456 Innovation Dr, Techville',
      'status': 'Attending',
    },
    {
      'image': 'assets/images/invitation3.png',
      'title': 'Summer Music Festival',
      'host': 'Hosted by Harmony Events.',
      'time': '6:00 PM - 11:00 PM',
      'date': 'Fri, Jul 19',
      'location': 'Open Air Amphitheater, Central Park, New Harmony City',
      'status': 'Not Attending',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'My Invitations',
          style: AppTextStyles.headline3.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              tileColor: AppColors.blue50,
              title: Text('Event Update', style: AppTextStyles.title),
              subtitle: Text(
                'Your EventFlow Charity Gala start time has been updated to 7:30 PM. Please check the event details.',
                style: AppTextStyles.subtitle,
              ),
              leading: Icon(Icons.warning, color: AppColors.buttonPrimary),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: invitations.length,
                itemBuilder: (context, index) => InvitationWidget(index: index, invitation: invitations[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
