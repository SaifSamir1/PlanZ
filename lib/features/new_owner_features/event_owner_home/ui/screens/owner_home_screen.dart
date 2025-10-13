import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/new_owner_features/event_owner_home/ui/screens/services_screen.dart';
import '../../../../../core/theming/text_styles.dart';
import 'owner_notification_screen.dart';

class OwnerHomeScreen extends StatelessWidget {
  const OwnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: 28),
            _buildQuickActionsSection(context),
            const SizedBox(height: 28),
            _buildUpcomingEventsSection(),
            const SizedBox(height: 28),
            _buildChatAssistanceSection(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: FadeInDown(
        duration: const Duration(milliseconds: 600),
        child: Text("Home", style: AppTextStyles.headline2),
      ),
      actions: [
        SlideInRight(
          duration: const Duration(milliseconds: 700),
          child: IconButton(
            icon: Icon(
              Icons.notifications_none_rounded,
              color: AppColors.primaryDark.withOpacity(0.7),
              size: 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OwnerNotificationScreen(),
                ),
              );
            },
          ),
        ),
        SlideInRight(
          duration: const Duration(milliseconds: 800),
          delay: const Duration(milliseconds: 100),
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
            ),
            child: const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3"),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hello, Sarah! 👋', style: AppTextStyles.headline3),
                  const SizedBox(height: 6),
                  Text(
                    'Welcome back to EventFlow.',
                    style: TextStyle(
                      color: AppColors.primaryDark.withOpacity(0.6),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
              ),
              child: const CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(
                  "https://i.pravatar.cc/150?img=3",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: Text("Quick Actions", style: AppTextStyles.headline3),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.3,
          children: [
            SlideInLeft(
              duration: const Duration(milliseconds: 700),
              child: _quickAction(
                Icons.auto_awesome_outlined,
                "Plan New Event",
              ),
            ),
            SlideInRight(
              duration: const Duration(milliseconds: 700),
              child: _quickAction(
                Icons.emoji_events_outlined,
                "Review Vendors",
              ),
            ),
            SlideInLeft(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 100),
              child: _quickAction(Icons.group_outlined, "Manage Guests"),
            ),
            GestureDetector(
              onTap: () {
                print('nfnvkdnfjknvjkf');
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ServicesScreen()),
                  );
              },
              child: SlideInRight(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 100),
                child: _quickAction(
                  Icons.calendar_month_outlined,
                  "My Events",
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUpcomingEventsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: Text("Upcoming Events", style: AppTextStyles.headline3),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 285,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SlideInLeft(
                duration: const Duration(milliseconds: 700),
                child: _eventCard(
                  title: "Annual Tech Summit 2024",
                  date: "Jul 20, 2024",
                  location: "Golden Gate Park, SF",
                  imagePath:
                      'https://www.cvent.com/sites/default/files/image/2023-10/Event_Experience-Cvent_CONNECT_2023.jpg',
                ),
              ),
              const SizedBox(width: 16),
              SlideInLeft(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 100),
                child: _eventCard(
                  title: "Creative Design Workshop",
                  date: "Aug 15, 2024",
                  location: "Downtown Convention Center",
                  imagePath:
                      'https://www.cvent.com/sites/default/files/image/2023-10/Event_Experience-Cvent_CONNECT_2023.jpg',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatAssistanceSection() {
    return SlideInUp(
      duration: const Duration(milliseconds: 700),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.support_agent_rounded,
                color: AppColors.primaryDark.withOpacity(0.7),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Need Assistance?",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Our chatbot is here to help!',
                    style: TextStyle(
                      color: AppColors.primaryDark.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGold,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Chat Now",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickAction(IconData icon, String label, ) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryDark.withOpacity(0.7),
                size: 26,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.primaryDark,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _eventCard({
    required String title,
    required String date,
    required String location,
    required String imagePath,
  }) {
    return SizedBox(
      width: 280,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                imagePath,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppColors.primaryDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 16,
                        color: AppColors.primaryDark.withOpacity(0.6),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.primaryDark.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.place_outlined,
                        size: 16,
                        color: AppColors.primaryDark.withOpacity(0.6),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primaryDark.withOpacity(0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "View Details",
                        style: TextStyle(
                          color: AppColors.primaryGold,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: AppColors.primaryDark.withOpacity(0.6),
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
