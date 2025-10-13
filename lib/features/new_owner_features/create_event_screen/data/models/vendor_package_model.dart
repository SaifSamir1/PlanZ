// lib/features/packages/data/models/vendor_package_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class VendorPackageModel extends Equatable {
  final String packageId;
  final String vendorId;
  final String vendorName;
  
  // Service Information
  final String serviceId;
  final String serviceName;
  
  // Package Details
  final String packageName;
  final String packageNameAr;
  final String description;
  final String descriptionAr;
  
  // Pricing
  final double price;
  final String currency;
  final double? discountPrice;
  final String priceType; // fixed, per_person, per_hour
  
  // Suitable Event Types
  final List<String> eventTypes;
  
  // Package Includes
  final List<String> includes;
  
  // Capacity & Specifications
  final int? capacity;
  final int? duration;
  final Map<String, dynamic>? specifications;
  
  // Media
  final List<String> images;
  final String? videoUrl;
  
  // Location
  final LocationData location;
  
  // Rating & Reviews
  final double rating;
  final int reviewsCount;
  final int totalBookings;
  
  // Keywords for Search
  final List<String> keywords;
  
  // Availability
  final bool isActive;
  final bool isAvailable;
  final List<String>? availabilityCalendar; // Available dates
  
  // Timestamps
  final DateTime createdAt;
  final DateTime updatedAt;

  const VendorPackageModel({
    required this.packageId,
    required this.vendorId,
    required this.vendorName,
    required this.serviceId,
    required this.serviceName,
    required this.packageName,
    required this.packageNameAr,
    required this.description,
    required this.descriptionAr,
    required this.price,
    required this.currency,
    this.discountPrice,
    required this.priceType,
    required this.eventTypes,
    required this.includes,
    this.capacity,
    this.duration,
    this.specifications,
    required this.images,
    this.videoUrl,
    required this.location,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.totalBookings = 0,
    required this.keywords,
    this.isActive = true,
    this.isAvailable = true,
    this.availabilityCalendar,
    required this.createdAt,
    required this.updatedAt,
  });

  // From Firestore
  factory VendorPackageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return VendorPackageModel(
      packageId: doc.id,
      vendorId: data['vendorId'] as String,
      vendorName: data['vendorName'] as String,
      serviceId: data['serviceId'] as String,
      serviceName: data['serviceName'] as String,
      packageName: data['packageName'] as String,
      packageNameAr: data['packageNameAr'] as String,
      description: data['description'] as String,
      descriptionAr: data['descriptionAr'] as String,
      price: (data['price'] as num).toDouble(),
      currency: data['currency'] as String,
      discountPrice: data['discountPrice'] != null ? (data['discountPrice'] as num).toDouble() : null,
      priceType: data['priceType'] as String,
      eventTypes: List<String>.from(data['eventTypes'] as List),
      includes: List<String>.from(data['includes'] as List),
      capacity: data['capacity'] as int?,
      duration: data['duration'] as int?,
      specifications: data['specifications'] as Map<String, dynamic>?,
      images: List<String>.from(data['images'] as List),
      videoUrl: data['videoUrl'] as String?,
      location: LocationData.fromMap(data['location'] as Map<String, dynamic>),
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: data['reviewsCount'] as int? ?? 0,
      totalBookings: data['totalBookings'] as int? ?? 0,
      keywords: List<String>.from(data['keywords'] as List),
      isActive: data['isActive'] as bool? ?? true,
      isAvailable: data['isAvailable'] as bool? ?? true,
      availabilityCalendar: data['availabilityCalendar'] != null 
          ? List<String>.from(data['availabilityCalendar'] as List) 
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'vendorId': vendorId,
      'vendorName': vendorName,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'packageName': packageName,
      'packageNameAr': packageNameAr,
      'description': description,
      'descriptionAr': descriptionAr,
      'price': price,
      'currency': currency,
      'discountPrice': discountPrice,
      'priceType': priceType,
      'eventTypes': eventTypes,
      'includes': includes,
      'capacity': capacity,
      'duration': duration,
      'specifications': specifications,
      'images': images,
      'videoUrl': videoUrl,
      'location': location.toMap(),
      'rating': rating,
      'reviewsCount': reviewsCount,
      'totalBookings': totalBookings,
      'keywords': keywords,
      'isActive': isActive,
      'isAvailable': isAvailable,
      'availabilityCalendar': availabilityCalendar,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Get effective price (discount if available, otherwise regular price)
  double get effectivePrice => discountPrice ?? price;

  // Check if package has discount
  bool get hasDiscount => discountPrice != null && discountPrice! < price;

  // Calculate discount percentage
  double? get discountPercentage {
    if (!hasDiscount) return null;
    return ((price - discountPrice!) / price) * 100;
  }

  @override
  List<Object?> get props => [
        packageId,
        vendorId,
        vendorName,
        serviceId,
        serviceName,
        packageName,
        packageNameAr,
        description,
        descriptionAr,
        price,
        currency,
        discountPrice,
        priceType,
        eventTypes,
        includes,
        capacity,
        duration,
        specifications,
        images,
        videoUrl,
        location,
        rating,
        reviewsCount,
        totalBookings,
        keywords,
        isActive,
        isAvailable,
        availabilityCalendar,
        createdAt,
        updatedAt,
      ];
}

// Location Data Model
class LocationData extends Equatable {
  final String city;
  final String area;
  final String address;
  final GeoPoint? coordinates;

  const LocationData({
    required this.city,
    required this.area,
    required this.address,
    this.coordinates,
  });

  factory LocationData.fromMap(Map<String, dynamic> map) {
    return LocationData(
      city: map['city'] as String,
      area: map['area'] as String,
      address: map['address'] as String,
      coordinates: map['coordinates'] != null 
          ? GeoPoint(
              map['coordinates']['latitude'] as double,
              map['coordinates']['longitude'] as double,
            ) 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'area': area,
      'address': address,
      if (coordinates != null)
        'coordinates': {
          'latitude': coordinates!.latitude,
          'longitude': coordinates!.longitude,
        },
    };
  }

  @override
  List<Object?> get props => [city, area, address, coordinates];
}
