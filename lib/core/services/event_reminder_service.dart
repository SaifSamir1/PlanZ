import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:plan_z/core/constants/constants.dart';

class EventReminderService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Initialize the local notifications plugin
  static Future<void> initNotifications() async {
    const androidSettings = AndroidInitializationSettings('@drawable/ic_notification');
    const initSettings =
        InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(initSettings);
  }

  /// Schedule reminders for upcoming events (2 days ahead)
  static Future<void> scheduleReminders() async {
    try {
      final now = DateTime.now();
      final startRange = now.add(const Duration(hours: 42));
      final endRange = now.add(const Duration(hours: 54));

      final eventsSnapshot = await _firestore
          .collection(FirebaseCollections.events)
          .where('eventDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startRange))
          .where('eventDate', isLessThanOrEqualTo: Timestamp.fromDate(endRange))
          .get();

      for (var eventDoc in eventsSnapshot.docs) {
        final eventData = eventDoc.data();
        final eventId = eventDoc.id;
        final eventName = eventData['eventName'] as String? ?? 'Event';
        final eventDate =
            (eventData['eventDate'] as Timestamp?)?.toDate() ?? DateTime.now();

        // Get accepted invitations
        final invitationsSnapshot = await _firestore
            .collection(FirebaseCollections.eventInvitations)
            .where('eventId', isEqualTo: eventId)
            .where('status', isEqualTo: 'accepted')
            .get();

        for (var invitationDoc in invitationsSnapshot.docs) {
          final invitationData = invitationDoc.data();
          final attendeeId = invitationData['attendeeId'] as String?;
          final reminderSent = invitationData['reminderSent'] as bool? ?? false;

          if (attendeeId != null && !reminderSent) {
            // Schedule local notification on device
            await _scheduleLocalNotification(
              title: '⏰ Event Reminder',
              body: 'Your event "$eventName" is happening in 2 days!',
              scheduledTime: eventDate.subtract(const Duration(days: 2)),
              id: eventId.hashCode,
            );

            await invitationDoc.reference.update({
              'reminderSent': true,
              'reminderSentAt': Timestamp.now(),
            });

            debugPrint('✅ Reminder scheduled locally for attendee: $attendeeId');
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Error scheduling reminders: $e');
    }
  }

  /// Helper: schedule a local notification
  static Future<void> _scheduleLocalNotification({
    required String title,
    required String body,
    required DateTime scheduledTime,
    int id = 0,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'plan_z_channel',
      'PlanZ Notifications',
      channelDescription: 'Channel for PlanZ notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    
  }
}
