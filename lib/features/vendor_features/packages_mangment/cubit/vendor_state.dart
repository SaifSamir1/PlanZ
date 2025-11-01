// lib/features/vendor/presentation/cubit/vendor_state.dart

import 'package:equatable/equatable.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_model.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_request_model.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/withdrawal_request_model.dart';

abstract class VendorState extends Equatable {
  const VendorState();

  @override
  List<Object?> get props => [];
}

// ============================================
// Initial State
// ============================================
class VendorInitial extends VendorState {}

// ============================================
// 1. PACKAGE MANAGEMENT STATES
// ============================================

// Create Package
class CreatePackageLoading extends VendorState {}

class CreatePackageSuccess extends VendorState {
  final PackageModel package;

  const CreatePackageSuccess(this.package);

  @override
  List<Object?> get props => [package];
}

class CreatePackageError extends VendorState {
  final String message;

  const CreatePackageError(this.message);

  @override
  List<Object?> get props => [message];
}

// Update Package
class UpdatePackageLoading extends VendorState {}

class UpdatePackageSuccess extends VendorState {
  final PackageModel package;

  const UpdatePackageSuccess(this.package);

  @override
  List<Object?> get props => [package];
}

class UpdatePackageError extends VendorState {
  final String message;

  const UpdatePackageError(this.message);

  @override
  List<Object?> get props => [message];
}

// Delete Package
class DeletePackageLoading extends VendorState {}

class DeletePackageSuccess extends VendorState {}

class DeletePackageError extends VendorState {
  final String message;

  const DeletePackageError(this.message);

  @override
  List<Object?> get props => [message];
}

// Toggle Package Status
class TogglePackageStatusLoading extends VendorState {}

class TogglePackageStatusSuccess extends VendorState {}

class TogglePackageStatusError extends VendorState {
  final String message;

  const TogglePackageStatusError(this.message);

  @override
  List<Object?> get props => [message];
}

// Get Vendor Packages
class GetVendorPackagesLoading extends VendorState {}

class GetVendorPackagesSuccess extends VendorState {
  final List<PackageModel> packages;

  const GetVendorPackagesSuccess(this.packages);

  @override
  List<Object?> get props => [packages];
}

class GetVendorPackagesError extends VendorState {
  final String message;

  const GetVendorPackagesError(this.message);

  @override
  List<Object?> get props => [message];
}

// Get Package By ID
class GetPackageByIdLoading extends VendorState {}

class GetPackageByIdSuccess extends VendorState {
  final PackageModel package;

  const GetPackageByIdSuccess(this.package);

  @override
  List<Object?> get props => [package];
}

class GetPackageByIdError extends VendorState {
  final String message;

  const GetPackageByIdError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 2. PACKAGE REQUESTS STATES
// ============================================

// Get Vendor Requests
class GetVendorRequestsLoading extends VendorState {}

class GetVendorRequestsSuccess extends VendorState {
  final List<PackageRequestModel> requests;

  const GetVendorRequestsSuccess(this.requests);

  @override
  List<Object?> get props => [requests];
}

class GetVendorRequestsError extends VendorState {
  final String message;

  const GetVendorRequestsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Get Pending Requests
class GetPendingRequestsLoading extends VendorState {}

class GetPendingRequestsSuccess extends VendorState {
  final List<PackageRequestModel> requests;

  const GetPendingRequestsSuccess(this.requests);

  @override
  List<Object?> get props => [requests];
}

class GetPendingRequestsError extends VendorState {
  final String message;

  const GetPendingRequestsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Get Request By ID
class GetRequestByIdLoading extends VendorState {}

class GetRequestByIdSuccess extends VendorState {
  final PackageRequestModel request;

  const GetRequestByIdSuccess(this.request);

  @override
  List<Object?> get props => [request];
}

class GetRequestByIdError extends VendorState {
  final String message;

  const GetRequestByIdError(this.message);

  @override
  List<Object?> get props => [message];
}

// Accept Request
class AcceptRequestLoading extends VendorState {}

class AcceptRequestSuccess extends VendorState {
  final PackageRequestModel request;

  const AcceptRequestSuccess(this.request);

  @override
  List<Object?> get props => [request];
}

class AcceptRequestError extends VendorState {
  final String message;

  const AcceptRequestError(this.message);

  @override
  List<Object?> get props => [message];
}

// Reject Request
class RejectRequestLoading extends VendorState {}

class RejectRequestSuccess extends VendorState {
  final PackageRequestModel request;

  const RejectRequestSuccess(this.request);

  @override
  List<Object?> get props => [request];
}

class RejectRequestError extends VendorState {
  final String message;

  const RejectRequestError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 3. STATISTICS STATES
// ============================================

// Get Vendor Stats
class GetVendorStatsLoading extends VendorState {}

class GetVendorStatsSuccess extends VendorState {
  final Map<String, dynamic> stats;

  const GetVendorStatsSuccess(this.stats);

  @override
  List<Object?> get props => [stats];
}

class GetVendorStatsError extends VendorState {
  final String message;

  const GetVendorStatsError(this.message);

  @override
  List<Object?> get props => [message];
}


// Get Vendor Balance
class GetVendorBalanceLoading extends VendorState {}
class GetVendorBalanceSuccess extends VendorState {
  final double balance;
  const GetVendorBalanceSuccess(this.balance);
  @override
  List get props => [balance];
}
class GetVendorBalanceError extends VendorState {
  final String message;
  const GetVendorBalanceError(this.message);
  @override
  List get props => [message];
}

// Request Withdrawal
class RequestWithdrawalLoading extends VendorState {}
class RequestWithdrawalSuccess extends VendorState {
  final WithdrawalRequestModel request;
  const RequestWithdrawalSuccess(this.request);
  @override
  List get props => [request];
}
class RequestWithdrawalError extends VendorState {
  final String message;
  const RequestWithdrawalError(this.message);
  @override
  List get props => [message];
}

// Get Withdrawals
class GetWithdrawalsLoading extends VendorState {}
class GetWithdrawalsSuccess extends VendorState {
  final List<WithdrawalRequestModel> withdrawals;
  const GetWithdrawalsSuccess(this.withdrawals);
  @override
  List get props => [withdrawals];
}
class GetWithdrawalsError extends VendorState {
  final String message;
  const GetWithdrawalsError(this.message);
  @override
  List get props => [message];
}

// Get Transaction History
class GetTransactionHistoryLoading extends VendorState {}
class GetTransactionHistorySuccess extends VendorState {
  final List<Map<String, dynamic>> transactions;
  const GetTransactionHistorySuccess(this.transactions);
  @override
  List get props => [transactions];
}
class GetTransactionHistoryError extends VendorState {
  final String message;
  const GetTransactionHistoryError(this.message);
  @override
  List get props => [message];
}