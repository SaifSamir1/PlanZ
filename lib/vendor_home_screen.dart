import 'package:flutter/material.dart';
import 'core/theming/text_stayls.dart';
import 'core/utils/app_colors.dart';

class VendorHomeScreen extends StatelessWidget {
  const VendorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text("EventFlow", style: AppTextStyles.headline3),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: AppColors.primaryGold,
              ),
              onPressed: () {},
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(
                  "https://i.pravatar.cc/150?img=3",
                ), // demo avatar
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text("Hi, Alex Johnson!", style: AppTextStyles.headline2),
              const SizedBox(height: 4),
              const Text(
                "Welcome back to your EventFlow dashboard.",
                style: TextStyle(color: AppColors.primaryDark),
              ),
              const SizedBox(height: 24),
      
              // Quick Actions
              Text("Quick Actions", style: AppTextStyles.headline3),
              const SizedBox(height: 12),
              Row(
                children: [
                  buildActionCard(
                    icon: Icons.calendar_today_outlined,
                    title: 'Update Availability',
                  ),
                  const SizedBox(width: 12),
                  buildActionCard(icon: Icons.attach_money, title: 'Manage Packeges'),
                ],
              ),
              const SizedBox(height: 24),
      
              // Overview
              Text("Overview", style: AppTextStyles.headline3),
              const SizedBox(height: 12),
      
              buildOverviewCard(
                icon: Icons.calendar_today_outlined,
                title: '12 Events',
                subTitle: 'Next event in 3 days',
                trailing: 'Upcoming Bookings',
              ),
      
              buildOverviewCard(
                icon: Icons.attach_money,
                title: "\$2,450",
                subTitle: "Up 10% from last month",
                trailing: "Monthly Earnings",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOverviewCard({
    required IconData icon,
    required String title,
    required String subTitle,
    required String trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.primaryGold),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      trailing,
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Align(
            alignment: Alignment.topLeft,
            child: Text(title, style: AppTextStyles.headline3),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                subTitle,
                style: TextStyle(fontSize: 11, color: AppColors.primaryDark),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward,
                        color: AppColors.primaryGold,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
        ],
      ),
    );
  }

  Widget buildActionCard({required IconData icon, required String title}) {
    return Expanded(
      child: SizedBox(
        height: 100,
        child: GestureDetector(
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primaryGold),
              SizedBox(height: 5),
              Text(title, style: TextStyle(color: AppColors.primaryDark)),
            ],
          ),
        ),
      ),
    );
  }
}
