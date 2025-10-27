// lib/features/events/data/models/service_model.dart

import 'package:equatable/equatable.dart';

class ServiceModel extends Equatable {
  final String serviceId;
  final String serviceName;
  final String serviceNameAr;
  final String icon;
  final String category;
  final String description;
  final String descriptionAr;
  final bool isActive;
  final int popularityRank;
  final List<String> keywords;
  final List<String> usedInEventTypes;
  final List<String> commonAttributes;
  final PriceRange priceRange;

  const ServiceModel({
    required this.serviceId,
    required this.serviceName,
    required this.serviceNameAr,
    required this.icon,
    required this.category,
    required this.description,
    required this.descriptionAr,
    required this.isActive,
    required this.popularityRank,
    required this.keywords,
    required this.usedInEventTypes,
    required this.commonAttributes,
    required this.priceRange,
  });

  // Factory constructor from JSON
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      serviceId: json['serviceId'] as String,
      serviceName: json['serviceName'] as String,
      serviceNameAr: json['serviceNameAr'] as String,
      icon: json['icon'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      descriptionAr: json['descriptionAr'] as String,
      isActive: json['isActive'] as bool,
      popularityRank: json['popularityRank'] as int,
      keywords: List<String>.from(json['keywords'] as List),
      usedInEventTypes: List<String>.from(json['usedInEventTypes'] as List),
      commonAttributes: List<String>.from(json['commonAttributes'] as List),
      priceRange: PriceRange.fromJson(json['priceRange'] as Map<String, dynamic>),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'serviceName': serviceName,
      'serviceNameAr': serviceNameAr,
      'icon': icon,
      'category': category,
      'description': description,
      'descriptionAr': descriptionAr,
      'isActive': isActive,
      'popularityRank': popularityRank,
      'keywords': keywords,
      'usedInEventTypes': usedInEventTypes,
      'commonAttributes': commonAttributes,
      'priceRange': priceRange.toJson(),
    };
  }

  // CopyWith method
  ServiceModel copyWith({
    String? serviceId,
    String? serviceName,
    String? serviceNameAr,
    String? icon,
    String? category,
    String? description,
    String? descriptionAr,
    bool? isActive,
    int? popularityRank,
    List<String>? keywords,
    List<String>? usedInEventTypes,
    List<String>? commonAttributes,
    PriceRange? priceRange,
  }) {
    return ServiceModel(
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      serviceNameAr: serviceNameAr ?? this.serviceNameAr,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      isActive: isActive ?? this.isActive,
      popularityRank: popularityRank ?? this.popularityRank,
      keywords: keywords ?? this.keywords,
      usedInEventTypes: usedInEventTypes ?? this.usedInEventTypes,
      commonAttributes: commonAttributes ?? this.commonAttributes,
      priceRange: priceRange ?? this.priceRange,
    );
  }

  @override
  List<Object?> get props => [
        serviceId,
        serviceName,
        serviceNameAr,
        icon,
        category,
        description,
        descriptionAr,
        isActive,
        popularityRank,
        keywords,
        usedInEventTypes,
        commonAttributes,
        priceRange,
      ];
}

// Price Range Model
class PriceRange extends Equatable {
  final double min;
  final double max;
  final String currency;
  final String unit;

  const PriceRange({
    required this.min,
    required this.max,
    required this.currency,
    required this.unit,
  });

  factory PriceRange.fromJson(Map<String, dynamic> json) {
    return PriceRange(
      min: (json['min'] as num).toDouble(),
      max: (json['max'] as num).toDouble(),
      currency: json['currency'] as String,
      unit: json['unit'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
      'currency': currency,
      'unit': unit,
    };
  }

  @override
  List<Object?> get props => [min, max, currency, unit];
}
