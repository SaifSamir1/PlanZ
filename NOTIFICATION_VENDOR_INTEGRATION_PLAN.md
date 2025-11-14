# 📢 Vendor Notification Integration Plan

## 🎯 السيناريو الكامل:

```
Event Owner ينشئ Event
    ↓
يختار Packages من Vendors
    ↓
يذهب لـ EventReviewScreen
    ↓
يضغط "Confirm Event"
    ↓
Event يُحفظ في Firestore
    ↓
✅ يجب إرسال Notification لكل Vendor:
   "Event Owner اختار package بتاعك!"
```

---

## 📊 البيانات المتاحة في كل مرحلة:

### 1. **في EventReviewScreen:**
```dart
// عندك كل البيانات:
widget.selectedPackages  // Map<String, PackageModel>
  ├── serviceId (key)
  └── package (value) = PackageModel
      ├── vendorId ✅
      ├── vendorName ✅
      ├── packageName ✅
      └── ... other fields
```

### 2. **في PackageModel:**
```dart
class PackageModel {
  final String vendorId;      // ✅ معرّف الـ Vendor
  final String vendorName;    // ✅ اسم الـ Vendor
  final String packageName;   // ✅ اسم الـ Package
  // ... other fields
}
```

### 3. **في UserModel:**
```dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? fcmToken;     // ✅ FCM Token للـ Vendor
  final List<String>? fcmTokens;  // ✅ Multiple devices
  // ... other fields
}
```

---

## 🔄 الحل الكامل:

### الخطوة 1: إضافة FCM Token إلى PackageModel

**المشكلة:** PackageModel لا يحتوي على FCM token الـ vendor

**الحل:** إضافة vendorFcmToken إلى PackageModel

```dart
// في lib/features/vendor_features/packages_mangment/data/models/package_model.dart

class PackageModel {
  final String packageId;
  final String vendorId;
  final String vendorName;
  final String? vendorFcmToken;  // ✅ إضافة هذا
  
  // ... rest of fields
  
  PackageModel({
    required this.packageId,
    required this.vendorId,
    required this.vendorName,
    this.vendorFcmToken,  // ✅ إضافة هنا
    // ... rest of parameters
  });
  
  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      packageId: json['packageId'] ?? '',
      vendorId: json['vendorId'] ?? '',
      vendorName: json['vendorName'] ?? '',
      vendorFcmToken: json['vendorFcmToken'],  // ✅ إضافة هنا
      // ... rest of fields
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'packageId': packageId,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'vendorFcmToken': vendorFcmToken,  // ✅ إضافة هنا
      // ... rest of fields
    };
  }
}
```

### الخطوة 2: تحديث EventService لتخزين FCM Token

**في EventModel:**

```dart
class EventService {
  final String serviceId;
  final String serviceName;
  final String packageId;
  final String packageName;
  final String vendorId;
  final String vendorName;
  final double packagePrice;
  final String? vendorFcmToken;  // ✅ إضافة هذا
  final bool vendorApproved;
  final String requestId;

  EventService({
    required this.serviceId,
    required this.serviceName,
    required this.packageId,
    required this.packageName,
    required this.vendorId,
    required this.vendorName,
    required this.packagePrice,
    this.vendorFcmToken,  // ✅ إضافة هنا
    this.vendorApproved = false,
    required this.requestId,
  });

  factory EventService.fromJson(Map<String, dynamic> json) {
    return EventService(
      serviceId: json['serviceId'] as String? ?? '',
      serviceName: json['serviceName'] as String? ?? '',
      packageId: json['packageId'] as String? ?? '',
      packageName: json['packageName'] as String? ?? '',
      vendorId: json['vendorId'] as String? ?? '',
      vendorName: json['vendorName'] as String? ?? '',
      packagePrice: (json['packagePrice'] as num?)?.toDouble() ?? 0.0,
      vendorFcmToken: json['vendorFcmToken'] as String?,  // ✅ إضافة هنا
      vendorApproved: json['vendorApproved'] as bool? ?? false,
      requestId: json['requestId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'serviceName': serviceName,
      'packageId': packageId,
      'packageName': packageName,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'packagePrice': packagePrice,
      'vendorFcmToken': vendorFcmToken,  // ✅ إضافة هنا
      'vendorApproved': vendorApproved,
      'requestId': requestId,
    };
  }

  EventService copyWith({
    String? serviceId,
    String? serviceName,
    String? packageId,
    String? packageName,
    String? vendorId,
    String? vendorName,
    double? packagePrice,
    String? vendorFcmToken,  // ✅ إضافة هنا
    bool? vendorApproved,
    String? requestId,
  }) {
    return EventService(
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      packageId: packageId ?? this.packageId,
      packageName: packageName ?? this.packageName,
      vendorId: vendorId ?? this.vendorId,
      vendorName: vendorName ?? this.vendorName,
      packagePrice: packagePrice ?? this.packagePrice,
      vendorFcmToken: vendorFcmToken ?? this.vendorFcmToken,  // ✅ إضافة هنا
      vendorApproved: vendorApproved ?? this.vendorApproved,
      requestId: requestId ?? this.requestId,
    );
  }
}
```

### الخطوة 3: تحديث EventReviewScreen

**عند الضغط على "Confirm Event":**

```dart
// في lib/features/event_owners/create_event_screen/ui/screens/event_review_screen.dart

// في الـ action button section
ElevatedButton(
  onPressed: () async {
    // 1. Create event
    final event = await _createEvent();
    
    // 2. Send notifications to all vendors
    await _sendVendorNotifications();
    
    // 3. Navigate
    Navigator.pushReplacementNamed(context, '/home');
  },
  child: const Text('Confirm Event'),
)

// الـ method للإرسال:
Future<void> _sendVendorNotifications() async {
  debugPrint('📢 [EventReviewScreen] Sending notifications to vendors...');
  
  // لكل package مختار
  for (var entry in widget.selectedPackages.entries) {
    final package = entry.value;  // PackageModel
    
    debugPrint('📤 Sending to vendor: ${package.vendorName}');
    debugPrint('   Vendor ID: ${package.vendorId}');
    debugPrint('   FCM Token: ${package.vendorFcmToken}');
    
    // إرسال الـ notification
    if (package.vendorFcmToken != null) {
      await NotificationService.sendNotification(
        receiverId: package.vendorId,
        receiverRole: 'vendor',
        title: '📦 New Package Request',
        body: 'Event Owner selected your package: ${package.packageName}',
        type: 'package_request',
        data: {
          'packageId': package.packageId,
          'packageName': package.packageName,
          'eventName': widget.eventInfo['eventName'],
          'eventDate': widget.eventInfo['eventDate'],
        },
        fcmToken: package.vendorFcmToken,
      );
      
      // عرض local notification فوراً
      await NotificationService.showLocalNotification(
        title: '📦 New Package Request',
        body: 'Event Owner selected your package: ${package.packageName}',
      );
    }
  }
  
  debugPrint('✅ [EventReviewScreen] All notifications sent!');
}
```

### الخطوة 4: تحديث CreateEventCubit

**عند إنشاء الـ Event:**

```dart
// في lib/features/event_owners/create_event_screen/cubits/create_event_cubit/create_event_cubit.dart

Future<void> createEvent(
  Map<String, dynamic> eventInfo,
  Map<String, dynamic> budgetData,
  Map<String, dynamic> servicesData,
  Map<String, PackageModel> selectedPackages,
) async {
  emit(CreateEventLoading());
  
  try {
    // 1. تحويل البيانات إلى EventModel
    final services = selectedPackages.entries.map((entry) {
      final package = entry.value;
      
      return EventService(
        serviceId: entry.key,
        serviceName: package.serviceName,
        packageId: package.packageId,
        packageName: package.packageName,
        vendorId: package.vendorId,
        vendorName: package.vendorName,
        packagePrice: package.price,
        vendorFcmToken: package.vendorFcmToken,  // ✅ تمرير FCM Token
        requestId: _generateRequestId(),
      );
    }).toList();
    
    final event = EventModel(
      eventId: _generateEventId(),
      eventOwnerId: userId,
      eventOwnerName: ownerName,
      eventOwnerEmail: ownerEmail,
      eventTypeId: eventInfo['eventTypeId'],
      eventTypeName: eventInfo['eventTypeName'],
      eventName: eventInfo['eventName'],
      eventDate: eventInfo['eventDate'],
      location: eventInfo['location'],
      totalBudget: budgetData['totalBudget'],
      allocatedBudget: _calculateAllocatedBudget(selectedPackages),
      remainingBudget: _calculateRemainingBudget(budgetData, selectedPackages),
      expectedGuestCount: eventInfo['guestCount'],
      services: services,  // ✅ مع FCM tokens
      totalAmount: _calculateTotalAmount(selectedPackages),
      remainingAmount: _calculateRemainingAmount(budgetData, selectedPackages),
      totalVendorsCount: selectedPackages.length,
      pendingVendorsCount: selectedPackages.length,
    );
    
    // 2. حفظ في Firestore
    await repository.createEvent(event);
    
    // 3. إرسال notifications للـ vendors
    await _sendVendorNotifications(selectedPackages);
    
    emit(CreateEventSuccess(event));
  } catch (e) {
    emit(CreateEventError(e.toString()));
  }
}

Future<void> _sendVendorNotifications(
  Map<String, PackageModel> selectedPackages,
) async {
  debugPrint('📢 [CreateEventCubit] Sending vendor notifications...');
  
  for (var entry in selectedPackages.entries) {
    final package = entry.value;
    
    if (package.vendorFcmToken != null) {
      await NotificationService.sendNotification(
        receiverId: package.vendorId,
        receiverRole: 'vendor',
        title: '📦 New Package Request',
        body: 'Event Owner selected your package: ${package.packageName}',
        type: 'package_request',
        data: {
          'packageId': package.packageId,
          'packageName': package.packageName,
        },
        fcmToken: package.vendorFcmToken,
      );
    }
  }
  
  debugPrint('✅ [CreateEventCubit] Vendor notifications sent!');
}
```

---

## 🔄 Data Flow الكامل:

```
1. Browse Packages Screen
   └─ PackageModel (with vendorFcmToken)
      └─ selectedPackages: Map<String, PackageModel>

2. Event Review Screen
   └─ widget.selectedPackages
      └─ لكل package:
         ├─ vendorId ✅
         ├─ vendorName ✅
         ├─ vendorFcmToken ✅
         └─ packageName ✅

3. Create Event Button
   └─ CreateEventCubit.createEvent()
      └─ EventModel.services: List<EventService>
         └─ لكل service:
            ├─ vendorId ✅
            ├─ vendorName ✅
            ├─ vendorFcmToken ✅
            └─ packageName ✅

4. Send Notifications
   └─ NotificationService.sendNotification()
      └─ receiverId: vendorId
      └─ fcmToken: vendorFcmToken
      └─ title: "📦 New Package Request"
      └─ body: "Event Owner selected your package"
```

---

## 📝 الملفات المطلوب تعديلها:

1. **`lib/features/vendor_features/packages_mangment/data/models/package_model.dart`**
   - إضافة `vendorFcmToken` field

2. **`lib/features/event_owners/create_event_screen/data/models/event_model.dart`**
   - إضافة `vendorFcmToken` إلى EventService class

3. **`lib/features/event_owners/create_event_screen/ui/screens/event_review_screen.dart`**
   - إضافة `_sendVendorNotifications()` method
   - استدعاؤها عند الضغط على "Confirm Event"

4. **`lib/features/event_owners/create_event_screen/cubits/create_event_cubit/create_event_cubit.dart`**
   - تحديث `createEvent()` method
   - إضافة `_sendVendorNotifications()` method

---

## ✅ الفوائد:

1. ✅ **FCM Token يُمرر عبر كل المراحل**
2. ✅ **Vendor يستقبل notification فوراً**
3. ✅ **البيانات محفوظة في Firestore**
4. ✅ **Notification يظهر على جهاز الـ Vendor**
5. ✅ **بدون مشاكل أو تعقيدات**

---

## 🧪 الاختبار:

1. اذهب لـ Browse Packages
2. اختر package من vendor
3. اذهب لـ Event Review
4. اضغط "Confirm Event"
5. **تحقق من:**
   - ✅ Notification تظهر في الـ console
   - ✅ Vendor يستقبل notification
   - ✅ البيانات محفوظة في Firestore

---

**Status:** Ready for Implementation
**Date:** November 14, 2025
