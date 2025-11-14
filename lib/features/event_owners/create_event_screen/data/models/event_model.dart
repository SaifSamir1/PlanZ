// lib/features/event_owner/data/models/event_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_model_enum.dart';


class EventModel {
  final String eventId;
  final String eventOwnerId;
  final String eventOwnerName;
  final String eventOwnerEmail;
  final String? eventOwnerPhone;

  // Event Basic Info
  final String eventTypeId; // من الـ JSON
  final String eventTypeName;
  final String eventName;
  final String? description;
  
  // Date & Location
  final DateTime eventDate;
  final String location;
  final String? city;
  final String? address;
  final Map<String, dynamic>? coordinates; // lat, lng
  
  // Budget
  final double totalBudget;
  final double allocatedBudget; // المبلغ اللي تم تخصيصه للـ packages
  final double remainingBudget; // الباقي
  
  // Guest Info
  final int expectedGuestCount;
  final int? confirmedGuestCount;
  
  // Services & Packages
  final List<EventService> services; // الخدمات المطلوبة
  final Map<String, dynamic>? customRequirements;
  
  // Vendor Approval Status
  final bool allVendorsApproved; // ✅ هل كل الـ Vendors وافقوا
  final int totalVendorsCount;
  final int approvedVendorsCount;
  final int rejectedVendorsCount;
  final int pendingVendorsCount;
  
  // Payment
  final PaymentStatus paymentStatus;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final DateTime? paymentDueDate;
  
  // Invitations (للـ Attendees)
  final int totalInvitationsSent;
  final int acceptedInvitations;
  final int rejectedInvitations;
  final int pendingInvitations;
  
  // Status
  final EventStatus status;
  final bool isActive;
  final bool isCancelled;
  final String? cancellationReason;
  
  // Timestamps
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? cancelledAt;
  final DateTime? completedAt;

  EventModel({
    required this.eventId,
    required this.eventOwnerId,
    required this.eventOwnerName,
    required this.eventOwnerEmail,
    this.eventOwnerPhone,
    required this.eventTypeId,
    required this.eventTypeName,
    required this.eventName,
    this.description,
    required this.eventDate,
    required this.location,
    this.city,
    this.address,
    this.coordinates,
    required this.totalBudget,
    required this.allocatedBudget,
    required this.remainingBudget,
    required this.expectedGuestCount,
    this.confirmedGuestCount,
    required this.services,
    this.customRequirements,
    this.allVendorsApproved = false,
    this.totalVendorsCount = 0,
    this.approvedVendorsCount = 0,
    this.rejectedVendorsCount = 0,
    this.pendingVendorsCount = 0,
    this.paymentStatus = PaymentStatus.pending,
    required this.totalAmount,
    this.paidAmount = 0.0,
    required this.remainingAmount,
    this.paymentDueDate,
    this.totalInvitationsSent = 0,
    this.acceptedInvitations = 0,
    this.rejectedInvitations = 0,
    this.pendingInvitations = 0,
    this.status = EventStatus.draft,
    this.isActive = true,
    this.isCancelled = false,
    this.cancellationReason,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.cancelledAt,
    this.completedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

factory EventModel.fromJson(Map<String, dynamic> json) {
  // ✅ FIX: Log for debugging
  final servicesList = json['services'] as List?;
  debugPrint('📥 EventModel.fromJson - Services count: ${servicesList?.length ?? 0}');
  
  if (servicesList != null && servicesList.isNotEmpty) {
    for (var i = 0; i < servicesList.length; i++) {
      debugPrint('   [$i] ${servicesList[i]['serviceName']} - ${servicesList[i]['packageName']}');
    }
  }

  return EventModel(
    eventId: json['eventId'] as String? ?? '',
    eventOwnerId: json['eventOwnerId'] as String? ?? '',
    eventOwnerName: json['eventOwnerName'] as String? ?? '',
    eventOwnerEmail: json['eventOwnerEmail'] as String? ?? '',
    eventOwnerPhone: json['eventOwnerPhone'] as String?,
    eventTypeId: json['eventTypeId'] as String? ?? '',
    eventTypeName: json['eventTypeName'] as String? ?? '',
    eventName: json['eventName'] as String? ?? '',
    description: json['description'] as String?,
    eventDate: json['eventDate'] != null
        ? (json['eventDate'] is Timestamp
            ? (json['eventDate'] as Timestamp).toDate()
            : DateTime.parse(json['eventDate'] as String))
        : DateTime.now(),
    location: json['location'] as String? ?? '',
    city: json['city'] as String?,
    address: json['address'] as String?,
    coordinates: json['coordinates'] != null
        ? Map<String, dynamic>.from(json['coordinates'] as Map)
        : null,
    totalBudget: (json['totalBudget'] as num?)?.toDouble() ?? 0.0,
    allocatedBudget: (json['allocatedBudget'] as num?)?.toDouble() ?? 0.0,
    remainingBudget: (json['remainingBudget'] as num?)?.toDouble() ?? 0.0,
    expectedGuestCount: json['expectedGuestCount'] as int? ?? 0,
    confirmedGuestCount: json['confirmedGuestCount'] as int?,
    
    // ✅ FIX: Parse services correctly
    services: json['services'] != null
        ? (json['services'] as List<dynamic>)
            .map((s) => EventService.fromJson(s as Map<String, dynamic>))
            .toList()
        : [],
    
    customRequirements: json['customRequirements'] != null
        ? Map<String, dynamic>.from(json['customRequirements'] as Map)
        : null,
    allVendorsApproved: json['allVendorsApproved'] as bool? ?? false,
    totalVendorsCount: json['totalVendorsCount'] as int? ?? 0,
    approvedVendorsCount: json['approvedVendorsCount'] as int? ?? 0,
    rejectedVendorsCount: json['rejectedVendorsCount'] as int? ?? 0,
    pendingVendorsCount: json['pendingVendorsCount'] as int? ?? 0,
    paymentStatus: PaymentStatus.values.firstWhere(
      (s) => s.name == (json['paymentStatus'] as String?),
      orElse: () => PaymentStatus.pending,
    ),
    totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
    paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0.0,
    remainingAmount: (json['remainingAmount'] as num?)?.toDouble() ?? 0.0,
    paymentDueDate: json['paymentDueDate'] != null
        ? (json['paymentDueDate'] is Timestamp
            ? (json['paymentDueDate'] as Timestamp).toDate()
            : DateTime.parse(json['paymentDueDate'] as String))
        : null,
    totalInvitationsSent: json['totalInvitationsSent'] as int? ?? 0,
    acceptedInvitations: json['acceptedInvitations'] as int? ?? 0,
    rejectedInvitations: json['rejectedInvitations'] as int? ?? 0,
    pendingInvitations: json['pendingInvitations'] as int? ?? 0,
    status: EventStatus.values.firstWhere(
      (s) => s.name == (json['status'] as String?),
      orElse: () => EventStatus.draft,
    ),
    isActive: json['isActive'] as bool? ?? true,
    isCancelled: json['isCancelled'] as bool? ?? false,
    cancellationReason: json['cancellationReason'] as String?,
    createdAt: json['createdAt'] != null
        ? (json['createdAt'] is Timestamp
            ? (json['createdAt'] as Timestamp).toDate()
            : DateTime.parse(json['createdAt'] as String))
        : DateTime.now(),
    updatedAt: json['updatedAt'] != null
        ? (json['updatedAt'] is Timestamp
            ? (json['updatedAt'] as Timestamp).toDate()
            : DateTime.parse(json['updatedAt'] as String))
        : DateTime.now(),
    cancelledAt: json['cancelledAt'] != null
        ? (json['cancelledAt'] is Timestamp
            ? (json['cancelledAt'] as Timestamp).toDate()
            : DateTime.parse(json['cancelledAt'] as String))
        : null,
    completedAt: json['completedAt'] != null
        ? (json['completedAt'] is Timestamp
            ? (json['completedAt'] as Timestamp).toDate()
            : DateTime.parse(json['completedAt'] as String))
        : null,
  );
}
  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'eventOwnerId': eventOwnerId,
      'eventOwnerName': eventOwnerName,
      'eventOwnerEmail': eventOwnerEmail,
      'eventOwnerPhone': eventOwnerPhone,
      'eventTypeId': eventTypeId,
      'eventTypeName': eventTypeName,
      'eventName': eventName,
      'description': description,
      'eventDate': Timestamp.fromDate(eventDate),
      'location': location,
      'city': city,
      'address': address,
      'coordinates': coordinates,
      'totalBudget': totalBudget,
      'allocatedBudget': allocatedBudget,
      'remainingBudget': remainingBudget,
      'expectedGuestCount': expectedGuestCount,
      'confirmedGuestCount': confirmedGuestCount,
      'services': services.map((s) => s.toJson()).toList(),
      'customRequirements': customRequirements,
      'allVendorsApproved': allVendorsApproved,
      'totalVendorsCount': totalVendorsCount,
      'approvedVendorsCount': approvedVendorsCount,
      'rejectedVendorsCount': rejectedVendorsCount,
      'pendingVendorsCount': pendingVendorsCount,
      'paymentStatus': paymentStatus.name,
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
      'remainingAmount': remainingAmount,
      'paymentDueDate': paymentDueDate != null
          ? Timestamp.fromDate(paymentDueDate!)
          : null,
      'totalInvitationsSent': totalInvitationsSent,
      'acceptedInvitations': acceptedInvitations,
      'rejectedInvitations': rejectedInvitations,
      'pendingInvitations': pendingInvitations,
      'status': status.name,
      'isActive': isActive,
      'isCancelled': isCancelled,
      'cancellationReason': cancellationReason,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'cancelledAt':
          cancelledAt != null ? Timestamp.fromDate(cancelledAt!) : null,
      'completedAt':
          completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }

  // Helper Methods
  double get budgetUtilizationPercentage =>
      totalBudget > 0 ? (allocatedBudget / totalBudget) * 100 : 0;

  bool get canProceedWithPayment =>
      allVendorsApproved && status == EventStatus.confirmed;

  bool get needsReplacement => rejectedVendorsCount > 0;

  // ✅ Update vendor approval status for a specific service
  EventModel updateVendorApprovalStatus({
    required String serviceId,
    required bool isApproved,
  }) {
    debugPrint('');
    debugPrint('🔄 [EventModel.updateVendorApprovalStatus] Updating...');
    debugPrint('   Service ID: $serviceId');
    debugPrint('   Is Approved: $isApproved');
    debugPrint('   Current Pending Count: $pendingVendorsCount');

    // ✅ Find and update the service
    final updatedServices = services.map((service) {
      if (service.serviceId == serviceId) {
        debugPrint('   ✅ Found service: ${service.serviceName}');
        return service.copyWith(vendorApproved: isApproved);
      }
      return service;
    }).toList();

    // ✅ Recalculate vendor counts
    final newApprovedCount = updatedServices.where((s) => s.vendorApproved).length;
    final newRejectedCount = totalVendorsCount - newApprovedCount;
    final newPendingCount = totalVendorsCount - newApprovedCount - newRejectedCount;

    debugPrint('   📊 New Counts:');
    debugPrint('      Approved: $newApprovedCount');
    debugPrint('      Pending: $newPendingCount');
    debugPrint('      Rejected: $newRejectedCount');

    return copyWith(
      services: updatedServices,
      approvedVendorsCount: newApprovedCount,
      pendingVendorsCount: newPendingCount,
      rejectedVendorsCount: newRejectedCount,
      allVendorsApproved: newApprovedCount == totalVendorsCount,
    );
  }

  EventModel copyWith({
    String? eventId,
    String? eventOwnerId,
    String? eventOwnerName,
    String? eventOwnerEmail,
    String? eventOwnerPhone,
    String? eventTypeId,
    String? eventTypeName,
    String? eventName,
    String? description,
    DateTime? eventDate,
    String? location,
    String? city,
    String? address,
    Map<String, dynamic>? coordinates,
    double? totalBudget,
    double? allocatedBudget,
    double? remainingBudget,
    int? expectedGuestCount,
    int? confirmedGuestCount,
    List<EventService>? services,
    Map<String, dynamic>? customRequirements,
    bool? allVendorsApproved,
    int? totalVendorsCount,
    int? approvedVendorsCount,
    int? rejectedVendorsCount,
    int? pendingVendorsCount,
    PaymentStatus? paymentStatus,
    double? totalAmount,
    double? paidAmount,
    double? remainingAmount,
    DateTime? paymentDueDate,
    int? totalInvitationsSent,
    int? acceptedInvitations,
    int? rejectedInvitations,
    int? pendingInvitations,
    EventStatus? status,
    bool? isActive,
    bool? isCancelled,
    String? cancellationReason,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? cancelledAt,
    DateTime? completedAt,
  }) {
    return EventModel(
      eventId: eventId ?? this.eventId,
      eventOwnerId: eventOwnerId ?? this.eventOwnerId,
      eventOwnerName: eventOwnerName ?? this.eventOwnerName,
      eventOwnerEmail: eventOwnerEmail ?? this.eventOwnerEmail,
      eventOwnerPhone: eventOwnerPhone ?? this.eventOwnerPhone,
      eventTypeId: eventTypeId ?? this.eventTypeId,
      eventTypeName: eventTypeName ?? this.eventTypeName,
      eventName: eventName ?? this.eventName,
      description: description ?? this.description,
      eventDate: eventDate ?? this.eventDate,
      location: location ?? this.location,
      city: city ?? this.city,
      address: address ?? this.address,
      coordinates: coordinates ?? this.coordinates,
      totalBudget: totalBudget ?? this.totalBudget,
      allocatedBudget: allocatedBudget ?? this.allocatedBudget,
      remainingBudget: remainingBudget ?? this.remainingBudget,
      expectedGuestCount: expectedGuestCount ?? this.expectedGuestCount,
      confirmedGuestCount: confirmedGuestCount ?? this.confirmedGuestCount,
      services: services ?? this.services,
      customRequirements: customRequirements ?? this.customRequirements,
      allVendorsApproved: allVendorsApproved ?? this.allVendorsApproved,
      totalVendorsCount: totalVendorsCount ?? this.totalVendorsCount,
      approvedVendorsCount: approvedVendorsCount ?? this.approvedVendorsCount,
      rejectedVendorsCount: rejectedVendorsCount ?? this.rejectedVendorsCount,
      pendingVendorsCount: pendingVendorsCount ?? this.pendingVendorsCount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      paymentDueDate: paymentDueDate ?? this.paymentDueDate,
      totalInvitationsSent: totalInvitationsSent ?? this.totalInvitationsSent,
      acceptedInvitations: acceptedInvitations ?? this.acceptedInvitations,
      rejectedInvitations: rejectedInvitations ?? this.rejectedInvitations,
      pendingInvitations: pendingInvitations ?? this.pendingInvitations,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      isCancelled: isCancelled ?? this.isCancelled,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

// event_model.dart - FIX EventService.fromJson()

class EventService {
  final String serviceId;
  final String serviceName;
  final String? serviceNameAr;
  final bool isRequired;
  final String packageId;
  final String packageName;
  final String vendorId;
  final String vendorName;
  final double packagePrice;
  final String? vendorFcmToken;  // ✅ FCM Token للـ Vendor
  final bool vendorApproved;
  final String requestId;

  EventService({
    required this.serviceId,
    required this.serviceName,
    this.serviceNameAr,
    required this.isRequired,
    required this.packageId,
    required this.packageName,
    required this.vendorId,
    required this.vendorName,
    required this.packagePrice,
    this.vendorFcmToken,
    this.vendorApproved = false,
    required this.requestId,
  });

  /// ✅ FIX: Proper parsing from JSON
  factory EventService.fromJson(Map<String, dynamic> json) {
    debugPrint('📦 Parsing EventService: ${json['serviceName']} - ${json['packageName']}');
    
    return EventService(
      serviceId: json['serviceId'] as String? ?? '',
      serviceName: json['serviceName'] as String? ?? '',
      serviceNameAr: json['serviceNameAr'] as String?,
      isRequired: json['isRequired'] as bool? ?? false,
      packageId: json['packageId'] as String? ?? '',
      packageName: json['packageName'] as String? ?? '',
      vendorId: json['vendorId'] as String? ?? '',
      vendorName: json['vendorName'] as String? ?? '',
      packagePrice: (json['packagePrice'] as num?)?.toDouble() ?? 0.0,
      vendorFcmToken: json['vendorFcmToken'] as String?,
      vendorApproved: json['vendorApproved'] as bool? ?? false,
      requestId: json['requestId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'serviceName': serviceName,
      'serviceNameAr': serviceNameAr,
      'isRequired': isRequired,
      'packageId': packageId,
      'packageName': packageName,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'packagePrice': packagePrice,
      'vendorFcmToken': vendorFcmToken,
      'vendorApproved': vendorApproved,
      'requestId': requestId,
    };
  }

  EventService copyWith({
    String? serviceId,
    String? serviceName,
    String? serviceNameAr,
    bool? isRequired,
    String? packageId,
    String? packageName,
    String? vendorId,
    String? vendorName,
    double? packagePrice,
    String? vendorFcmToken,
    bool? vendorApproved,
    String? requestId,
  }) {
    return EventService(
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      serviceNameAr: serviceNameAr ?? this.serviceNameAr,
      isRequired: isRequired ?? this.isRequired,
      packageId: packageId ?? this.packageId,
      packageName: packageName ?? this.packageName,
      vendorId: vendorId ?? this.vendorId,
      vendorName: vendorName ?? this.vendorName,
      packagePrice: packagePrice ?? this.packagePrice,
      vendorFcmToken: vendorFcmToken ?? this.vendorFcmToken,
      vendorApproved: vendorApproved ?? this.vendorApproved,
      requestId: requestId ?? this.requestId,
    );
  }
}

// ============================================
// EventModel.fromJson() - FIX services parsing
// ============================================
