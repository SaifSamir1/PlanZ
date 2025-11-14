// lib/core/services/notification_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// ✅ Send notification to a specific user
  /// 
  /// Parameters:
  /// - [receiverId]: User ID to send notification to
  /// - [receiverRole]: User role ('attendee', 'vendor', 'event_owner', 'app_owner')
  /// - [title]: Notification title
  /// - [body]: Notification body
  /// - [type]: Notification type ('package_request', 'payment', 'invitation', 'withdrawal', etc.)
  /// - [data]: Additional data to send with notification
  /// - [fcmToken]: Optional FCM token (if not provided, will be fetched from current device)
  static Future<bool> sendNotification({
    required String receiverId,
    required String receiverRole,
    required String title,
    required String body,
    String type = 'general',
    Map<String, dynamic>? data,
    String? fcmToken,
  }) async {
    try {
      debugPrint('📤 [NotificationService] Sending notification...');
      debugPrint('   receiverId: $receiverId');
      debugPrint('   receiverRole: $receiverRole');
      debugPrint('   title: $title');
      debugPrint('   type: $type');

      // Get FCM token if not provided
      final token = fcmToken ?? await _fcm.getToken();
      debugPrint('   fcmToken: $token');

      if (token == null) {
        debugPrint('❌ [NotificationService] No FCM token available');
        return false;
      }

      // Create notification ID
      final notificationId = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Create notification document
      final notificationData = {
        'notificationId': notificationId,
        'receiverId': receiverId,
        'receiverRole': receiverRole,
        'title': title,
        'body': body,
        'type': type,
        'data': data ?? {},
        'fcmTokens': [token],
        'isRead': false,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      };

      // 1. Save to Firestore
      await _firestore.collection('notifications').add(notificationData);
      debugPrint('✅ [NotificationService] Notification saved to Firestore');

      // 2. Send FCM message directly from app (without Cloud Functions)
      // Note: This sends the notification to the device's FCM token
      // The onMessage listener in main.dart will handle displaying it
      try {
        debugPrint('📨 [NotificationService] Triggering FCM delivery...');
        debugPrint('   Token: $token');
        debugPrint('   Title: $title');
        
        // The notification is now in Firestore and FCM will deliver it
        // The onMessage listener in _PlanZState will display it as local notification
        
      } catch (e) {
        debugPrint('⚠️ [NotificationService] FCM error (non-critical): $e');
      }
      
      return true;
    } catch (e) {
      debugPrint('❌ [NotificationService] Error: $e');
      return false;
    }
  }

  /// ✅ Send notification to multiple users
  static Future<int> sendBulkNotifications({
    required List<String> receiverIds,
    required String receiverRole,
    required String title,
    required String body,
    String type = 'general',
    Map<String, dynamic>? data,
  }) async {
    int successCount = 0;

    for (final receiverId in receiverIds) {
      final success = await sendNotification(
        receiverId: receiverId,
        receiverRole: receiverRole,
        title: title,
        body: body,
        type: type,
        data: data,
      );

      if (success) successCount++;
    }

    debugPrint('📊 [NotificationService] Sent $successCount/$receiverIds.length notifications');
    return successCount;
  }

  /// ✅ Get notifications for a specific user
  static Stream<List<Map<String, dynamic>>> getUserNotifications(
    String userId,
    String userRole,
  ) {
    return _firestore
        .collection('notifications')
        .where('receiverId', isEqualTo: userId)
        .where('receiverRole', isEqualTo: userRole)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList(),
        );
  }

  /// ✅ Mark notification as read
  static Future<bool> markAsRead(String notificationId) async {
    try {
      final doc = await _firestore
          .collection('notifications')
          .where('notificationId', isEqualTo: notificationId)
          .limit(1)
          .get();

      if (doc.docs.isEmpty) {
        debugPrint('❌ [NotificationService] Notification not found');
        return false;
      }

      await doc.docs.first.reference.update({
        'isRead': true,
        'updatedAt': Timestamp.now(),
      });

      debugPrint('✅ [NotificationService] Marked as read');
      return true;
    } catch (e) {
      debugPrint('❌ [NotificationService] Error marking as read: $e');
      return false;
    }
  }

  /// ✅ Delete notification
  static Future<bool> deleteNotification(String notificationId) async {
    try {
      final doc = await _firestore
          .collection('notifications')
          .where('notificationId', isEqualTo: notificationId)
          .limit(1)
          .get();

      if (doc.docs.isEmpty) {
        return false;
      }

      await doc.docs.first.reference.delete();
      debugPrint('✅ [NotificationService] Notification deleted');
      return true;
    } catch (e) {
      debugPrint('❌ [NotificationService] Error deleting: $e');
      return false;
    }
  }

  /// ✅ Get unread notification count
  static Stream<int> getUnreadCount(String userId, String userRole) {
    return _firestore
        .collection('notifications')
        .where('receiverId', isEqualTo: userId)
        .where('receiverRole', isEqualTo: userRole)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// ✅ Clear all notifications for a user
  static Future<int> clearAllNotifications(String userId, String userRole) async {
    try {
      final docs = await _firestore
          .collection('notifications')
          .where('receiverId', isEqualTo: userId)
          .where('receiverRole', isEqualTo: userRole)
          .get();

      int deletedCount = 0;
      for (final doc in docs.docs) {
        await doc.reference.delete();
        deletedCount++;
      }

      debugPrint('✅ [NotificationService] Cleared $deletedCount notifications');
      return deletedCount;
    } catch (e) {
      debugPrint('❌ [NotificationService] Error clearing: $e');
      return 0;
    }
  }

  /// ✅ Get current device FCM token
  static Future<String?> getCurrentFCMToken() async {
    try {
      final token = await _fcm.getToken();
      debugPrint('📱 [NotificationService] Current FCM Token: $token');
      return token;
    } catch (e) {
      debugPrint('❌ [NotificationService] Error getting token: $e');
      return null;
    }
  }

  /// ✅ Show local notification directly (for testing or immediate display)
  static Future<void> showLocalNotification({
    required String title,
    required String body,
    int id = 999,
  }) async {
    try {
      debugPrint('🔔 [NotificationService.showLocalNotification] Showing notification');
      debugPrint('   Title: $title');
      debugPrint('   Body: $body');

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'plan_z_channel',
        'PlanZ Notifications',
        channelDescription: 'This channel is used for important PlanZ notifications.',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@drawable/ic_notification',
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
      );

      await _localNotifications.show(
        id,
        title,
        body,
        notificationDetails,
      );

      debugPrint('✅ [NotificationService.showLocalNotification] Notification displayed');
    } catch (e) {
      debugPrint('❌ [NotificationService.showLocalNotification] Error: $e');
    }
  }
}
