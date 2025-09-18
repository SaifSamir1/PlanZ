// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';

import '../../../../../../../core/theming/text_stayls.dart';
import 'owner_notification_screen.dart';

class OwnerHomeScreen extends StatelessWidget {
  const OwnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Home", style: AppTextStyles.headline2),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.amber),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> OwnerNotificationScreen()));
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👋 Welcome card
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hello, Sarah!', style: AppTextStyles.headline3),
                      Text(
                        'Welcome back to EventFlow.',
                        style: TextStyle(color: AppColors.primaryDark),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                            "https://i.pravatar.cc/150?img=3",
                          ), // demo avatar
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            // Quick Actions
            Text("Quick Actions", style: AppTextStyles.headline3),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.8,
              children: [
                _quickAction(Icons.auto_awesome_outlined, "Plan New Event"),
                _quickAction(Icons.emoji_events_outlined, "Review Vendors"),
                _quickAction(Icons.group_outlined, "Manage Guests"),
                _quickAction(Icons.calendar_month_outlined, "My Events"),
              ],
            ),
            const SizedBox(height: 20),
            // Upcoming Events
            Text("Upcoming Events", style: AppTextStyles.headline3),
            const SizedBox(height: 12),
            SizedBox(
              height: 250,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _eventCard(
                    title: "Annual Tech Summit 2024",
                    date: "Jul 20, 2024",
                    location: "Golden Gate Park, SF",
                    imagePath:
                    'https://www.cvent.com/sites/default/files/image/2023-10/Event_Experience-Cvent_CONNECT_2023.jpg',
                  ),
                  const SizedBox(width: 12),
                  _eventCard(
                    title: "Annual Tech Summit 2024",
                    date: "Jul 20, 2024",
                    location: "Golden Gate Park, SF",
                    imagePath:
                    'https://www.cvent.com/sites/default/files/image/2023-10/Event_Experience-Cvent_CONNECT_2023.jpg',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Chat Assistance
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.support_agent, color: AppColors.primaryGold),
                  const SizedBox(width: 12),
                  const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Need Assistance?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.primaryDark,
                            ),
                          ),
                          Text('Our chatbot is here \nto help!',style: TextStyle(color: AppColors.primaryDark),)
                        ],)
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGold,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Chat Now",
                        style: TextStyle(color: AppColors.primaryDark),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Quick Action Button
  Widget _quickAction(IconData icon, String label) {
    return Center(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primaryGold, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Event Card
  Widget _eventCard({
    required String title,
    required String date,
    required String location,
    required String imagePath,
  }) {
    return SizedBox(
      width: 260,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                imagePath,
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 14,
                        color: AppColors.primaryGold,
                      ),
                      const SizedBox(width: 4),
                      Text(date, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.place,
                        size: 14,
                        color: AppColors.primaryGold,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "View Details ",
                          style: TextStyle(color: AppColors.primaryDark),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [Icon(Icons.arrow_forward, size: 20)],
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
