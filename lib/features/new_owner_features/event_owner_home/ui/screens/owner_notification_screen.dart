import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_stayls.dart';
import '../../../../../../core/utils/app_colors.dart';

class OwnerNotificationScreen extends StatelessWidget {
  const OwnerNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildNotificationsList(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: FadeInLeft(
        duration: const Duration(milliseconds: 600),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.primaryDark.withOpacity(0.7),
            size: 20,
          ),
        ),
      ),
      title: FadeInDown(
        duration: const Duration(milliseconds: 700),
        child: Text("Notifications", style: AppTextStyles.headline2),
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
              // Handle notification action
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
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                "https://i.pravatar.cc/150?img=3",
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: Container(
            height: 1,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.grey.shade300,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        FadeInUp(
          duration: const Duration(milliseconds: 700),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    // Handle clear all
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.clear_all_rounded,
                          size: 16,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Clear All',
                          style: TextStyle(
                            color: Colors.red.shade400,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsList() {
    final notifications = [
      {
        'icon': Icons.check_circle_outline_rounded,
        'title': 'Your event Summer Gala has been successfully published!',
        'timeAgo': '2 hours ago',
        'isRead': false,
      },
      {
        'icon': Icons.access_time_rounded,
        'title': "Reminder: 'Project Kick-off' meeting in 30 minutes.",
        'timeAgo': '1 day ago',
        'isRead': false,
      },
      {
        'icon': Icons.message_outlined,
        'title': "Alex sent you a new message regarding 'Conference Logistics'.",
        'timeAgo': '3 days ago',
        'isRead': true,
      },
      {
        'icon': Icons.person_add_outlined,
        'title': "New guest registration for 'Charity Run'.",
        'timeAgo': '3 days ago',
        'isRead': true,
      },
      {
        'icon': Icons.star_outline_rounded,
        'title': "You received a 5-star review from recent event attendee.",
        'timeAgo': '5 days ago',
        'isRead': true,
      },
    ];

    return Expanded(
      child: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return SlideInUp(
            duration: Duration(milliseconds: 600 + (index * 100)),
            delay: Duration(milliseconds: index * 50),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: _buildNotificationItem(
                icon: notification['icon'] as IconData,
                title: notification['title'] as String,
                timeAgo: notification['timeAgo'] as String,
                isRead: notification['isRead'] as bool,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required String timeAgo,
    required bool isRead,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Handle notification tap
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isRead ? Colors.white : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        icon,
                        size: 24,
                        color: AppColors.primaryDark.withOpacity(0.7),
                      ),
                    ),
                    if (!isRead)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.primaryGold,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.primaryDark,
                        fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: AppColors.primaryDark.withOpacity(0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          timeAgo,
                          style: TextStyle(
                            color: AppColors.primaryDark.withOpacity(0.5),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
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
        ),
      ),
    );
  }
}
