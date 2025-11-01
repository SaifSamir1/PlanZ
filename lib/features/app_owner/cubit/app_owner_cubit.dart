// lib/features/app_owner/presentation/cubits/app_owner_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/features/app_owner/data/repo/app_owner_repository.dart';
import 'app_owner_state.dart';

class AppOwnerCubit extends Cubit<AppOwnerState> {
  final AppOwnerRepository _repository;

  AppOwnerCubit(this._repository) : super(const AppOwnerState());

  // ===== Package Approval =====
  
  Future<void> loadPendingPackages() async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.getPendingPackages();
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (packages) => emit(state.copyWith(
        isLoading: false,
        pendingPackages: packages,
      )),
    );
  }

  Future<void> approvePackage({
    required String packageId,
    String? approvalNotes,
  }) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.approvePackage(
      packageId: packageId,
      approvalNotes: approvalNotes,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (package) {
        final updatedPackages = state.pendingPackages
            .where((p) => p.packageId != packageId)
            .toList();
        emit(state.copyWith(
          isLoading: false,
          pendingPackages: updatedPackages,
          successMessage: '✅ Package approved successfully!',
        ));
      },
    );
  }

  Future<void> rejectPackage({
    required String packageId,
    required String rejectionReason,
  }) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.rejectPackage(
      packageId: packageId,
      rejectionReason: rejectionReason,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (_) {
        final updatedPackages = state.pendingPackages
            .where((p) => p.packageId != packageId)
            .toList();
        emit(state.copyWith(
          isLoading: false,
          pendingPackages: updatedPackages,
          successMessage: '❌ Package rejected!',
        ));
      },
    );
  }

  // ===== Withdrawal Requests =====
  
  Future<void> loadPendingWithdrawals() async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.getPendingWithdrawals();
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (withdrawals) => emit(state.copyWith(
        isLoading: false,
        pendingWithdrawals: withdrawals,
      )),
    );
  }

  Future<void> approveWithdrawal({
    required String withdrawalId,
    required String transactionReference,
    String? notes,
  }) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.approveWithdrawal(
      withdrawalId: withdrawalId,
      transactionReference: transactionReference,
      notes: notes,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (withdrawal) {
        final updatedWithdrawals = state.pendingWithdrawals
            .where((w) => w.id != withdrawalId)
            .toList();
        emit(state.copyWith(
          isLoading: false,
          pendingWithdrawals: updatedWithdrawals,
          successMessage: '✅ Withdrawal approved! Amount: EGP ${withdrawal.amount.toStringAsFixed(2)}',
        ));
      },
    );
  }

  // ✅ NEW METHOD: Reject Withdrawal
  Future<void> rejectWithdrawal({
    required String withdrawalId,
    required String rejectionReason,
  }) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.rejectWithdrawal(
      withdrawalId: withdrawalId,
      rejectionReason: rejectionReason,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (_) {
        final updatedWithdrawals = state.pendingWithdrawals
            .where((w) => w.id != withdrawalId)
            .toList();
        emit(state.copyWith(
          isLoading: false,
          pendingWithdrawals: updatedWithdrawals,
          successMessage: '❌ Withdrawal rejected!',
        ));
      },
    );
  }

  // ===== Financial Overview =====
  
  Future<void> loadFinancialOverview({String? period}) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.getFinancialOverview(period: period);
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (overview) => emit(state.copyWith(
        isLoading: false,
        financialOverview: overview,
      )),
    );
  }

  // ===== Dashboard Stats =====
  
  Future<void> loadDashboardStats() async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.getDashboardStats();
    result.fold(
      (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      )),
      (stats) => emit(state.copyWith(
        isLoading: false,
        dashboardStats: stats,
      )),
    );
  }

  // ===== Clear Messages =====
  void clearMessages() {
    emit(state.copyWith(
      errorMessage: null,
      successMessage: null,
    ));
  }
}
