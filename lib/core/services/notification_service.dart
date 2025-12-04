// lib/core/services/notification_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // Firestore instance
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // FCM instance
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // Local notifications plugin
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // -------------------- Initialization --------------------
  static Future<void> initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/ic_notification');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(initSettings);

    // Create notification channel (Android)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'plan_z_channel',
      'PlanZ Notifications',
      description: 'This channel is used for important PlanZ notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  // -------------------- Current Device Token --------------------
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

  // -------------------- Send Single Notification --------------------
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
      debugPrint(
        '   receiverId: $receiverId, role: $receiverRole, title: $title',
      );

      // Get FCM token if not provided
      String? token = fcmToken;
      if (token == null) {
        debugPrint(
          '🔍 [NotificationService] FCM token not provided, fetching from Firestore...',
        );
        // Determine collection based on role
        String collectionName;
        switch (receiverRole) {
          case 'vendor':
            collectionName = 'vendors';
            break;
          case 'eventOwner':
            collectionName = 'event_owners';
            break;
          case 'attendee':
            collectionName = 'attendees';
            break;
          case 'admin':
            collectionName = 'admins';
            break;
          default:
            collectionName = 'attendees'; // Default fallback
        }

        try {
          final userDoc = await _firestore
              .collection(collectionName)
              .doc(receiverId)
              .get();
          token = userDoc.data()?['fcmToken'] as String?;
          debugPrint('   Fetched FCM token: $token');
        } catch (e) {
          debugPrint('❌ Error fetching FCM token: $e');
          return false;
        }
      }

      if (token == null) {
        debugPrint(
          '❌ [NotificationService] No FCM token available for receiver - Notification will be saved but not sent via FCM',
        );
        // We still continue to save to Firestore so the user sees it in their in-app list
      }

      // Notification ID
      final notificationId = DateTime.now().millisecondsSinceEpoch.toString();

      // Save to Firestore
      final notificationData = {
        'notificationId': notificationId,
        'receiverId': receiverId,
        'receiverRole': receiverRole,
        'title': title,
        'body': body,
        'type': type,
        'data': data ?? {},
        'fcmTokens': token != null ? [token] : [],
        'isRead': false,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      };

      try {
        await _firestore.collection('notifications').add(notificationData);
        debugPrint('✅ Notification saved to Firestore');
        debugPrint(
          '   Firestore listener will display notification on all open devices',
        );
      } catch (e) {
        debugPrint('⚠️ Firestore save failed: $e');
        return false;
      }

      // ✅ Don't show local notification here - let Firestore listener handle it
      // This prevents duplicate notifications and ensures all devices get notified equally

      return true;
    } catch (e) {
      debugPrint('❌ Overall notification error: $e');
      return false;
    }
  }

  // -------------------- Bulk Notifications --------------------
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

    debugPrint('📊 Sent $successCount/${receiverIds.length} notifications');
    return successCount;
  }

  // -------------------- Local Notification --------------------
  static Future<void> showLocalNotification({
    required String title,
    required String body,
    int id = 999,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'plan_z_channel',
          'PlanZ Notifications',
          channelDescription: 'Important notifications for PlanZ users.',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@drawable/ic_notification',
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(id, title, body, platformDetails);
    debugPrint('✅ Local notification displayed: $title');
  }

  // -------------------- Firestore Streams --------------------
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
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  static Stream<int> getUnreadCount(String userId, String userRole) {
    return _firestore
        .collection('notifications')
        .where('receiverId', isEqualTo: userId)
        .where('receiverRole', isEqualTo: userRole)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // -------------------- Firestore Operations --------------------
  static Future<bool> markAsRead(String notificationId) async {
    try {
      final doc = await _firestore
          .collection('notifications')
          .where('notificationId', isEqualTo: notificationId)
          .limit(1)
          .get();

      if (doc.docs.isEmpty) return false;

      await doc.docs.first.reference.update({
        'isRead': true,
        'updatedAt': Timestamp.now(),
      });

      debugPrint('✅ Notification marked as read');
      return true;
    } catch (e) {
      debugPrint('❌ Error marking as read: $e');
      return false;
    }
  }

  static Future<bool> deleteNotification(String notificationId) async {
    try {
      final doc = await _firestore
          .collection('notifications')
          .where('notificationId', isEqualTo: notificationId)
          .limit(1)
          .get();

      if (doc.docs.isEmpty) return false;

      await doc.docs.first.reference.delete();
      debugPrint('✅ Notification deleted');
      return true;
    } catch (e) {
      debugPrint('❌ Error deleting notification: $e');
      return false;
    }
  }

  static Future<int> clearAllNotifications(
    String userId,
    String userRole,
  ) async {
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

      debugPrint('✅ Cleared $deletedCount notifications');
      return deletedCount;
    } catch (e) {
      debugPrint('❌ Error clearing notifications: $e');
      return 0;
    }
  }

  // -------------------- Background Event Reminders --------------------
  static Future<void> sendEventRemindersFromBackground() async {
    try {
      final now = DateTime.now();
      final startRange = now.add(const Duration(hours: 42));
      final endRange = now.add(const Duration(hours: 54));

      final eventsSnapshot = await _firestore
          .collection('events')
          .where(
            'eventDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startRange),
          )
          .where('eventDate', isLessThanOrEqualTo: Timestamp.fromDate(endRange))
          .get();

      for (var eventDoc in eventsSnapshot.docs) {
        final eventData = eventDoc.data();
        final eventId = eventDoc.id;
        final eventName = eventData['eventName'] ?? 'Event';

        final invitationsSnapshot = await _firestore
            .collection('event_invitations')
            .where('eventId', isEqualTo: eventId)
            .where('status', isEqualTo: 'accepted')
            .get();

        for (var invitationDoc in invitationsSnapshot.docs) {
          final attendeeId = invitationDoc.data()['attendeeId'];
          final reminderSent = invitationDoc.data()['reminderSent'] ?? false;

          if (attendeeId != null && !reminderSent) {
            await sendNotification(
              receiverId: attendeeId,
              receiverRole: 'attendee',
              title: '⏰ Event Reminder',
              body: 'Your event "$eventName" is happening in 2 days!',
              type: 'event_reminder',
              data: {'eventId': eventId, 'eventName': eventName},
            );

            await invitationDoc.reference.update({
              'reminderSent': true,
              'reminderSentAt': Timestamp.now(),
            });
          }
        }
      }
    } catch (e) {
      debugPrint('❌ [Background Notification] Error: $e');
    }
  }
}
