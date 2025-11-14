# 📢 Notification System - Complete Implementation Guide

## 🎯 Overview

تم إنشاء نظام notifications شامل للتطبيق يدعم جميع الـ 4 user types:
1. **Event Owner** - منظم الحدث
2. **Vendor** - مزود الخدمات
3. **Attendee** - الضيف
4. **App Owner** - مدير التطبيق

---

## 📁 Files Created/Modified

### 1. **NotificationService** (New)
**File:** `lib/core/services/notification_service.dart`

**Purpose:** Service شامل لإدارة جميع عمليات الـ notifications

**Key Methods:**

```dart
// ✅ Send notification to a specific user
static Future<bool> sendNotification({
  required String receiverId,
  required String receiverRole,
  required String title,
  required String body,
  String type = 'general',
  Map<String, dynamic>? data,
  String? fcmToken,
})

// ✅ Send notifications to multiple users
static Future<int> sendBulkNotifications({
  required List<String> receiverIds,
  required String receiverRole,
  required String title,
  required String body,
  String type = 'general',
  Map<String, dynamic>? data,
})

// ✅ Get notifications for a specific user
static Stream<List<Map<String, dynamic>>> getUserNotifications(
  String userId,
  String userRole,
)

// ✅ Mark notification as read
static Future<bool> markAsRead(String notificationId)

// ✅ Delete notification
static Future<bool> deleteNotification(String notificationId)

// ✅ Get unread notification count
static Stream<int> getUnreadCount(String userId, String userRole)

// ✅ Clear all notifications for a user
static Future<int> clearAllNotifications(String userId, String userRole)

// ✅ Get current device FCM token
static Future<String?> getCurrentFCMToken()
```

---

### 2. **OwnerHomeScreen** (Modified)
**File:** `lib/features/event_owners/event_owner_home/ui/screens/owner_home_screen.dart`

**Changes:**
- ✅ Added import for `NotificationService`
- ✅ Added "Test Notification" button in Quick Actions section
- ✅ Added `_testNotification()` method to send test notifications

**Test Button Features:**
- Shows loading dialog while sending
- Uses hardcoded FCM token for testing
- Displays success/error snackbar
- Logs to console for debugging

---

## 🚀 How to Use

### 1. **Send Notification to a User**

```dart
import 'package:plan_z/core/services/notification_service.dart';

// Send notification
final success = await NotificationService.sendNotification(
  receiverId: 'user123',
  receiverRole: 'event_owner',
  title: 'Event Approved',
  body: 'Your event has been approved!',
  type: 'event_approval',
  data: {
    'eventId': 'event456',
    'eventName': 'Wedding Party',
  },
);

if (success) {
  print('✅ Notification sent');
} else {
  print('❌ Failed to send');
}
```

### 2. **Send Bulk Notifications**

```dart
final count = await NotificationService.sendBulkNotifications(
  receiverIds: ['user1', 'user2', 'user3'],
  receiverRole: 'vendor',
  title: 'New Package Request',
  body: 'You have a new package request!',
  type: 'package_request',
);

print('Sent to $count users');
```

### 3. **Listen to User Notifications (Real-time)**

```dart
StreamBuilder<List<Map<String, dynamic>>>(
  stream: NotificationService.getUserNotifications(userId, 'event_owner'),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final notifications = snapshot.data!;
      return ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return ListTile(
            title: Text(notif['title']),
            subtitle: Text(notif['body']),
          );
        },
      );
    }
    return const CircularProgressIndicator();
  },
)
```

### 4. **Get Unread Count**

```dart
StreamBuilder<int>(
  stream: NotificationService.getUnreadCount(userId, 'event_owner'),
  builder: (context, snapshot) {
    final unreadCount = snapshot.data ?? 0;
    return Badge(
      label: Text('$unreadCount'),
      child: const Icon(Icons.notifications),
    );
  },
)
```

### 5. **Mark as Read**

```dart
await NotificationService.markAsRead(notificationId);
```

### 6. **Delete Notification**

```dart
await NotificationService.deleteNotification(notificationId);
```

---

## 📊 Firestore Structure

### Collection: `notifications`

```dart
{
  notificationId: "1234567890",
  receiverId: "user123",
  receiverRole: "event_owner",  // 'attendee', 'vendor', 'event_owner', 'app_owner'
  senderRole: "system",
  senderId: "system",
  type: "event_approval",  // 'package_request', 'payment', 'invitation', etc.
  title: "Event Approved",
  body: "Your event has been approved!",
  data: {
    "eventId": "event456",
    "eventName": "Wedding Party"
  },
  fcmTokens: ["token1", "token2"],
  isRead: false,
  createdAt: Timestamp,
  updatedAt: Timestamp,
}
```

---

## 🧪 Testing

### Test Button in Owner Home Screen

1. **Navigate to:** Event Owner Home Screen
2. **Find:** "Test Notification" button in Quick Actions
3. **Click:** The button
4. **See:** Loading dialog
5. **Result:** Success/Error snackbar

**Console Output:**
```
✅ [NotificationService] Sending notification...
   receiverId: user123
   receiverRole: event_owner
   title: ✅ Test Notification
   type: test
   fcmToken: cwcBijL2RGK20WFfNM38JW:APA91bHlZA6i8BPUAJPZudhp9_ZULvC8f7aGgYdMa1YBj9wekAa0Eck78wnVf8HkAfkeeOm-YxfEp6mBkWvpsvTOJeI5wzGMAsQt05WtrYXPCyESUfjAiow
✅ [NotificationService] Notification saved to Firestore
```

---

## 🔌 Integration Points

### Where to Send Notifications:

#### 1. **Event Owner Notifications:**
- ✅ Package request accepted/rejected
- ✅ All vendors approved
- ✅ Payment processed
- ✅ Guest accepted/rejected invitation
- ✅ Event status changed

**Location:** `event_owner_repo_impl.dart`
```dart
// When vendor accepts package
await NotificationService.sendNotification(
  receiverId: eventOwnerId,
  receiverRole: 'event_owner',
  title: 'Vendor Accepted',
  body: 'Vendor $vendorName accepted your package request',
  type: 'package_accepted',
  data: {'eventId': eventId, 'vendorId': vendorId},
);
```

#### 2. **Vendor Notifications:**
- ✅ New package request
- ✅ Package request cancelled
- ✅ Withdrawal approved/rejected
- ✅ Payment received

**Location:** `vendor_repository_impl.dart`
```dart
// When new package request created
await NotificationService.sendNotification(
  receiverId: vendorId,
  receiverRole: 'vendor',
  title: 'New Package Request',
  body: 'Event Owner $ownerName requested your package',
  type: 'package_request',
  data: {'requestId': requestId, 'eventId': eventId},
);
```

#### 3. **Attendee Notifications:**
- ✅ New invitation received
- ✅ Invitation cancelled
- ✅ Event details changed
- ✅ Event reminder

**Location:** `event_owner_repo_impl.dart`
```dart
// When invitation sent
await NotificationService.sendNotification(
  receiverId: attendeeId,
  receiverRole: 'attendee',
  title: 'You\'re Invited!',
  body: 'You\'re invited to $eventName on $eventDate',
  type: 'invitation',
  data: {'invitationId': invitationId, 'eventId': eventId},
);
```

#### 4. **App Owner Notifications:**
- ✅ New package pending approval
- ✅ New withdrawal request
- ✅ Daily revenue report
- ✅ System alerts

**Location:** `app_owner_repo_impl.dart`
```dart
// When new package created
await NotificationService.sendNotification(
  receiverId: appOwnerId,
  receiverRole: 'app_owner',
  title: 'New Package Pending',
  body: 'Vendor $vendorName created a new package',
  type: 'package_pending',
  data: {'packageId': packageId, 'vendorId': vendorId},
);
```

---

## 📱 FCM Token Management

### Getting FCM Token:

```dart
// In auth_repo_impl.dart during signup
final fcmToken = await FirebaseMessaging.instance.getToken();

// Save to user document
await _firestore.collection('users').doc(userId).set({
  'fcmToken': fcmToken,
  // ... other fields
});
```

### Using FCM Token:

```dart
// Option 1: Get current device token
final token = await NotificationService.getCurrentFCMToken();

// Option 2: Use stored token from user document
final success = await NotificationService.sendNotification(
  receiverId: userId,
  receiverRole: 'event_owner',
  title: 'Test',
  body: 'Test message',
  fcmToken: storedToken,  // Optional - if not provided, gets from current device
);
```

---

## 🔍 Debug Logging

All methods include comprehensive debug logging:

```dart
📤 [NotificationService] Sending notification...
   receiverId: user123
   receiverRole: event_owner
   title: Event Approved
   type: event_approval
   fcmToken: token123

✅ [NotificationService] Notification saved to Firestore

📊 [NotificationService] Sent 3/5 notifications
```

---

## ⚠️ Important Notes

1. **FCM Token:** Must be obtained from Firebase Messaging
2. **Firestore:** Notifications stored in `notifications` collection
3. **Real-time:** Use Streams for real-time notification updates
4. **Cleanup:** Clear old notifications periodically
5. **Permissions:** Request notification permissions on app startup

---

## 🚀 Next Steps

1. ✅ Integrate notifications in package request flow
2. ✅ Integrate notifications in payment flow
3. ✅ Integrate notifications in invitation flow
4. ✅ Integrate notifications in withdrawal flow
5. ✅ Create notification UI screens for each user type
6. ✅ Add notification preferences/settings
7. ✅ Implement notification reminders

---

## 📞 Support

For issues or questions:
1. Check console logs for debug messages
2. Verify Firestore collection structure
3. Ensure FCM token is valid
4. Check user roles and IDs

---

**Created:** November 14, 2025
**Version:** 1.0
**Status:** Ready for Integration
