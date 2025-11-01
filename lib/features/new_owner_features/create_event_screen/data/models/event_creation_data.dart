// lib/features/event_owner/data/models/event_creation_data.dart

import 'package:flutter/material.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_model.dart';

class EventCreationData {
  // ============================================
  // Step 1: Event Type
  // ============================================
  final String? eventTypeId;
  final String? eventTypeName;
  final String? eventTypeNameAr;

  // ============================================
  // Step 2: Basic Info
  // ============================================
  final String? eventName;
  final DateTime? eventDate;
  final TimeOfDay? eventTime;
  final String? city;
  final String? area;
  final int? guestCount;
  final String? additionalNotes;

  // ============================================
  // Step 3: Budget
  // ============================================
  final double? totalBudget;
  final String? currency;
  final Map<String, dynamic>? suggestedBudgetRange;

  // ============================================
  // Step 4: Services Selection
  // ============================================
  final List<Map<String, dynamic>>? selectedServices;
  final double? allocatedBudget;
  final double? remainingBudget;

  // ============================================
  // Step 5: Selected Packages ✅ معدّل - Multiple Packages!
  // ============================================
  // ✅ Key: serviceId, Value: PackageModel Object
  // ✅ يمكن يكون أكتر من package لنفس الـ Event
  final Map<String, PackageModel>? selectedPackages;

  EventCreationData({
    // Step 1
    this.eventTypeId,
    this.eventTypeName,
    this.eventTypeNameAr,
    // Step 2
    this.eventName,
    this.eventDate,
    this.eventTime,
    this.city,
    this.area,
    this.guestCount,
    this.additionalNotes,
    // Step 3
    this.totalBudget,
    this.currency,
    this.suggestedBudgetRange,
    // Step 4
    this.selectedServices,
    this.allocatedBudget,
    this.remainingBudget,
    // Step 5
    this.selectedPackages,
  });

  /// CopyWith Method
  EventCreationData copyWith({
    // Step 1
    String? eventTypeId,
    String? eventTypeName,
    String? eventTypeNameAr,
    // Step 2
    String? eventName,
    DateTime? eventDate,
    TimeOfDay? eventTime,
    String? city,
    String? area,
    int? guestCount,
    String? additionalNotes,
    // Step 3
    double? totalBudget,
    String? currency,
    Map<String, dynamic>? suggestedBudgetRange,
    // Step 4
    List<Map<String, dynamic>>? selectedServices,
    double? allocatedBudget,
    double? remainingBudget,
    // Step 5
    Map<String, PackageModel>? selectedPackages, // ✅ Type Safe
  }) {
    return EventCreationData(
      // Step 1
      eventTypeId: eventTypeId ?? this.eventTypeId,
      eventTypeName: eventTypeName ?? this.eventTypeName,
      eventTypeNameAr: eventTypeNameAr ?? this.eventTypeNameAr,
      // Step 2
      eventName: eventName ?? this.eventName,
      eventDate: eventDate ?? this.eventDate,
      eventTime: eventTime ?? this.eventTime,
      city: city ?? this.city,
      area: area ?? this.area,
      guestCount: guestCount ?? this.guestCount,
      additionalNotes: additionalNotes ?? this.additionalNotes,
      // Step 3
      totalBudget: totalBudget ?? this.totalBudget,
      currency: currency ?? this.currency,
      suggestedBudgetRange: suggestedBudgetRange ?? this.suggestedBudgetRange,
      // Step 4
      selectedServices: selectedServices ?? this.selectedServices,
      allocatedBudget: allocatedBudget ?? this.allocatedBudget,
      remainingBudget: remainingBudget ?? this.remainingBudget,
      // Step 5
      selectedPackages: selectedPackages ?? this.selectedPackages,
    );
  }

  /// ✅ Helper Method: Get Total Package Count
  int get packageCount => selectedPackages?.length ?? 0;

  /// ✅ Helper Method: Get Total Packages Price
  double get totalPackagesPrice {
    if (selectedPackages == null || selectedPackages!.isEmpty) return 0.0;
    return selectedPackages!.values
        .fold(0.0, (sum, package) => sum + (package.price ?? 0.0));
  }

  /// ✅ Helper Method: Get Package by ServiceId
  PackageModel? getPackageByServiceId(String serviceId) {
    return selectedPackages?[serviceId];
  }

  /// ✅ Helper Method: Has Package for Service
  bool hasPackageForService(String serviceId) {
    return selectedPackages?.containsKey(serviceId) ?? false;
  }
}
