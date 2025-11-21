import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';

class AppOwnerNotificationScreen extends StatefulWidget {
  const AppOwnerNotificationScreen({super.key});

  @override
  State<AppOwnerNotificationScreen> createState() =>
      _AppOwnerNotificationScreenState();
}

class _AppOwnerNotificationScreenState
    extends State<AppOwnerNotificationScreen> {
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
      case 'vendor_package_created':
        return Icons.add_box_outlined;
      case 'withdrawal_request':
        return Icons.attach_money_outlined;
      case 'vendor_registration':
        return Icons.person_add_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'vendor_package_created':
        return AppColors.primaryGold;
      case 'withdrawal_request':
        return AppColors.success;
      case 'vendor_registration':
        return Colors.blue;
      default:
        return AppColors.primaryDark;
    }
  }

  Future<void> _clearAllNotifications(String appOwnerId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('receiverId', isEqualTo: appOwnerId)
          .where('receiverRole', isEqualTo: 'app_owner')
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
    // Get app owner ID from Firestore
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Notifications', showBackButton: true),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'app_owner')
            .limit(1)
            .get(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGold),
            );
          }

          if (!userSnapshot.hasData || userSnapshot.data!.docs.isEmpty) {
            return const Center(child: Text('App owner not found'));
          }

          final appOwnerId = userSnapshot.data!.docs.first.id;

          return Column(
            children: [
              // Header with Clear All button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Notifications',
                      style: AppTextStyles.title.copyWith(fontSize: 18),
                    ),
                    TextButton.icon(
                      onPressed: () => _clearAllNotifications(appOwnerId),
                      icon: const Icon(Icons.clear_all, size: 18),
                      label: const Text('Clear All'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Notifications List
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('notifications')
                      .where('receiverId', isEqualTo: appOwnerId)
                      .where('receiverRole', isEqualTo: 'app_owner')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryGold,
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    var notifications = snapshot.data?.docs ?? [];

                    // Client-side sorting
                    notifications.sort((a, b) {
                      final aTime =
                          (a.data() as Map<String, dynamic>)['createdAt']
                              as Timestamp?;
                      final bTime =
                          (b.data() as Map<String, dynamic>)['createdAt']
                              as Timestamp?;
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
                      padding: const EdgeInsets.all(16),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final doc = notifications[index];
                        final data = doc.data() as Map<String, dynamic>;
                        final title = data['title'] as String? ?? '';
                        final body = data['body'] as String? ?? '';
                        final type = data['type'] as String? ?? 'general';
                        final isRead = data['isRead'] as bool? ?? false;
                        final createdAt =
                            (data['createdAt'] as Timestamp?)?.toDate() ??
                            DateTime.now();
                        final icon = _getIconForType(type);
                        final iconColor = _getColorForType(type);

                        return FadeInUp(
                          duration: Duration(milliseconds: 400 + (index * 50)),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isRead
                                  ? Colors.white
                                  : AppColors.primaryGold.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isRead
                                    ? Colors.grey.shade200
                                    : AppColors.primaryGold.withOpacity(0.3),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 8,
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
                                    color: iconColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Icon(
                                          icon,
                                          color: iconColor,
                                          size: 24,
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
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: AppTextStyles.body.copyWith(
                                          fontWeight: isRead
                                              ? FontWeight.w500
                                              : FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (body.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          body,
                                          style: AppTextStyles.body.copyWith(
                                            color: AppColors.textSecondary,
                                            fontSize: 13,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                      const SizedBox(height: 8),
                                      Text(
                                        _formatTimeAgo(createdAt),
                                        style: AppTextStyles.body.copyWith(
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
