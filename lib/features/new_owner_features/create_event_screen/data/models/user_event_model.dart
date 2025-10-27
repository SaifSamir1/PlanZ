// lib/features/events/data/models/user_event_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserEventModel extends Equatable {
  final String eventId;
  final String ownerId;
  final String ownerName;
  final String ownerEmail;
  final String ownerPhone;
  
  // Event Type
  final String eventTypeId;
  final String eventTypeName;
  
  // Event Basic Info
  final String eventName;
  final DateTime eventDate;
  final String eventTime;
  final EventLocation location;
  final int guestCount;
  final String? additionalNotes;
  
  // Budget Information
  final EventBudget budget;
  
  // Payment Information
  final PaymentInfo? payment;
  
  // Event Status
  final String status; // draft, pending_payment, confirmed, in_progress, completed, cancelled
  final bool bookingConfirmed;
  
  // Vendor Notifications
  final List<VendorNotification> vendorNotifications;
  
  // Timestamps
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? confirmedAt;

  const UserEventModel({
    required this.eventId,
    required this.ownerId,
    required this.ownerName,
    required this.ownerEmail,
    required this.ownerPhone,
    required this.eventTypeId,
    required this.eventTypeName,
    required this.eventName,
    required this.eventDate,
    required this.eventTime,
    required this.location,
    required this.guestCount,
    this.additionalNotes,
    required this.budget,
    this.payment,
    this.status = 'draft',
    this.bookingConfirmed = false,
    this.vendorNotifications = const [],
    required this.createdAt,
    required this.updatedAt,
    this.confirmedAt,
  });

  // From Firestore
  factory UserEventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return UserEventModel(
      eventId: doc.id,
      ownerId: data['ownerId'] as String,
      ownerName: data['ownerName'] as String,
      ownerEmail: data['ownerEmail'] as String,
      ownerPhone: data['ownerPhone'] as String,
      eventTypeId: data['eventTypeId'] as String,
      eventTypeName: data['eventTypeName'] as String,
      eventName: data['eventName'] as String,
      eventDate: (data['eventDate'] as Timestamp).toDate(),
      eventTime: data['eventTime'] as String,
      location: EventLocation.fromMap(data['location'] as Map<String, dynamic>),
      guestCount: data['guestCount'] as int,
      additionalNotes: data['additionalNotes'] as String?,
      budget: EventBudget.fromMap(data['budget'] as Map<String, dynamic>),
      payment: data['payment'] != null 
          ? PaymentInfo.fromMap(data['payment'] as Map<String, dynamic>) 
          : null,
      status: data['status'] as String? ?? 'draft',
      bookingConfirmed: data['bookingConfirmed'] as bool? ?? false,
      vendorNotifications: (data['vendorNotifications'] as List?)
              ?.map((n) => VendorNotification.fromMap(n as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      confirmedAt: data['confirmedAt'] != null 
          ? (data['confirmedAt'] as Timestamp).toDate() 
          : null,
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerEmail': ownerEmail,
      'ownerPhone': ownerPhone,
      'eventTypeId': eventTypeId,
      'eventTypeName': eventTypeName,
      'eventName': eventName,
      'eventDate': Timestamp.fromDate(eventDate),
      'eventTime': eventTime,
      'location': location.toMap(),
      'guestCount': guestCount,
      'additionalNotes': additionalNotes,
      'budget': budget.toMap(),
      'payment': payment?.toMap(),
      'status': status,
      'bookingConfirmed': bookingConfirmed,
      'vendorNotifications': vendorNotifications.map((n) => n.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      if (confirmedAt != null) 'confirmedAt': Timestamp.fromDate(confirmedAt!),
    };
  }

  @override
  List<Object?> get props => [
        eventId,
        ownerId,
        ownerName,
        ownerEmail,
        ownerPhone,
        eventTypeId,
        eventTypeName,
        eventName,
        eventDate,
        eventTime,
        location,
        guestCount,
        additionalNotes,
        budget,
        payment,
        status,
        bookingConfirmed,
        vendorNotifications,
        createdAt,
        updatedAt,
        confirmedAt,
      ];
}

// Event Location Model
class EventLocation extends Equatable {
  final String city;
  final String area;

  const EventLocation({
    required this.city,
    required this.area,
  });

  factory EventLocation.fromMap(Map<String, dynamic> map) {
    return EventLocation(
      city: map['city'] as String,
      area: map['area'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'area': area,
    };
  }

  @override
  List<Object?> get props => [city, area];
}

// Event Budget Model
class EventBudget extends Equatable {
  final double totalBudget;
  final String currency;
  final double totalAllocated;
  final double totalSpent;
  final double totalRemaining;
  final Map<String, ServiceBudget> servicesBudget;

  const EventBudget({
    required this.totalBudget,
    required this.currency,
    required this.totalAllocated,
    required this.totalSpent,
    required this.totalRemaining,
    required this.servicesBudget,
  });

  factory EventBudget.fromMap(Map<String, dynamic> map) {
    final servicesBudgetMap = <String, ServiceBudget>{};
    if (map['servicesBudget'] != null) {
      (map['servicesBudget'] as Map<String, dynamic>).forEach((key, value) {
        servicesBudgetMap[key] = ServiceBudget.fromMap(value as Map<String, dynamic>);
      });
    }

    return EventBudget(
      totalBudget: (map['totalBudget'] as num).toDouble(),
      currency: map['currency'] as String,
      totalAllocated: (map['totalAllocated'] as num).toDouble(),
      totalSpent: (map['totalSpent'] as num).toDouble(),
      totalRemaining: (map['totalRemaining'] as num).toDouble(),
      servicesBudget: servicesBudgetMap,
    );
  }

  Map<String, dynamic> toMap() {
    final servicesBudgetMap = <String, dynamic>{};
    servicesBudget.forEach((key, value) {
      servicesBudgetMap[key] = value.toMap();
    });

    return {
      'totalBudget': totalBudget,
      'currency': currency,
      'totalAllocated': totalAllocated,
      'totalSpent': totalSpent,
      'totalRemaining': totalRemaining,
      'servicesBudget': servicesBudgetMap,
    };
  }

  // Check if over budget
  bool get isOverBudget => totalSpent > totalBudget;

  // Get percentage spent
  double get percentageSpent => (totalSpent / totalBudget) * 100;

  @override
  List<Object?> get props => [
        totalBudget,
        currency,
        totalAllocated,
        totalSpent,
        totalRemaining,
        servicesBudget,
      ];
}

// Service Budget Model
class ServiceBudget extends Equatable {
  final String serviceId;
  final String serviceName;
  final double allocated;
  final double spent;
  final double remaining;
  final bool isOverBudget;
  final List<SelectedPackage> selectedPackages;

  const ServiceBudget({
    required this.serviceId,
    required this.serviceName,
    required this.allocated,
    required this.spent,
    required this.remaining,
    required this.isOverBudget,
    required this.selectedPackages,
  });

  factory ServiceBudget.fromMap(Map<String, dynamic> map) {
    return ServiceBudget(
      serviceId: map['serviceId'] as String,
      serviceName: map['serviceName'] as String,
      allocated: (map['allocated'] as num).toDouble(),
      spent: (map['spent'] as num).toDouble(),
      remaining: (map['remaining'] as num).toDouble(),
      isOverBudget: map['isOverBudget'] as bool,
      selectedPackages: (map['selectedPackages'] as List)
          .map((p) => SelectedPackage.fromMap(p as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'serviceName': serviceName,
      'allocated': allocated,
      'spent': spent,
      'remaining': remaining,
      'isOverBudget': isOverBudget,
      'selectedPackages': selectedPackages.map((p) => p.toMap()).toList(),
    };
  }

  // Get percentage spent for this service
  double get percentageSpent => (spent / allocated) * 100;

  @override
  List<Object?> get props => [
        serviceId,
        serviceName,
        allocated,
        spent,
        remaining,
        isOverBudget,
        selectedPackages,
      ];
}

// Selected Package Model
class SelectedPackage extends Equatable {
  final String packageId;
  final String packageName;
  final String vendorId;
  final String vendorName;
  final double price;
  final DateTime selectedAt;

  const SelectedPackage({
    required this.packageId,
    required this.packageName,
    required this.vendorId,
    required this.vendorName,
    required this.price,
    required this.selectedAt,
  });

  factory SelectedPackage.fromMap(Map<String, dynamic> map) {
    return SelectedPackage(
      packageId: map['packageId'] as String,
      packageName: map['packageName'] as String,
      vendorId: map['vendorId'] as String,
      vendorName: map['vendorName'] as String,
      price: (map['price'] as num).toDouble(),
      selectedAt: (map['selectedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'packageId': packageId,
      'packageName': packageName,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'price': price,
      'selectedAt': Timestamp.fromDate(selectedAt),
    };
  }

  @override
  List<Object?> get props => [
        packageId,
        packageName,
        vendorId,
        vendorName,
        price,
        selectedAt,
      ];
}

// Payment Info Model
class PaymentInfo extends Equatable {
  final double totalAmount;
  final String paymentMethod; // credit_card, e_wallet, paypal
  final String paymentStatus; // pending, completed, failed
  final DateTime? paymentDate;
  final String? transactionId;

  const PaymentInfo({
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    this.paymentDate,
    this.transactionId,
  });

  factory PaymentInfo.fromMap(Map<String, dynamic> map) {
    return PaymentInfo(
      totalAmount: (map['totalAmount'] as num).toDouble(),
      paymentMethod: map['paymentMethod'] as String,
      paymentStatus: map['paymentStatus'] as String,
      paymentDate: map['paymentDate'] != null 
          ? (map['paymentDate'] as Timestamp).toDate() 
          : null,
      transactionId: map['transactionId'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      if (paymentDate != null) 'paymentDate': Timestamp.fromDate(paymentDate!),
      'transactionId': transactionId,
    };
  }

  @override
  List<Object?> get props => [
        totalAmount,
        paymentMethod,
        paymentStatus,
        paymentDate,
        transactionId,
      ];
}

// Vendor Notification Model
class VendorNotification extends Equatable {
  final String vendorId;
  final String packageId;
  final bool notified;
  final DateTime? notifiedAt;

  const VendorNotification({
    required this.vendorId,
    required this.packageId,
    required this.notified,
    this.notifiedAt,
  });

  factory VendorNotification.fromMap(Map<String, dynamic> map) {
    return VendorNotification(
      vendorId: map['vendorId'] as String,
      packageId: map['packageId'] as String,
      notified: map['notified'] as bool,
      notifiedAt: map['notifiedAt'] != null 
          ? (map['notifiedAt'] as Timestamp).toDate() 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vendorId': vendorId,
      'packageId': packageId,
      'notified': notified,
      if (notifiedAt != null) 'notifiedAt': Timestamp.fromDate(notifiedAt!),
    };
  }

  @override
  List<Object?> get props => [vendorId, packageId, notified, notifiedAt];
}
