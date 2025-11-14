// lib/features/event_owner/data/models/event_invitation_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

enum InvitationStatus {
  pending,      // في انتظار الرد
  accepted,     // قبل الدعوة
  rejected,     // رفض الدعوة
  maybeAttending, // ربما يحضر
}

enum InvitationType {
  email,        // عن طريق الإيميل
  phone,        // عن طريق الموبايل
  inApp,        // دعوة داخل التطبيق لمستخدم مسجل
}

class EventInvitationModel {
  final String invitationId;
  
  // Event Info
  final String eventId;
  final String eventName;
  final String eventOwnerId;
  final String eventOwnerName;
  final String? eventOwnerEmail;
  
  // Event Details (✅ مهم جداً - بيانات الحدث الأساسية)
  final DateTime eventDate;
  final String? eventLocation;
  final String? eventCity;
  final String? eventAddress;
  final String? eventType;
  final int? expectedGuestCount;
  
  // Invitee Info
  final String? attendeeId; // إذا كان مسجل في التطبيق
  final String inviteeName;
  final String? inviteeEmail;
  final String? inviteePhone;
  
  // Invitation Details
  final InvitationType invitationType;
  final InvitationStatus status;
  final String? personalMessage; // رسالة شخصية من الـ Event Owner
  
  // Guest Count
  final int guestCount; // عدد الضيوف المسموح لهم
  final int? confirmedGuestCount; // عدد الضيوف المؤكدين
  
  // Response
  final String? responseMessage; // رسالة من المدعو
  final DateTime? respondedAt;
  
  // Reminders
  final bool reminderSent;
  final DateTime? reminderSentAt;
  final int reminderCount;
  
  // Invitation Link (for sharing)
  final String? invitationLink;
  final String? qrCode; // QR Code للدخول
  
  // Notifications
  final bool notificationSent;
  final String? fcmToken; // للإرسال المباشر
  
  // Timestamps
  final DateTime sentAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventInvitationModel({
    required this.invitationId,
    required this.eventId,
    required this.eventName,
    required this.eventOwnerId,
    required this.eventOwnerName,
    this.eventOwnerEmail,
    // ✅ Event Details
    required this.eventDate,
    this.eventLocation,
    this.eventCity,
    this.eventAddress,
    this.eventType,
    this.expectedGuestCount,
    // Invitee Info
    this.attendeeId,
    required this.inviteeName,
    this.inviteeEmail,
    this.inviteePhone,
    required this.invitationType,
    this.status = InvitationStatus.pending,
    this.personalMessage,
    this.guestCount = 1,
    this.confirmedGuestCount,
    this.responseMessage,
    this.respondedAt,
    this.reminderSent = false,
    this.reminderSentAt,
    this.reminderCount = 0,
    this.invitationLink,
    this.qrCode,
    this.notificationSent = false,
    this.fcmToken,
    DateTime? sentAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : sentAt = sentAt ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory EventInvitationModel.fromJson(Map<String, dynamic> json) {
    return EventInvitationModel(
      invitationId: json['invitationId'] ?? '',
      eventId: json['eventId'] ?? '',
      eventName: json['eventName'] ?? '',
      eventOwnerId: json['eventOwnerId'] ?? '',
      eventOwnerName: json['eventOwnerName'] ?? '',
      eventOwnerEmail: json['eventOwnerEmail'],
      // ✅ Event Details
      eventDate: json['eventDate'] != null
          ? (json['eventDate'] is Timestamp
              ? (json['eventDate'] as Timestamp).toDate()
              : DateTime.parse(json['eventDate']))
          : DateTime.now(),
      eventLocation: json['eventLocation'],
      eventCity: json['eventCity'],
      eventAddress: json['eventAddress'],
      eventType: json['eventType'],
      expectedGuestCount: json['expectedGuestCount'],
      // Invitee Info
      attendeeId: json['attendeeId'],
      inviteeName: json['inviteeName'] ?? '',
      inviteeEmail: json['inviteeEmail'],
      inviteePhone: json['inviteePhone'],
      invitationType: InvitationType.values.firstWhere(
        (t) => t.name == json['invitationType'],
        orElse: () => InvitationType.email,
      ),
      status: InvitationStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => InvitationStatus.pending,
      ),
      personalMessage: json['personalMessage'],
      guestCount: json['guestCount'] ?? 1,
      confirmedGuestCount: json['confirmedGuestCount'],
      responseMessage: json['responseMessage'],
      respondedAt: json['respondedAt'] != null
          ? (json['respondedAt'] is Timestamp
              ? (json['respondedAt'] as Timestamp).toDate()
              : DateTime.parse(json['respondedAt']))
          : null,
      reminderSent: json['reminderSent'] ?? false,
      reminderSentAt: json['reminderSentAt'] != null
          ? (json['reminderSentAt'] is Timestamp
              ? (json['reminderSentAt'] as Timestamp).toDate()
              : DateTime.parse(json['reminderSentAt']))
          : null,
      reminderCount: json['reminderCount'] ?? 0,
      invitationLink: json['invitationLink'],
      qrCode: json['qrCode'],
      notificationSent: json['notificationSent'] ?? false,
      fcmToken: json['fcmToken'],
      sentAt: json['sentAt'] != null
          ? (json['sentAt'] is Timestamp
              ? (json['sentAt'] as Timestamp).toDate()
              : DateTime.parse(json['sentAt']))
          : DateTime.now(),
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
      'invitationId': invitationId,
      'eventId': eventId,
      'eventName': eventName,
      'eventOwnerId': eventOwnerId,
      'eventOwnerName': eventOwnerName,
      'eventOwnerEmail': eventOwnerEmail,
      // ✅ Event Details
      'eventDate': Timestamp.fromDate(eventDate),
      'eventLocation': eventLocation,
      'eventCity': eventCity,
      'eventAddress': eventAddress,
      'eventType': eventType,
      'expectedGuestCount': expectedGuestCount,
      // Invitee Info
      'attendeeId': attendeeId,
      'inviteeName': inviteeName,
      'inviteeEmail': inviteeEmail,
      'inviteePhone': inviteePhone,
      'invitationType': invitationType.name,
      'status': status.name,
      'personalMessage': personalMessage,
      'guestCount': guestCount,
      'confirmedGuestCount': confirmedGuestCount,
      'responseMessage': responseMessage,
      'respondedAt':
          respondedAt != null ? Timestamp.fromDate(respondedAt!) : null,
      'reminderSent': reminderSent,
      'reminderSentAt':
          reminderSentAt != null ? Timestamp.fromDate(reminderSentAt!) : null,
      'reminderCount': reminderCount,
      'invitationLink': invitationLink,
      'qrCode': qrCode,
      'notificationSent': notificationSent,
      'fcmToken': fcmToken,
      'sentAt': Timestamp.fromDate(sentAt),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Helper Methods
  bool get isPending => status == InvitationStatus.pending;
  bool get isAccepted => status == InvitationStatus.accepted;
  bool get isRejected => status == InvitationStatus.rejected;

  EventInvitationModel copyWith({
    String? invitationId,
    String? eventId,
    String? eventName,
    String? eventOwnerId,
    String? eventOwnerName,
    String? eventOwnerEmail,
    // ✅ Event Details
    DateTime? eventDate,
    String? eventLocation,
    String? eventCity,
    String? eventAddress,
    String? eventType,
    int? expectedGuestCount,
    // Invitee Info
    String? attendeeId,
    String? inviteeName,
    String? inviteeEmail,
    String? inviteePhone,
    InvitationType? invitationType,
    InvitationStatus? status,
    String? personalMessage,
    int? guestCount,
    int? confirmedGuestCount,
    String? responseMessage,
    DateTime? respondedAt,
    bool? reminderSent,
    DateTime? reminderSentAt,
    int? reminderCount,
    String? invitationLink,
    String? qrCode,
    bool? notificationSent,
    String? fcmToken,
    DateTime? sentAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventInvitationModel(
      invitationId: invitationId ?? this.invitationId,
      eventId: eventId ?? this.eventId,
      eventName: eventName ?? this.eventName,
      eventOwnerId: eventOwnerId ?? this.eventOwnerId,
      eventOwnerName: eventOwnerName ?? this.eventOwnerName,
      eventOwnerEmail: eventOwnerEmail ?? this.eventOwnerEmail,
      // ✅ Event Details
      eventDate: eventDate ?? this.eventDate,
      eventLocation: eventLocation ?? this.eventLocation,
      eventCity: eventCity ?? this.eventCity,
      eventAddress: eventAddress ?? this.eventAddress,
      eventType: eventType ?? this.eventType,
      expectedGuestCount: expectedGuestCount ?? this.expectedGuestCount,
      // Invitee Info
      attendeeId: attendeeId ?? this.attendeeId,
      inviteeName: inviteeName ?? this.inviteeName,
      inviteeEmail: inviteeEmail ?? this.inviteeEmail,
      inviteePhone: inviteePhone ?? this.inviteePhone,
      invitationType: invitationType ?? this.invitationType,
      status: status ?? this.status,
      personalMessage: personalMessage ?? this.personalMessage,
      guestCount: guestCount ?? this.guestCount,
      confirmedGuestCount: confirmedGuestCount ?? this.confirmedGuestCount,
      responseMessage: responseMessage ?? this.responseMessage,
      respondedAt: respondedAt ?? this.respondedAt,
      reminderSent: reminderSent ?? this.reminderSent,
      reminderSentAt: reminderSentAt ?? this.reminderSentAt,
      reminderCount: reminderCount ?? this.reminderCount,
      invitationLink: invitationLink ?? this.invitationLink,
      qrCode: qrCode ?? this.qrCode,
      notificationSent: notificationSent ?? this.notificationSent,
      fcmToken: fcmToken ?? this.fcmToken,
      sentAt: sentAt ?? this.sentAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
