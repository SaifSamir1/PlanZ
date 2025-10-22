import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class InvitationWidget extends StatelessWidget {
  const InvitationWidget({super.key, required this.index, required this.invitation});
  final int index;
  final Map<String, dynamic> invitation;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                invitation['image'],
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(invitation['title'], style: AppTextStyles.title),
                  SizedBox(height: 6),
                  Text(invitation['host'], style: AppTextStyles.subtitle),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: AppColors.buttonPrimary,
                      ),
                      SizedBox(width: 4),
                      Expanded(child: Text(invitation['date'])),
                      SizedBox(width: 16),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppColors.buttonPrimary,
                      ),
                      SizedBox(width: 4),
                      Expanded(child: Text(invitation['time'])),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppColors.buttonPrimary,
                      ),
                      SizedBox(width: 4),
                      Expanded(child: Text(invitation['location'])),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Text('Your Status: ', style: AppTextStyles.subtitle),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: invitation['status'] == 'Attending'
                            ? BoxDecoration(
                                color: AppColors.success,
                                borderRadius: BorderRadius.circular(6),
                              )
                            : invitation['status'] == 'Not Attending'
                            ? BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(6),
                              )
                            : BoxDecoration(
                                color: AppColors.warning,
                                borderRadius: BorderRadius.circular(6),
                              ),
                        child: Text(
                          invitation['status'],
                          style: AppTextStyles.subtitle,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            side: BorderSide(color: AppColors.buttonPrimary),
                            backgroundColor: AppColors.blue50,
                          ),
                          onPressed: () {},
                          child: Text(
                            'Attending',
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            backgroundColor: AppColors.buttonPrimary,
                          ),
                          child: Text(
                            'Not Attending',
                            style: AppTextStyles.subtitle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
