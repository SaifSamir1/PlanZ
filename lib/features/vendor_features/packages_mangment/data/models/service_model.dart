// lib/core/models/service_model.dart

class ServiceModel {
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

  ServiceModel({
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

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      serviceId: json['serviceId'] ?? '',
      serviceName: json['serviceName'] ?? '',
      serviceNameAr: json['serviceNameAr'] ?? '',
      icon: json['icon'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      descriptionAr: json['descriptionAr'] ?? '',
      isActive: json['isActive'] ?? true,
      popularityRank: json['popularityRank'] ?? 0,
      keywords: List<String>.from(json['keywords'] ?? []),
      usedInEventTypes: List<String>.from(json['usedInEventTypes'] ?? []),
      commonAttributes: List<String>.from(json['commonAttributes'] ?? []),
      priceRange: PriceRange.fromJson(json['priceRange'] ?? {}),
    );
  }

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
}

class PriceRange {
  final double min;
  final double max;
  final String currency;
  final String unit;

  PriceRange({
    required this.min,
    required this.max,
    required this.currency,
    required this.unit,
  });

  factory PriceRange.fromJson(Map<String, dynamic> json) {
    return PriceRange(
      min: (json['min'] ?? 0).toDouble(),
      max: (json['max'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'EGP',
      unit: json['unit'] ?? 'per_event',
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
}
