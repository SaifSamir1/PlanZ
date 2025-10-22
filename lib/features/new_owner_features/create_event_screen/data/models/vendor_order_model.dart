// lib/features/vendor/data/models/vendor_order_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class VendorOrderModel extends Equatable {
  final String orderId;
  final String eventId;
  final String vendorId;
  final String packageId;
  
  // Event Owner Info
  final String eventOwnerId;
  final String eventOwnerName;
  final String eventOwnerEmail;
  final String eventOwnerPhone;
  
  // Event Details
  final String eventName;
  final DateTime eventDate;
  final String eventType;
  
  // Package Details
  final String packageName;
  final String serviceName;
  final double price;
  final String currency;
  
  // Order Status
  final String orderStatus; // pending, accepted, rejected, completed
  final String? vendorResponse;
  final DateTime? vendorResponseDate;
  
  // Payment Info
  final String paymentStatus;
  final DateTime? paymentDate;
  
  // Notification
  final bool notificationSent;
  final DateTime? notificationSentAt;
  final bool notificationRead;
  
  // Timestamps
  final DateTime createdAt;
  final DateTime updatedAt;

  const VendorOrderModel({
    required this.orderId,
    required this.eventId,
    required this.vendorId,
    required this.packageId,
    required this.eventOwnerId,
    required this.eventOwnerName,
    required this.eventOwnerEmail,
    required this.eventOwnerPhone,
    required this.eventName,
    required this.eventDate,
    required this.eventType,
    required this.packageName,
    required this.serviceName,
    required this.price,
    required this.currency,
    this.orderStatus = 'pending',
    this.vendorResponse,
    this.vendorResponseDate,
    required this.paymentStatus,
    this.paymentDate,
    this.notificationSent = false,
    this.notificationSentAt,
    this.notificationRead = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // From Firestore
  factory VendorOrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return VendorOrderModel(
      orderId: doc.id,
      eventId: data['eventId'] as String,
      vendorId: data['vendorId'] as String,
      packageId: data['packageId'] as String,
      eventOwnerId: data['eventOwnerId'] as String,
      eventOwnerName: data['eventOwnerName'] as String,
      eventOwnerEmail: data['eventOwnerEmail'] as String,
      eventOwnerPhone: data['eventOwnerPhone'] as String,
      eventName: data['eventName'] as String,
      eventDate: (data['eventDate'] as Timestamp).toDate(),
      eventType: data['eventType'] as String,
      packageName: data['packageName'] as String,
      serviceName: data['serviceName'] as String,
      price: (data['price'] as num).toDouble(),
      currency: data['currency'] as String,
      orderStatus: data['orderStatus'] as String? ?? 'pending',
      vendorResponse: data['vendorResponse'] as String?,
      vendorResponseDate: data['vendorResponseDate'] != null 
          ? (data['vendorResponseDate'] as Timestamp).toDate() 
          : null,
      paymentStatus: data['paymentStatus'] as String,
      paymentDate: data['paymentDate'] != null 
          ? (data['paymentDate'] as Timestamp).toDate() 
          : null,
      notificationSent: data['notificationSent'] as bool? ?? false,
      notificationSentAt: data['notificationSentAt'] != null 
          ? (data['notificationSentAt'] as Timestamp).toDate() 
          : null,
      notificationRead: data['notificationRead'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'eventId': eventId,
      'vendorId': vendorId,
      'packageId': packageId,
      'eventOwnerId': eventOwnerId,
      'eventOwnerName': eventOwnerName,
      'eventOwnerEmail': eventOwnerEmail,
      'eventOwnerPhone': eventOwnerPhone,
      'eventName': eventName,
      'eventDate': Timestamp.fromDate(eventDate),
      'eventType': eventType,
      'packageName': packageName,
      'serviceName': serviceName,
      'price': price,
      'currency': currency,
      'orderStatus': orderStatus,
      'vendorResponse': vendorResponse,
      if (vendorResponseDate != null) 
        'vendorResponseDate': Timestamp.fromDate(vendorResponseDate!),
      'paymentStatus': paymentStatus,
      if (paymentDate != null) 'paymentDate': Timestamp.fromDate(paymentDate!),
      'notificationSent': notificationSent,
      if (notificationSentAt != null) 
        'notificationSentAt': Timestamp.fromDate(notificationSentAt!),
      'notificationRead': notificationRead,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Check if order is pending
  bool get isPending => orderStatus == 'pending';

  // Check if order is accepted
  bool get isAccepted => orderStatus == 'accepted';

  // Check if order is rejected
  bool get isRejected => orderStatus == 'rejected';

  @override
  List<Object?> get props => [
        orderId,
        eventId,
        vendorId,
        packageId,
        eventOwnerId,
        eventOwnerName,
        eventOwnerEmail,
        eventOwnerPhone,
        eventName,
        eventDate,
        eventType,
        packageName,
        serviceName,
        price,
        currency,
        orderStatus,
        vendorResponse,
        vendorResponseDate,
        paymentStatus,
        paymentDate,
        notificationSent,
        notificationSentAt,
        notificationRead,
        createdAt,
        updatedAt,
      ];
}
