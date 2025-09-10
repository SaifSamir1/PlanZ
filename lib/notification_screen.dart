import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_stayls.dart';

import 'core/utils/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Notifications', style: AppTextStyles.headline2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              thickness: 0.5,
            ),
            Text(
              'Recent Notifications',
              style: AppTextStyles.headline3,
            ),
            SizedBox(height: 12,),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                'View All',
                style: TextStyle(color: AppColors.primaryDark),
              ),
            ),
            SizedBox(height: 15,),
            Expanded(
              child: ListView(
                children: [
                  SizedBox(height: 12,),
                  _buildNotificationItem(
                    icon: Icons.notifications_none,
                    title: 'New Booking Confirmed',
                    description: 'Client "Harmony Events" confirmed',
                    timeAgo: '2 hours ago',
                  ),
                  SizedBox(height: 12,),
                  _buildNotificationItem(
                    icon: Icons.notifications_none,
                    title: 'Service Update Required',
                    description: 'Your "Photography Package" requires a',
                    timeAgo: '1 day ago',
                  ),
                  SizedBox(height: 12,),
                  _buildNotificationItem(
                    icon: Icons.notifications_none,
                    title: 'Payment Processed',
                    description: 'Payment for "Winter Wonderland" event',
                    timeAgo: '3 days ago',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required String description,
    required String timeAgo,
  }) {
    return Container(
     // padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            child: Align(
              alignment: Alignment.topCenter,
                child: Icon(icon, size: 20, color: AppColors.primaryGold,)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle( fontSize: 15,color: AppColors.primaryDark),
                ),
                Text(
                  description,
                  style: TextStyle(color: AppColors.primaryDark, fontSize: 12),
                ),
                SizedBox(height: 4),
                SizedBox(height: 10),
              ],
            ),
          ),
          Text(
            timeAgo,
            style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
