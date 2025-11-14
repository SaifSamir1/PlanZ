// lib/features/vendor/data/models/package_request_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

enum RequestStatus {
  pending,    // في انتظار رد الـ Vendor
  accepted,   // الـ Vendor وافق
  rejected,   // الـ Vendor رفض
  expired,    // انتهت المدة (24 ساعة)
  cancelled,  // الـ Event Owner ألغى الطلب
}

class PackageRequestModel {
  final String requestId;
  
  // Event Owner Info
  final String eventOwnerId;
  final String eventOwnerName;
  final String eventOwnerEmail;
  final String? eventOwnerPhone;
  
  // Vendor Info
  final String vendorId;
  final String vendorName;
  
  // Package Info
  final String packageId;
  final String packageName;
  final String serviceId;
  final String serviceName;
  final double? packagePrice;
  
  // Event Info
  final String eventId;
  final String eventName;
  final String eventType;
  final DateTime eventDate;
  final String? eventLocation;
  final int? guestCount;
  
  // Request Details
  final String? message; // رسالة من الـ Event Owner
  final Map<String, dynamic>? customRequirements;
  
  // Status & Response
  final RequestStatus status;
  final bool isAccepted; // الـ Vendor قبل
  final bool isExpired;  // انتهى الوقت
  
  // Vendor Response
  final String? vendorResponse;
  final String? rejectionReason;
  final DateTime? respondedAt;
  
  // Timing (24 hours expiry)
  final DateTime requestedAt;
  final DateTime expiresAt; // ✅ 24 hours from requestedAt
  final DateTime? acceptedAt;
  final DateTime? rejectedAt;
  
  // Notifications
  final bool vendorNotified;
  final bool ownerNotifiedOfResponse;
  
  final DateTime createdAt;
  final DateTime updatedAt;

  PackageRequestModel({
    required this.requestId,
    required this.eventOwnerId,
    required this.eventOwnerName,
    required this.eventOwnerEmail,
    required this.packagePrice,
    this.eventOwnerPhone,
    required this.vendorId,
    required this.vendorName,
    required this.packageId,
    required this.packageName,
    required this.serviceId,
    required this.serviceName,
    required this.eventId,
    required this.eventName,
    required this.eventType,
    required this.eventDate,
    this.eventLocation,
    this.guestCount,
    this.message,
    this.customRequirements,
    this.status = RequestStatus.pending,
    this.isAccepted = false,
    bool? isExpired,
    this.vendorResponse,
    this.rejectionReason,
    this.respondedAt,
    DateTime? requestedAt,
    DateTime? expiresAt,
    this.acceptedAt,
    this.rejectedAt,
    this.vendorNotified = false,
    this.ownerNotifiedOfResponse = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : requestedAt = requestedAt ?? DateTime.now(),
        expiresAt = expiresAt ??
            (requestedAt ?? DateTime.now()).add(const Duration(hours: 24)),
        isExpired = isExpired ??
            DateTime.now().isAfter(
              expiresAt ??
                  (requestedAt ?? DateTime.now()).add(const Duration(hours: 24)),
            ),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory PackageRequestModel.fromJson(Map<String, dynamic> json) {
    // ✅ Get packagePrice from root or customRequirements
    double? packagePrice = (json['packagePrice'] as num?)?.toDouble();
    
    // ✅ If not in root, check customRequirements
    if (packagePrice == null && json['customRequirements'] != null) {
      final customReqs = json['customRequirements'] as Map<String, dynamic>;
      packagePrice = (customReqs['packagePrice'] as num?)?.toDouble();
    }
    
    return PackageRequestModel(
      packagePrice: packagePrice,
      requestId: json['requestId'] ?? '',
      eventOwnerId: json['eventOwnerId'] ?? '',
      eventOwnerName: json['eventOwnerName'] ?? '',
      eventOwnerEmail: json['eventOwnerEmail'] ?? '',
      eventOwnerPhone: json['eventOwnerPhone'],
      vendorId: json['vendorId'] ?? '',
      vendorName: json['vendorName'] ?? '',
      packageId: json['packageId'] ?? '',
      packageName: json['packageName'] ?? '',
      serviceId: json['serviceId'] ?? '',
      serviceName: json['serviceName'] ?? '',
      eventId: json['eventId'] ?? '',
      eventName: json['eventName'] ?? '',
      eventType: json['eventType'] ?? '',
      eventDate: json['eventDate'] != null
          ? (json['eventDate'] is Timestamp
              ? (json['eventDate'] as Timestamp).toDate()
              : DateTime.parse(json['eventDate']))
          : DateTime.now(),
      eventLocation: json['eventLocation'],
      guestCount: json['guestCount'],
      message: json['message'],
      customRequirements: json['customRequirements'] != null
          ? Map<String, dynamic>.from(json['customRequirements'])
          : null,
      status: RequestStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => RequestStatus.pending,
      ),
      isAccepted: json['isAccepted'] ?? false,
      isExpired: json['isExpired'] ?? false,
      vendorResponse: json['vendorResponse'],
      rejectionReason: json['rejectionReason'],
      respondedAt: json['respondedAt'] != null
          ? (json['respondedAt'] is Timestamp
              ? (json['respondedAt'] as Timestamp).toDate()
              : DateTime.parse(json['respondedAt']))
          : null,
      requestedAt: json['requestedAt'] != null
          ? (json['requestedAt'] is Timestamp
              ? (json['requestedAt'] as Timestamp).toDate()
              : DateTime.parse(json['requestedAt']))
          : DateTime.now(),
      expiresAt: json['expiresAt'] != null
          ? (json['expiresAt'] is Timestamp
              ? (json['expiresAt'] as Timestamp).toDate()
              : DateTime.parse(json['expiresAt']))
          : null,
      acceptedAt: json['acceptedAt'] != null
          ? (json['acceptedAt'] is Timestamp
              ? (json['acceptedAt'] as Timestamp).toDate()
              : DateTime.parse(json['acceptedAt']))
          : null,
      rejectedAt: json['rejectedAt'] != null
          ? (json['rejectedAt'] is Timestamp
              ? (json['rejectedAt'] as Timestamp).toDate()
              : DateTime.parse(json['rejectedAt']))
          : null,
      vendorNotified: json['vendorNotified'] ?? false,
      ownerNotifiedOfResponse: json['ownerNotifiedOfResponse'] ?? false,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is Timestamp
              ? (json['createdAt'] as Timestamp).toDate()
              : DateTime.parse(json['createdAt']))
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] is Timestamp
              ? (json['updatedAt'] as Timestamp).toDate()
              : DateTime.parse(json['updatedAt']))
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'eventOwnerId': eventOwnerId,
      'eventOwnerName': eventOwnerName,
      'eventOwnerEmail': eventOwnerEmail,
      'eventOwnerPhone': eventOwnerPhone,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'packageId': packageId,
      'packageName': packageName,
      'packagePrice': packagePrice,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'eventId': eventId,
      'eventName': eventName,
      'eventType': eventType,
      'eventDate': Timestamp.fromDate(eventDate),
      'eventLocation': eventLocation,
      'guestCount': guestCount,
      'message': message,
      'customRequirements': customRequirements,
      'status': status.name,
      'isAccepted': isAccepted,
      'isExpired': isExpired,
      'vendorResponse': vendorResponse,
      'rejectionReason': rejectionReason,
      'respondedAt': respondedAt != null ? Timestamp.fromDate(respondedAt!) : null,
      'requestedAt': Timestamp.fromDate(requestedAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'acceptedAt': acceptedAt != null ? Timestamp.fromDate(acceptedAt!) : null,
      'rejectedAt': rejectedAt != null ? Timestamp.fromDate(rejectedAt!) : null,
      'vendorNotified': vendorNotified,
      'ownerNotifiedOfResponse': ownerNotifiedOfResponse,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Helper Methods
  bool get isStillPending =>
      status == RequestStatus.pending && !isExpired;

  Duration get timeRemaining =>
      isExpired ? Duration.zero : expiresAt.difference(DateTime.now());

  String get timeRemainingFormatted {
    if (isExpired) return 'Expired';
    final remaining = timeRemaining;
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);
    return '${hours}h ${minutes}m remaining';
  }

  PackageRequestModel copyWith({
    String? requestId,
    String? eventOwnerId,
    String? eventOwnerName,
    String? eventOwnerEmail,
    String? eventOwnerPhone,
    String? vendorId,
    String? vendorName,
    String? packageId,
    String? packageName,
    String? serviceId,
    String? serviceName,
    String? eventId,
    String? eventName,
    String? eventType,
    DateTime? eventDate,
    String? eventLocation,
    int? guestCount,
    String? message,
    Map<String, dynamic>? customRequirements,
    RequestStatus? status,
    bool? isAccepted,
    bool? isExpired,
    String? vendorResponse,
    String? rejectionReason,
    DateTime? respondedAt,
    DateTime? requestedAt,
    DateTime? expiresAt,
    DateTime? acceptedAt,
    DateTime? rejectedAt,
    bool? vendorNotified,
    bool? ownerNotifiedOfResponse,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PackageRequestModel(
      packagePrice: packagePrice,
      requestId: requestId ?? this.requestId,
      eventOwnerId: eventOwnerId ?? this.eventOwnerId,
      eventOwnerName: eventOwnerName ?? this.eventOwnerName,
      eventOwnerEmail: eventOwnerEmail ?? this.eventOwnerEmail,
      eventOwnerPhone: eventOwnerPhone ?? this.eventOwnerPhone,
      vendorId: vendorId ?? this.vendorId,
      vendorName: vendorName ?? this.vendorName,
      packageId: packageId ?? this.packageId,
      packageName: packageName ?? this.packageName,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      eventId: eventId ?? this.eventId,
      eventName: eventName ?? this.eventName,
      eventType: eventType ?? this.eventType,
      eventDate: eventDate ?? this.eventDate,
      eventLocation: eventLocation ?? this.eventLocation,
      guestCount: guestCount ?? this.guestCount,
      message: message ?? this.message,
      customRequirements: customRequirements ?? this.customRequirements,
      status: status ?? this.status,
      isAccepted: isAccepted ?? this.isAccepted,
      isExpired: isExpired ?? this.isExpired,
      vendorResponse: vendorResponse ?? this.vendorResponse,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      respondedAt: respondedAt ?? this.respondedAt,
      requestedAt: requestedAt ?? this.requestedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      rejectedAt: rejectedAt ?? this.rejectedAt,
      vendorNotified: vendorNotified ?? this.vendorNotified,
      ownerNotifiedOfResponse:
          ownerNotifiedOfResponse ?? this.ownerNotifiedOfResponse,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
