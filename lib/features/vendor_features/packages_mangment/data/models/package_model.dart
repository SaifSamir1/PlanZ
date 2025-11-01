// lib/features/vendor/data/models/package_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

enum PackageStatus {
  pending,    // في انتظار موافقة الـ Owner
  active,     // تم قبوله من الـ Owner
  rejected,   // تم رفضه من الـ Owner
  inactive,   // الـ Vendor عطله مؤقتاً
}

class PackageModel {
  final String packageId;
  final String vendorId;
  final String vendorName;
  
  // Service Info
  final String serviceId; // من الـ services_collection.json
  final String serviceName;
  
  // Package Details
  final String packageName;
  final String description;
  
  // Pricing
  final double price;
  final String currency;
  final String priceUnit; // per_event, per_person, per_hour, per_day
  
  // Features
  final List<String> features;
  
  // Keywords for Search (مهم جداً للبحث)
  final List<String> keywords;
  
  // Portfolio Links (Google Drive Links)
  final List<PortfolioItem> portfolioLinks;
  
  // Status & Approval
  final PackageStatus status;
  final bool isActive; // الـ Vendor يقدر يعطله
  final bool isApprovedByOwner; // الـ Owner وافق عليه
  
  // Owner Approval Details
  final DateTime? approvedAt;
  final String? approvedBy;
  final String? rejectionReason;
  final DateTime? rejectedAt;
  
  // Attributes (specific to service type)
  final Map<String, dynamic>? attributes;
  
  // Stats
  final int viewCount;
  final int bookingCount;
  final double? rating;
  final int? reviewCount;
  
  // Timestamps
  final DateTime createdAt;
  final DateTime updatedAt;

  PackageModel({
    required this.packageId,
    required this.vendorId,
    required this.vendorName,
    required this.serviceId,
    required this.serviceName,
    required this.packageName,
    required this.description,
    required this.price,
    this.currency = 'EGP',
    this.priceUnit = 'per_event',
    required this.features,
    required this.keywords,
    required this.portfolioLinks,
    this.status = PackageStatus.pending,
    this.isActive = false, // ✅ Default false حتى الـ Owner يوافق
    this.isApprovedByOwner = false,
    this.approvedAt,
    this.approvedBy,
    this.rejectionReason,
    this.rejectedAt,
    this.attributes,
    this.viewCount = 0,
    this.bookingCount = 0,
    this.rating,
    this.reviewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      packageId: json['packageId'] ?? '',
      vendorId: json['vendorId'] ?? '',
      vendorName: json['vendorName'] ?? '',
      serviceId: json['serviceId'] ?? '',
      serviceName: json['serviceName'] ?? '',
      packageName: json['packageName'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'EGP',
      priceUnit: json['priceUnit'] ?? 'per_event',
      features: json['features'] != null
          ? List<String>.from(json['features'])
          : [],
      keywords: json['keywords'] != null
          ? List<String>.from(json['keywords'])
          : [],
      portfolioLinks: json['portfolioLinks'] != null
          ? (json['portfolioLinks'] as List)
              .map((item) => PortfolioItem.fromJson(item))
              .toList()
          : [],
      status: PackageStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => PackageStatus.pending,
      ),
      isActive: json['isActive'] ?? false,
      isApprovedByOwner: json['isApprovedByOwner'] ?? false,
      approvedAt: json['approvedAt'] != null
          ? (json['approvedAt'] is Timestamp
              ? (json['approvedAt'] as Timestamp).toDate()
              : DateTime.parse(json['approvedAt']))
          : null,
      approvedBy: json['approvedBy'],
      rejectionReason: json['rejectionReason'],
      rejectedAt: json['rejectedAt'] != null
          ? (json['rejectedAt'] is Timestamp
              ? (json['rejectedAt'] as Timestamp).toDate()
              : DateTime.parse(json['rejectedAt']))
          : null,
      attributes: json['attributes'] != null
          ? Map<String, dynamic>.from(json['attributes'])
          : null,
      viewCount: json['viewCount'] ?? 0,
      bookingCount: json['bookingCount'] ?? 0,
      rating: json['rating']?.toDouble(),
      reviewCount: json['reviewCount'],
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
      'packageId': packageId,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'packageName': packageName,
      'description': description,
      'price': price,
      'currency': currency,
      'priceUnit': priceUnit,
      'features': features,
      'keywords': keywords,
      'portfolioLinks': portfolioLinks.map((item) => item.toJson()).toList(),
      'status': status.name,
      'isActive': isActive,
      'isApprovedByOwner': isApprovedByOwner,
      'approvedAt': approvedAt?.toIso8601String(),
      'approvedBy': approvedBy,
      'rejectionReason': rejectionReason,
      'rejectedAt': rejectedAt?.toIso8601String(),
      'attributes': attributes,
      'viewCount': viewCount,
      'bookingCount': bookingCount,
      'rating': rating,
      'reviewCount': reviewCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  PackageModel copyWith({
    String? packageId,
    String? vendorId,
    String? vendorName,
    String? serviceId,
    String? serviceName,
    String? packageName,
    String? description,
    double? price,
    String? currency,
    String? priceUnit,
    List<String>? features,
    List<String>? keywords,
    List<PortfolioItem>? portfolioLinks,
    PackageStatus? status,
    bool? isActive,
    bool? isApprovedByOwner,
    DateTime? approvedAt,
    String? approvedBy,
    String? rejectionReason,
    DateTime? rejectedAt,
    Map<String, dynamic>? attributes,
    int? viewCount,
    int? bookingCount,
    double? rating,
    int? reviewCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PackageModel(
      packageId: packageId ?? this.packageId,
      vendorId: vendorId ?? this.vendorId,
      vendorName: vendorName ?? this.vendorName,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      packageName: packageName ?? this.packageName,
      description: description ?? this.description,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      priceUnit: priceUnit ?? this.priceUnit,
      features: features ?? this.features,
      keywords: keywords ?? this.keywords,
      portfolioLinks: portfolioLinks ?? this.portfolioLinks,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      isApprovedByOwner: isApprovedByOwner ?? this.isApprovedByOwner,
      approvedAt: approvedAt ?? this.approvedAt,
      approvedBy: approvedBy ?? this.approvedBy,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      rejectedAt: rejectedAt ?? this.rejectedAt,
      attributes: attributes ?? this.attributes,
      viewCount: viewCount ?? this.viewCount,
      bookingCount: bookingCount ?? this.bookingCount,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Portfolio Item Model
class PortfolioItem {
  final String type; // 'image' or 'video'
  final String url; // Google Drive URL
  final String? thumbnail; // Thumbnail URL

  PortfolioItem({
    required this.type,
    required this.url,
    this.thumbnail,
  });

  factory PortfolioItem.fromJson(Map<String, dynamic> json) {
    return PortfolioItem(
      type: json['type'] ?? 'image',
      url: json['url'] ?? '',
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'url': url,
      'thumbnail': thumbnail,
    };
  }
}
