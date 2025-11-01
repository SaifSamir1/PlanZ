// lib/features/vendor/presentation/cubit/vendor_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_model.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/repos/i_vendor_repository.dart';
import 'vendor_state.dart';

class VendorCubit extends Cubit<VendorState> {
  final VendorRepository repository;

  VendorCubit(this.repository) : super(VendorInitial());

  // ============================================
  // 1. PACKAGE MANAGEMENT
  // ============================================
// lib/features/vendor_features/packages_mangment/cubit/vendor_cubit.dart


  /// Create a new package
  Future<void> createPackage({
    required String vendorId,
    required String vendorName,
    required String serviceId,
    required String serviceName,
    required String packageName,
    required String description,
    required double price,
    String currency = 'EGP',
    String priceUnit = 'per_event',
    required List<String> features,
    required List<String> keywords,
    required List<PortfolioItem> portfolioLinks,
    Map<String, dynamic>? attributes,
  }) async {
    emit(CreatePackageLoading());

    final result = await repository.createPackage(
      vendorId: vendorId,
      vendorName: vendorName,
      serviceId: serviceId,
      serviceName: serviceName,
      packageName: packageName,
      description: description,
      price: price,
      currency: currency,
      priceUnit: priceUnit,
      features: features,
      keywords: keywords,
      portfolioLinks: portfolioLinks,
      attributes: attributes,
    );

    result.fold(
      (failure) => emit(CreatePackageError(failure.message)),
      (package) => emit(CreatePackageSuccess(package)),
    );
  }

  /// Update an existing package
  Future<void> updatePackage({
    required String packageId,
    String? packageName,
    String? packageNameAr,
    String? description,
    String? descriptionAr,
    double? price,
    List<String>? features,
    List<String>? featuresAr,
    List<String>? keywords,
    List<PortfolioItem>? portfolioLinks,
    Map<String, dynamic>? attributes,
    bool? isActive,
  }) async {
    emit(UpdatePackageLoading());

    final result = await repository.updatePackage(
      packageId: packageId,
      packageName: packageName,
      packageNameAr: packageNameAr,
      description: description,
      descriptionAr: descriptionAr,
      price: price,
      features: features,
      featuresAr: featuresAr,
      keywords: keywords,
      portfolioLinks: portfolioLinks,
      attributes: attributes,
      isActive: isActive,
    );

    result.fold(
      (failure) => emit(UpdatePackageError(failure.message)),
      (package) => emit(UpdatePackageSuccess(package)),
    );
  }

  /// Delete a package
  Future<void> deletePackage(String packageId) async {
    emit(DeletePackageLoading());

    final result = await repository.deletePackage(packageId);

    result.fold(
      (failure) => emit(DeletePackageError(failure.message)),
      (_) => emit(DeletePackageSuccess()),
    );
  }

  /// Toggle package active status
  Future<void> togglePackageStatus({
    required String packageId,
    required bool isActive,
  }) async {
    emit(TogglePackageStatusLoading());

    final result = await repository.togglePackageStatus(
      packageId: packageId,
      isActive: isActive,
    );

    result.fold(
      (failure) => emit(TogglePackageStatusError(failure.message)),
      (_) => emit(TogglePackageStatusSuccess()),
    );
  }

  /// Get all packages for a vendor
  Future<void> getVendorPackages(String vendorId) async {
    emit(GetVendorPackagesLoading());

    final result = await repository.getVendorPackages(vendorId);

    result.fold(
      (failure) => emit(GetVendorPackagesError(failure.message)),
      (packages) => emit(GetVendorPackagesSuccess(packages)),
    );
  }

  /// Get single package by ID
  Future<void> getPackageById(String packageId) async {
    emit(GetPackageByIdLoading());

    final result = await repository.getPackageById(packageId);

    result.fold(
      (failure) => emit(GetPackageByIdError(failure.message)),
      (package) => emit(GetPackageByIdSuccess(package)),
    );
  }

  // ============================================
  // 2. PACKAGE REQUESTS MANAGEMENT
  // ============================================

  /// Get all requests for a vendor
  Future<void> getVendorRequests(String vendorId) async {
    emit(GetVendorRequestsLoading());

    final result = await repository.getVendorRequests(vendorId);

    result.fold(
      (failure) => emit(GetVendorRequestsError(failure.message)),
      (requests) => emit(GetVendorRequestsSuccess(requests)),
    );
  }

  /// Get pending requests only
  Future<void> getPendingRequests(String vendorId) async {
    emit(GetPendingRequestsLoading());

    final result = await repository.getPendingRequests(vendorId);

    result.fold(
      (failure) => emit(GetPendingRequestsError(failure.message)),
      (requests) => emit(GetPendingRequestsSuccess(requests)),
    );
  }

  /// Get single request by ID
  Future<void> getRequestById(String requestId) async {
    emit(GetRequestByIdLoading());

    final result = await repository.getRequestById(requestId);

    result.fold(
      (failure) => emit(GetRequestByIdError(failure.message)),
      (request) => emit(GetRequestByIdSuccess(request)),
    );
  }

  /// Accept a package request
  Future<void> acceptRequest({
    required String requestId,
    String? vendorResponse,
  }) async {
    emit(AcceptRequestLoading());

    final result = await repository.acceptRequest(
      requestId: requestId,
      vendorResponse: vendorResponse,
    );

    result.fold(
      (failure) => emit(AcceptRequestError(failure.message)),
      (request) => emit(AcceptRequestSuccess(request)),
    );
  }

  /// Reject a package request
  Future<void> rejectRequest({
    required String requestId,
    required String rejectionReason,
  }) async {
    emit(RejectRequestLoading());

    final result = await repository.rejectRequest(
      requestId: requestId,
      rejectionReason: rejectionReason,
    );

    result.fold(
      (failure) => emit(RejectRequestError(failure.message)),
      (request) => emit(RejectRequestSuccess(request)),
    );
  }

  /// Mark expired requests (background job)
  Future<void> markExpiredRequests() async {
    await repository.markExpiredRequests();
  }

  // ============================================
  // 3. STATISTICS
  // ============================================

  /// Get vendor statistics
  Future<void> getVendorStats(String vendorId) async {
    emit(GetVendorStatsLoading());

    final result = await repository.getVendorStats(vendorId);

    result.fold(
      (failure) => emit(GetVendorStatsError(failure.message)),
      (stats) => emit(GetVendorStatsSuccess(stats)),
    );
  }

  /// Increment package views
  Future<void> incrementPackageViews(String packageId) async {
    await repository.incrementPackageViews(packageId);
  }

  /// Increment package bookings
  Future<void> incrementPackageBookings(String packageId) async {
    await repository.incrementPackageBookings(packageId);
  }
  
/// Get vendor available balance
Future<void> getVendorBalance(String vendorId) async {
  emit(GetVendorBalanceLoading());
  final result = await repository.getVendorBalance(vendorId);
  result.fold(
    (failure) => emit(GetVendorBalanceError(failure.message)),
    (balance) => emit(GetVendorBalanceSuccess(balance)),
  );
}

/// Request withdrawal
Future<void> requestWithdrawal({
  required String vendorId,
  required double amount,
  required String walletNumber,
  required String walletType,
  String? bankName,
  String? bankAccountHolder,
  String? notes,
}) async {
  emit(RequestWithdrawalLoading());
  final result = await repository.requestWithdrawal(
    vendorId: vendorId,
    amount: amount,
    walletNumber: walletNumber,
    walletType: walletType,
    bankName: bankName,
    bankAccountHolder: bankAccountHolder,
    notes: notes,
  );
  result.fold(
    (failure) => emit(RequestWithdrawalError(failure.message)),
    (request) => emit(RequestWithdrawalSuccess(request)),
  );
}

/// Get withdrawal requests
Future<void> getWithdrawals(String vendorId) async {
  emit(GetWithdrawalsLoading());
  final result = await repository.getWithdrawalRequests(vendorId);
  result.fold(
    (failure) => emit(GetWithdrawalsError(failure.message)),
    (withdrawals) => emit(GetWithdrawalsSuccess(withdrawals)),
  );
}

/// Get transaction history
Future<void> getTransactionHistory(String vendorId) async {
  emit(GetTransactionHistoryLoading());
  final result = await repository.getTransactionHistory(vendorId);
  result.fold(
    (failure) => emit(GetTransactionHistoryError(failure.message)),
    (transactions) => emit(GetTransactionHistorySuccess(transactions)),
  );
}
}
