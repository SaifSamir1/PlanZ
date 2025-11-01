import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/attandee/ui/invitations/ui/screens/custom_button.dart';

class InvitationTemplate extends StatelessWidget {
  const InvitationTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invitation', style: AppTextStyles.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 350,
                decoration: BoxDecoration(
                  color: AppColors.neutralGray.withOpacity(0.1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(
                            'assets/images/undraw_female-avatar_7t6k.png',
                          ),
                          radius: 30,
                        ),
                        title: Text('Samantha Lee', style: AppTextStyles.title),
                        subtitle: Text(
                          'You\'re invited to celebrate with us!',
                          style: AppTextStyles.subtitle,
                        ),
                      ),
                      SizedBox(height: 10),
                      Stack(
                        children: [
                          Image.asset('assets/images/location.png'),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 10,
                                    offset: Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Grand Annual Gala',
                                    style: AppTextStyles.subtitle.copyWith(
                                      color: AppColors.background,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'May 20, 2024 • 7:00 PM - 11:00 PM',
                                    style: AppTextStyles.subtitle.copyWith(
                                      color: AppColors.background.withOpacity(
                                        0.9,
                                      ),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'The Starlight Ballroom, New York',
                                    style: AppTextStyles.body.copyWith(
                                      color: AppColors.background.withOpacity(
                                        0.7,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            CustomButton(
                              text: 'Message Owner',
                              icon: Icon(Icons.chat_bubble_outline),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              CustomButton(text: 'Accept Invitation', icon: Icon(Icons.check)),
              SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  label: Text(
                    'Decline Invitation',
                    style: AppTextStyles.body.copyWith(color: AppColors.error),
                  ),
                  icon: Icon(Icons.close, size: 25, color: AppColors.error),
                ),
              ),
              SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: BorderSide(color: AppColors.primaryGold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  label: Text(
                    'Add to Calendar',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.primaryGold,
                    ),
                  ),
                  icon: Icon(
                    Icons.calendar_today_rounded,
                    size: 20,
                    color: AppColors.primaryGold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
