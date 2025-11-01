// lib/features/event_owner/presentation/cubit/event_creation_cubit.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_creation_data.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_model.dart';

class EventCreationCubit extends Cubit<EventCreationData> {
  EventCreationCubit() : super(EventCreationData());

  // ============================================
  // Step 1: Set Event Type
  // ============================================
  void setEventType({
    required String eventTypeId,
    required String eventTypeName,
    String? eventTypeNameAr,
  }) {
    emit(state.copyWith(
      eventTypeId: eventTypeId,
      eventTypeName: eventTypeName,
      eventTypeNameAr: eventTypeNameAr,
    ));
  }

  // ============================================
  // Step 2: Set Basic Info
  // ============================================
  void setBasicInfo({
    required String eventName,
    required DateTime eventDate,
    required TimeOfDay eventTime,
    required String city,
    required String area,
    required int guestCount,
    String? additionalNotes,
  }) {
    emit(state.copyWith(
      eventName: eventName,
      eventDate: eventDate,
      eventTime: eventTime,
      city: city,
      area: area,
      guestCount: guestCount,
      additionalNotes: additionalNotes,
    ));
  }

  // ============================================
  // Step 3: Set Budget
  // ============================================
  void setBudget({
    required double totalBudget,
    String currency = 'EGP',
    Map<String, dynamic>? suggestedBudgetRange,
  }) {
    emit(state.copyWith(
      totalBudget: totalBudget,
      currency: currency,
      suggestedBudgetRange: suggestedBudgetRange,
    ));
  }

  // ============================================
  // Step 4: Set Selected Services
  // ============================================
  void setSelectedServices({
    required List<Map<String, dynamic>> selectedServices,
    required double allocatedBudget,
    required double remainingBudget,
  }) {
    emit(state.copyWith(
      selectedServices: selectedServices,
      allocatedBudget: allocatedBudget,
      remainingBudget: remainingBudget,
    ));
  }

  // ============================================
  // Step 5: Set Multiple Selected Packages ✅
  // ============================================
  // ✅ هنا بنحفظ كل الـ Packages بشكل آمن
  void setSelectedPackages({
    required Map<String, PackageModel> selectedPackages,
  }) {
    debugPrint('📦 Setting selected packages (Count: ${selectedPackages.length})');
    selectedPackages.forEach((serviceId, package) {
      debugPrint('  ✅ Service: $serviceId -> Package: ${package.packageName} (Price: ${package.price})');
    });

    emit(state.copyWith(
      selectedPackages: selectedPackages,
    ));
  }

  // ============================================
  // Add Single Package ✅
  // ============================================
  // ✅ إضافة package واحد لـ service معينة
  void addPackageToService({
    required String serviceId,
    required PackageModel package,
  }) {
    final currentPackages = Map<String, PackageModel>.from(state.selectedPackages ?? {});
    currentPackages[serviceId] = package;
    
    debugPrint('➕ Adding package for service: $serviceId');
    debugPrint('   Package: ${package.packageName}');
    debugPrint('   Total packages now: ${currentPackages.length}');

    emit(state.copyWith(selectedPackages: currentPackages));
  }

  // ============================================
  // Update Single Package ✅
  // ============================================
  // ✅ تحديث package معينة (replace)
  void updatePackageForService({
    required String serviceId,
    required PackageModel newPackage,
  }) {
    final currentPackages = Map<String, PackageModel>.from(state.selectedPackages ?? {});
    
    if (currentPackages.containsKey(serviceId)) {
      debugPrint('🔄 Updating package for service: $serviceId');
      debugPrint('   Old: ${currentPackages[serviceId]?.packageName}');
      debugPrint('   New: ${newPackage.packageName}');
    }
    
    currentPackages[serviceId] = newPackage;
    emit(state.copyWith(selectedPackages: currentPackages));
  }

  // ============================================
  // Remove Single Package ✅
  // ============================================
  // ✅ حذف package من service معينة
  void removePackageForService(String serviceId) {
    final currentPackages = Map<String, PackageModel>.from(state.selectedPackages ?? {});
    
    if (currentPackages.containsKey(serviceId)) {
      debugPrint('❌ Removing package for service: $serviceId');
      currentPackages.remove(serviceId);
      debugPrint('   Remaining packages: ${currentPackages.length}');
    }

    emit(state.copyWith(selectedPackages: currentPackages));
  }

  // ============================================
  // Clear All Packages ✅
  // ============================================
  // ✅ حذف كل الـ Packages
  void clearAllPackages() {
    debugPrint('🗑️ Clearing all packages');
    emit(state.copyWith(selectedPackages: {}));
  }

  // ============================================
  // Get Package for Service ✅
  // ============================================
  // ✅ الحصول على package لـ service معينة
  PackageModel? getPackageForService(String serviceId) {
    return state.selectedPackages?[serviceId];
  }

  // ============================================
  // Check if Service has Package ✅
  // ============================================
  // ✅ التحقق من وجود package لـ service
  bool hasPackageForService(String serviceId) {
    return state.selectedPackages?.containsKey(serviceId) ?? false;
  }

  // ============================================
  // Get All Selected Packages ✅
  // ============================================
  // ✅ الحصول على كل الـ Packages
  Map<String, PackageModel> getAllSelectedPackages() {
    return state.selectedPackages ?? {};
  }

  // ============================================
  // Get Total Packages Count ✅
  // ============================================
  int getPackagesCount() {
    return state.packageCount;
  }

  // ============================================
  // Get Total Packages Price ✅
  // ============================================
  double getTotalPackagesPrice() {
    return state.totalPackagesPrice;
  }

  // ============================================
  // Reset All Data
  // ============================================
  void reset() {
    debugPrint('🔄 Resetting all event creation data');
    emit(EventCreationData());
  }

  // ============================================
  // Get Current Data
  // ============================================
  EventCreationData get currentData => state;
}
