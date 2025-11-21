// lib/core/services/event_reminder_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:plan_z/core/constants/constants.dart';
import 'package:plan_z/core/services/notification_service.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_invitation_model.dart';

class EventReminderService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Check and send reminders for events happening tomorrow
  /// This should be called on app launch or periodically
  static Future<void> checkAndSendReminders() async {
    try {
      debugPrint('🔔 [EventReminderService] Checking for upcoming events...');

      // Calculate 2 days before event range (42-54 hours from now)
      final now = DateTime.now();
      final startRange = now.add(const Duration(hours: 42)); // 1.75 days
      final endRange = now.add(const Duration(hours: 54)); // 2.25 days

      debugPrint('   Checking events between $startRange and $endRange');

      // Query events happening in 2 days
      final eventsSnapshot = await _firestore
          .collection(FirebaseCollections.events)
          .where(
            'eventDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startRange),
          )
          .where('eventDate', isLessThanOrEqualTo: Timestamp.fromDate(endRange))
          .get();

      debugPrint(
        '   Found ${eventsSnapshot.docs.length} events happening tomorrow',
      );

      for (var eventDoc in eventsSnapshot.docs) {
        final eventData = eventDoc.data();
        final eventId = eventDoc.id;
        final eventName = eventData['eventName'] as String? ?? 'Event';
        final eventDate =
            (eventData['eventDate'] as Timestamp?)?.toDate() ?? DateTime.now();
        final eventLocation = eventData['location'] as String? ?? '';

        debugPrint('   📅 Processing event: $eventName');

        // Get all accepted invitations for this event
        final invitationsSnapshot = await _firestore
            .collection(FirebaseCollections.eventInvitations)
            .where('eventId', isEqualTo: eventId)
            .where('status', isEqualTo: InvitationStatus.accepted.name)
            .get();

        debugPrint(
          '      Found ${invitationsSnapshot.docs.length} accepted attendees',
        );

        // Send reminder to each accepted attendee
        for (var invitationDoc in invitationsSnapshot.docs) {
          final invitationData = invitationDoc.data();
          final attendeeId = invitationData['attendeeId'] as String?;
          final attendeeName =
              invitationData['inviteeName'] as String? ?? 'Attendee';
          final reminderSent = invitationData['reminderSent'] as bool? ?? false;

          // Only send if attendeeId exists and reminder hasn't been sent yet
          if (attendeeId != null && !reminderSent) {
            try {
              // Send reminder notification
              await NotificationService.sendNotification(
                receiverId: attendeeId,
                receiverRole: 'attendee',
                title: '⏰ Event Reminder',
                body: 'Your event "$eventName" is happening in 2 days!',
                type: 'event_reminder',
                data: {
                  'eventId': eventId,
                  'eventName': eventName,
                  'eventDate': eventDate.toIso8601String(),
                  'eventLocation': eventLocation,
                },
              );

              // Mark reminder as sent
              await invitationDoc.reference.update({
                'reminderSent': true,
                'reminderSentAt': Timestamp.now(),
              });

              debugPrint('      ✅ Reminder sent to: $attendeeName');
            } catch (e) {
              debugPrint(
                '      ❌ Failed to send reminder to $attendeeName: $e',
              );
            }
          } else if (reminderSent) {
            debugPrint('      ℹ️ Reminder already sent to: $attendeeName');
          } else {
            debugPrint('      ⚠️ No attendeeId for: $attendeeName');
          }
        }
      }

      debugPrint('✅ [EventReminderService] Reminder check completed');
    } catch (e) {
      debugPrint('❌ [EventReminderService] Error checking reminders: $e');
    }
  }

  /// ✅ Send event reminder to a specific attendee
  static Future<bool> sendEventReminder({
    required String attendeeId,
    required String eventId,
    required String eventName,
    required DateTime eventDate,
    String? eventLocation,
  }) async {
    try {
      await NotificationService.sendNotification(
        receiverId: attendeeId,
        receiverRole: 'attendee',
        title: '⏰ Event Reminder',
        body: 'Your event "$eventName" is happening in 2 days!',
        type: 'event_reminder',
        data: {
          'eventId': eventId,
          'eventName': eventName,
          'eventDate': eventDate.toIso8601String(),
          'eventLocation': eventLocation ?? '',
        },
      );

      return true;
    } catch (e) {
      debugPrint('❌ [sendEventReminder] Error: $e');
      return false;
    }
  }
}
