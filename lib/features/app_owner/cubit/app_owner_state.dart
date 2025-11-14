// lib/features/app_owner/presentation/cubits/app_owner_state.dart

import 'package:plan_z/features/app_owner/data/model/financial_overview_model.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_model.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/withdrawal_request_model.dart';

class AppOwnerState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final List<PackageModel> pendingPackages;
  final List<WithdrawalRequestModel> pendingWithdrawals;
  final AppOwnerFinancialOverview? financialOverview;
  final Map<String, dynamic>? dashboardStats;
  final Map<String, dynamic>? ownerProfits;

  const AppOwnerState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.pendingPackages = const [],
    this.pendingWithdrawals = const [],
    this.financialOverview,
    this.dashboardStats,
    this.ownerProfits,
  });

  AppOwnerState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    List<PackageModel>? pendingPackages,
    List<WithdrawalRequestModel>? pendingWithdrawals,
    AppOwnerFinancialOverview? financialOverview,
    Map<String, dynamic>? dashboardStats,
    Map<String, dynamic>? ownerProfits,
  }) {
    return AppOwnerState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
      pendingPackages: pendingPackages ?? this.pendingPackages,
      pendingWithdrawals: pendingWithdrawals ?? this.pendingWithdrawals,
      financialOverview: financialOverview ?? this.financialOverview,
      dashboardStats: dashboardStats ?? this.dashboardStats,
      ownerProfits: ownerProfits ?? this.ownerProfits,
    );
  }
}
