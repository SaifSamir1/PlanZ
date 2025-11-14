// lib/features/vendor/data/repositories/vendor_repo.dart

import 'package:dartz/dartz.dart';
import 'package:plan_z/core/error/failures.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_model.dart';

import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_request_model.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/withdrawal_request_model.dart';

abstract class VendorRepository {
  // ===== Package Management =====
  
  /// Create a new package (isActive = false by default)
  Future<Either<Failure, PackageModel>> createPackage({
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
    String? vendorFcmToken,  // ✅ FCM Token للـ Vendor
  });

  /// Update an existing package
  Future<Either<Failure, PackageModel>> updatePackage({
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
  });

  /// Delete a package
  Future<Either<Failure, void>> deletePackage(String packageId);

  /// Toggle package active status (Vendor can enable/disable)
  Future<Either<Failure, void>> togglePackageStatus({
    required String packageId,
    required bool isActive,
  });

  /// Get vendor's packages
  Future<Either<Failure, List<PackageModel>>> getVendorPackages(
    String vendorId,
  );

  /// Get single package by ID
  Future<Either<Failure, PackageModel>> getPackageById(String packageId);

  /// Get packages by service ID
  Future<Either<Failure, List<PackageModel>>> getPackagesByService({
    required String serviceId,
    bool? onlyActive,
  });

  /// Search packages by keywords
  Future<Either<Failure, List<PackageModel>>> searchPackages({
    required String searchQuery,
    String? serviceId,
    double? minPrice,
    double? maxPrice,
  });

  // ===== Package Requests Management =====

  /// Get all requests for a vendor (pending, accepted, rejected)
  Future<Either<Failure, List<PackageRequestModel>>> getVendorRequests(
    String vendorId,
  );

  /// Get pending requests only
  Future<Either<Failure, List<PackageRequestModel>>> getPendingRequests(
    String vendorId,
  );

  /// Get single request by ID
  Future<Either<Failure, PackageRequestModel>> getRequestById(
    String requestId,
  );

  /// Accept a package request
  Future<Either<Failure, PackageRequestModel>> acceptRequest({
    required String requestId,
    String? vendorResponse,
  });

  /// Reject a package request
  Future<Either<Failure, PackageRequestModel>> rejectRequest({
    required String requestId,
    required String rejectionReason,
  });

  /// Mark expired requests (background job)
  Future<Either<Failure, void>> markExpiredRequests();

  // ===== Statistics =====

  /// Get vendor statistics
  Future<Either<Failure, Map<String, dynamic>>> getVendorStats(
    String vendorId,
  );

  /// Increment package view count
  Future<Either<Failure, void>> incrementPackageViews(String packageId);

  /// Increment package booking count
  Future<Either<Failure, void>> incrementPackageBookings(String packageId);

  /// Get vendor available balance
Future<Either<Failure, double>> getVendorBalance(String vendorId);

/// Request withdrawal
Future<Either<Failure, WithdrawalRequestModel>> requestWithdrawal({
  required String vendorId,
  required double amount,
  required String walletNumber,
  required String walletType,
  String? bankName,
  String? bankAccountHolder,
  String? notes,
});

/// Get vendor withdrawal requests
Future<Either<Failure, List<WithdrawalRequestModel>>> getWithdrawalRequests(
  String vendorId,
);

/// Get pending withdrawal requests only
Future<Either<Failure, List<WithdrawalRequestModel>>> getPendingWithdrawals(
  String vendorId,
);

/// Get withdrawal request by ID
Future<Either<Failure, WithdrawalRequestModel>> getWithdrawalById(
  String requestId,
);

/// Get vendor transaction history (earnings + withdrawals)
Future<Either<Failure, List<Map<String, dynamic>>>> getTransactionHistory(
  String vendorId,
);
}
