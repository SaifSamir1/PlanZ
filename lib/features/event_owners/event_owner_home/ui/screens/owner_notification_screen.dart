import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/features/auth/data/models/user_manager.dart';
import '../../../../../../core/utils/app_colors.dart';

class OwnerNotificationScreen extends StatefulWidget {
  const OwnerNotificationScreen({super.key});

  @override
  State<OwnerNotificationScreen> createState() =>
      _OwnerNotificationScreenState();
}

class _OwnerNotificationScreenState extends State<OwnerNotificationScreen> {
  final UserManager _userManager = UserManager();

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? "s" : ""} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? "s" : ""} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? "s" : ""} ago';
    } else {
      return 'Just now';
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'vendor_acceptance':
        return Icons.check_circle_outline_rounded;
      case 'vendor_rejection':
        return Icons.cancel_outlined;
      case 'invitation_response':
        return Icons.person_add_outlined;
      case 'payment':
        return Icons.payment_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Future<void> _clearAllNotifications() async {
    try {
      final ownerId = _userManager.userId;
      if (ownerId == null) return;

      final snapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('receiverId', isEqualTo: ownerId)
          .where('receiverRole', isEqualTo: 'event_owner')
          .get();

      final batch = FirebaseFirestore.instance.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All notifications cleared')),
        );
      }
    } catch (e) {
      debugPrint('Error clearing notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ownerId = _userManager.userId;

    if (ownerId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Notifications')),
        body: const Center(child: Text('Please log in to view notifications')),
      );
    }

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
            _buildNotificationsList(ownerId),
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
            onPressed: () {},
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
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primaryGold,
              child: Text(
                _userManager.getUserInitials(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
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
                  onTap: _clearAllNotifications,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
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

  Widget _buildNotificationsList(String ownerId) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('receiverId', isEqualTo: ownerId)
            .where('receiverRole', isEqualTo: 'event_owner')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGold),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          var notifications = snapshot.data?.docs ?? [];
          notifications.sort((a, b) {
            final aTime =
                (a.data() as Map<String, dynamic>)['createdAt'] as Timestamp?;
            final bTime =
                (b.data() as Map<String, dynamic>)['createdAt'] as Timestamp?;
            if (aTime == null || bTime == null) return 0;
            return bTime.compareTo(aTime);
          });

          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 80,
                    color: AppColors.textSecondary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Notifications',
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final doc = notifications[index];
              final data = doc.data() as Map<String, dynamic>;
              final title = data['title'] as String? ?? '';
              final body = data['body'] as String? ?? '';
              final type = data['type'] as String? ?? 'general';
              final isRead = data['isRead'] as bool? ?? false;
              final createdAt =
                  (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();

              return SlideInUp(
                duration: Duration(milliseconds: 600 + (index * 100)),
                delay: Duration(milliseconds: index * 50),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: _buildNotificationItem(
                    icon: _getIconForType(type),
                    title: title,
                    body: body,
                    timeAgo: _formatTimeAgo(createdAt),
                    isRead: isRead,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required String body,
    required String timeAgo,
    required bool isRead,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isRead ? Colors.white : Colors.grey.shade50,
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
                    if (body.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        body,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
