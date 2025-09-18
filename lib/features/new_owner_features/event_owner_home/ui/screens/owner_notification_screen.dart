import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_stayls.dart';

import '../../../../../../../core/utils/app_colors.dart';

class OwnerNotificationScreen extends StatelessWidget {
  const OwnerNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Notifications", style: AppTextStyles.headline2),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.amber),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>OwnerNotificationScreen()));
            },
          ),
          const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              "https://i.pravatar.cc/150?img=3",
            ), // demo avatar
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              thickness: 0.5,
            ),

            Align(
              alignment: Alignment.topRight,
              child: TextButton(onPressed: (){}, child: Text(
                'Clear All',
                style: TextStyle(color: Colors.red),
              )),
            ),
            Expanded(
              child: ListView(
                children: [
                  SizedBox(height: 12,),
                  _buildNotificationItem(
                    icon: Icons.check_circle_outline,
                    title: 'Your event Summer Gala has been successfully published!',
                    timeAgo: '2 hours ago',
                  ),
                  SizedBox(height: 12,),
                  _buildNotificationItem(
                    icon: Icons.access_time,
                    title: "Reminder: 'Project Kick-off' meeting in 30 minutes.",
                    timeAgo: '1 day ago',
                  ),
                  SizedBox(height: 12,),
                  _buildNotificationItem(
                    icon: Icons.message_outlined,
                    title: "Alex sent you a new message regarding 'Conference Logistics'.",
                    timeAgo: '3 days ago',
                  ),
                  SizedBox(height: 12,),
                  _buildNotificationItem(
                    icon: Icons.notifications_none,
                    title: "New guest registration for 'Charity Run'.",
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle( fontSize: 15,color: AppColors.primaryDark),
                    ),
                    Text(
                      timeAgo,
                      style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 12),
                    ),
                  ],
                ),

                SizedBox(height: 10),
              ],
            ),
          ),
          Icon(Icons.arrow_forward,size: 20,color: AppColors.primaryDark,)
        ],
      ),
    );
  }
}
