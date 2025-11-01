// lib/features/app_owner/data/repositories/app_owner_repository.dart

import 'package:dartz/dartz.dart';
import 'package:plan_z/core/error/failures.dart';
import 'package:plan_z/features/app_owner/data/model/financial_overview_model.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_model.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/withdrawal_request_model.dart';

abstract class AppOwnerRepository {
  // ===== Package Approvals =====
  Future<Either<Failure, List<PackageModel>>> getPendingPackages();

  Future<Either<Failure, PackageModel>> approvePackage({
    required String packageId,
    String? approvalNotes,
  });

  Future<Either<Failure, void>> rejectPackage({
    required String packageId,
    required String rejectionReason,
  });

  // ===== Withdrawal Requests =====
  Future<Either<Failure, List<WithdrawalRequestModel>>>
      getPendingWithdrawals();

  Future<Either<Failure, WithdrawalRequestModel>> approveWithdrawal({
    required String withdrawalId,
    required String transactionReference,
    String? notes,
  });

  Future<Either<Failure, void>> rejectWithdrawal({
    required String withdrawalId,
    required String rejectionReason,
  });

  // ===== Financial Overview =====
  Future<Either<Failure, AppOwnerFinancialOverview>> getFinancialOverview({
    String? period,
  });

  // ===== Dashboard Stats =====
  Future<Either<Failure, Map<String, dynamic>>> getDashboardStats();
}
