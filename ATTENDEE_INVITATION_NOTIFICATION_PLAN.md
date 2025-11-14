# 📢 Attendee Invitation Notifications - Implementation Plan

## 🎯 السيناريو:

```
Event Owner ينشئ Event
    ↓
يذهب لـ Select Guests Screen
    ↓
يختار Attendees من القائمة
    ↓
يضغط "Send Invitations" (In-App)
    ↓
✅ يجب إرسال Notification لكل Attendee:
   "You're invited to Event X!"
```

---

## 📊 البيانات المتاحة:

### في SelectGuestsScreen:
```dart
// عندك:
_attendeesList: List<UserModel>  // كل attendee يحتوي على:
  ├── id (attendeeId)
  ├── name
  ├── email
  ├── phoneNumber
  ├── fcmToken ✅ (موجود في UserModel)
  └── fcmTokens (multiple devices)

// عند الضغط على Send:
_selectedGuestIds: Set<String>  // معرفات الـ attendees المختارين
```

### في EventInvitationModel:
```dart
class EventInvitationModel {
  final String invitationId;
  final String eventId;
  final String eventName;
  final String eventOwnerId;
  final String eventOwnerName;
  final DateTime eventDate;
  final String? eventType;
  final String? attendeeId;
  final String inviteeName;
  final String? inviteeEmail;
  final String? inviteePhone;
  final InvitationType invitationType;  // 'inApp' or 'phone'
  final String? personalMessage;
  final int guestCount;
  // ... timestamps
}
```

---

## 🔄 الحل:

### الخطوة 1️⃣: تعديل sendBulkInvitations في Repository

**File:** `lib/features/event_owners/create_event_screen/data/repo/event_owner_repo_impl.dart`

```dart
@override
Future<Either<Failure, List<EventInvitationModel>>> sendBulkInvitations({
  required String eventId,
  required String eventName,
  required String eventOwnerId,
  required String eventOwnerName,
  String? eventOwnerEmail,
  required DateTime eventDate,
  String? eventLocation,
  String? eventCity,
  String? eventAddress,
  String? eventType,
  int? expectedGuestCount,
  required List<Map<String, dynamic>> invitees,
}) async {
  try {
    final List<EventInvitationModel> invitations = [];
    final batch = _firestore.batch();

    for (var invitee in invitees) {
      final invitationId = _uuid.v4();

      final invitation = EventInvitationModel(
        invitationId: invitationId,
        eventId: eventId,
        eventName: eventName,
        eventOwnerId: eventOwnerId,
        eventOwnerName: eventOwnerName,
        eventOwnerEmail: eventOwnerEmail,
        eventDate: eventDate,
        eventLocation: eventLocation,
        eventCity: eventCity,
        eventAddress: eventAddress,
        eventType: eventType,
        expectedGuestCount: expectedGuestCount,
        attendeeId: invitee['attendeeId'],
        inviteeName: invitee['inviteeName'],
        inviteeEmail: invitee['inviteeEmail'],
        inviteePhone: invitee['inviteePhone'],
        invitationType: InvitationType.values.firstWhere(
          (t) => t.name == invitee['invitationType'],
          orElse: () => InvitationType.email,
        ),
        personalMessage: invitee['personalMessage'],
        guestCount: invitee['guestCount'] ?? 1,
      );

      final docRef = _firestore
          .collection(FirebaseCollections.eventInvitations)
          .doc(invitationId);

      batch.set(docRef, invitation.toJson());
      invitations.add(invitation);

      // ✅ إرسال notification للـ attendee
      final attendeeId = invitee['attendeeId'] as String?;
      final attendeeFcmToken = invitee['attendeeFcmToken'] as String?;
      
      if (attendeeId != null && attendeeFcmToken != null && attendeeFcmToken.isNotEmpty) {
        try {
          await NotificationService.sendNotification(
            receiverId: attendeeId,
            receiverRole: 'attendee',
            title: '🎉 Event Invitation',
            body: 'You\'re invited to: $eventName',
            type: 'invitation',
            data: {
              'invitationId': invitationId,
              'eventId': eventId,
              'eventName': eventName,
              'eventDate': eventDate.toIso8601String(),
              'eventOwnerName': eventOwnerName,
            },
            fcmToken: attendeeFcmToken,
          );

          debugPrint('✅ Notification sent to attendee: $attendeeId');
        } catch (e) {
          debugPrint('⚠️ Error sending notification to $attendeeId: $e');
        }
      }
    }

    await batch.commit();
    await updateInvitationCounts(eventId);

    return Right(invitations);
  } on FirebaseException catch (e) {
    return Left(ServerFailure(e.message ?? 'Failed to send invitations'));
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}
```

### الخطوة 2️⃣: تعديل SelectGuestsScreen

**File:** `lib/features/event_owners/create_event_screen/ui/screens/select_guests_screen.dart`

```dart
// ✅ إضافة import
import 'package:plan_z/core/services/notification_service.dart';

// في _sendInvitations method:
Future<void> _sendInvitations() async {
  if (_selectedCount == 0) {
    _showError('Please select at least one guest');
    return;
  }

  setState(() => _isSendingInvitations = true);

  try {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _showError('User not authenticated');
      setState(() => _isSendingInvitations = false);
      return;
    }

    debugPrint('📨 Sending invitations to $_selectedCount guests...');

    final personalMessage = _personalMessageController.text.trim();

    // ✅ Prepare Invitee Data from selected attendees
    final List<Map<String, dynamic>> inviteesData = [];

    for (final attendeeId in _selectedGuestIds) {
      final attendee = _attendeesList.firstWhere(
        (a) => a.id == attendeeId,
        orElse: () => UserModel(
          id: '',
          name: '',
          email: '',
          userType: UserType.attendee,
          isActive: true,
        ),
      );

      if (attendee.id.isNotEmpty) {
        inviteesData.add({
          'attendeeId': attendee.id,
          'inviteeName': attendee.name,
          'inviteeEmail': attendee.email,
          'inviteePhone': attendee.phoneNumber ?? '',
          'invitationType': 'inApp',
          'guestCount': 1,
          'personalMessage': personalMessage.isEmpty ? null : personalMessage,
          'attendeeFcmToken': attendee.fcmToken,  // ✅ إضافة FCM Token
        });
      }
    }

    debugPrint('✅ Invitees Data prepared: ${inviteesData.length} guests');

    // ✅ Call Cubit to Send Bulk Invitations
    if (!mounted) return;

    context.read<EventOwnerCubit>().sendBulkInvitations(
      eventId: widget.eventId,
      eventName: widget.eventName,
      eventOwnerId: currentUser.uid,
      eventOwnerName: currentUser.displayName ?? 'Event Owner',
      eventDate: widget.eventDate,
      eventType: widget.eventType,
      invitees: inviteesData,
    );

    // ✅ Show Success Dialog
    if (!mounted) return;
    _showSuccessDialog();
  } catch (e) {
    debugPrint('❌ Error sending invitations: $e');
    _showError('Failed to send invitations: ${e.toString()}');
    setState(() => _isSendingInvitations = false);
  }
}
```

---

## 📝 ملخص التعديلات:

### 1. **SelectGuestsScreen** - إضافة FCM Token للـ invitees data
```dart
'attendeeFcmToken': attendee.fcmToken,  // ✅ جديد
```

### 2. **EventOwnerRepositoryImpl.sendBulkInvitations** - إرسال notifications
```dart
// ✅ إرسال notification للـ attendee
if (attendeeId != null && attendeeFcmToken != null) {
  await NotificationService.sendNotification(
    receiverId: attendeeId,
    receiverRole: 'attendee',
    title: '🎉 Event Invitation',
    body: 'You\'re invited to: $eventName',
    type: 'invitation',
    fcmToken: attendeeFcmToken,
  );
}
```

---

## 🧪 Console Output المتوقع:

```
📨 Sending invitations to 3 guests...
✅ Invitees Data prepared: 3 guests

📤 [NotificationService] Sending notification...
   receiverId: attendee-123
   receiverRole: attendee
   title: 🎉 Event Invitation
   body: You're invited to: Birthday Party
   type: invitation
   fcmToken: cwcBijL2RGK20WFfNM38JW:APA91bHlZA6i8BPUAJPZudhp9_ZULvC8f7aGgYdMa1YBj9wekAa0Eck78wnVf8HkAfkeeOm-YxfEp6mBkWvpsvTOJeI5wzGMAsQt05WtrYXPCyESUfjAiow

✅ [NotificationService] Notification saved to Firestore

🔔 [NotificationService.showLocalNotification] Showing notification
   Title: 🎉 Event Invitation
   Body: You're invited to: Birthday Party

✅ [NotificationService.showLocalNotification] Notification displayed

✅ Notification sent to attendee: attendee-123

... (تكرار لكل attendee)

✅ Invitations Sent! ✅
```

---

## 🎯 النتيجة النهائية:

✅ **Attendees يستقبلون notifications فوراً عندما Event Owner يبعت لهم دعوات**

✅ **كل notification تحتوي على:**
- معرّف الـ attendee
- اسم الـ event
- تاريخ الـ event
- اسم الـ event owner

✅ **Notifications محفوظة في Firestore للـ history**

✅ **Local notifications تظهر فوراً على جهاز الـ attendee**

✅ **في حالة WhatsApp - لا نحتاج FCM token (بيستخدم رقم الهاتف مباشرة)**

---

## 📌 ملاحظات مهمة:

1. **UserModel بالفعل يحتوي على fcmToken** - لا نحتاج تعديلات إضافية
2. **WhatsApp لا يحتاج notifications** - لأنه بيفتح التطبيق مباشرة
3. **In-App invitations تحتاج notifications** - عشان الـ attendee يعرف إنه اتدعي
4. **الـ notifications بتُحفظ في Firestore** - للـ history والـ tracking

---

**Status:** Ready for Implementation
**Date:** November 14, 2025
