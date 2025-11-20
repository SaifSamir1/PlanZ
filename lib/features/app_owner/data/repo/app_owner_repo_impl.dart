// lib/features/app_owner/data/repositories/app_owner_repo_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:plan_z/core/constants/constants.dart';
import 'package:plan_z/core/error/failures.dart';
import 'package:plan_z/core/services/notification_service.dart';
import 'package:plan_z/features/app_owner/data/model/financial_overview_model.dart';
import 'package:plan_z/features/app_owner/data/repo/app_owner_repository.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_model.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_request_model.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/withdrawal_request_model.dart';

class AppOwnerRepositoryImpl implements AppOwnerRepository {
  final FirebaseFirestore _firestore;

  // ✅ Constants
  static const VENDOR_COMMISSION_RATE = 0.80; // 80% للـ Vendors
  static const APP_PROFIT_RATE = 0.20; // 20% للتطبيق

  AppOwnerRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // ===== Package Approval =====

  @override
  Future<Either<Failure, List<PackageModel>>> getPendingPackages() async {
    try {
      // ✅ جلب الـ packages بدون composite query
      final querySnapshot = await _firestore
          .collection(FirebaseCollections.packages)
          .get();

      // ✅ تصفية يدويا في البرنامج (بدون index)
      final packages =
          querySnapshot.docs
              .map((doc) => PackageModel.fromJson(doc.data()))
              .where(
                (pkg) =>
                    pkg.status == PackageStatus.pending &&
                    pkg.isApprovedByOwner != true,
              )
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return Right(packages);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to get pending packages'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PackageModel>> approvePackage({
    required String packageId,
    String? approvalNotes,
  }) async {
    try {
      final docRef = _firestore
          .collection(FirebaseCollections.packages)
          .doc(packageId);

      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        return Left(ServerFailure('Package not found'));
      }

      final now = DateTime.now();

      // ✅ Update package
      await docRef.update({
        'isApprovedByOwner': true,
        'status': 'active',
        'isActive': true,
        'approvalNotes': approvalNotes,
        'approvedAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      });

      // ✅ Fetch updated package
      final updatedDoc = await docRef.get();
      final approvedPackage = PackageModel.fromJson(
        updatedDoc.data() as Map<String, dynamic>,
      );

      // ✅ Notify vendor of package approval
      try {
        await NotificationService.sendNotification(
          receiverId: approvedPackage.vendorId,
          receiverRole: 'vendor',
          title: '✅ Package Approved!',
          body:
              'Your package "${approvedPackage.packageName}" has been approved and is now active',
          type: 'package_approved',
          data: {
            'packageId': approvedPackage.packageId ?? '',
            'packageName': approvedPackage.packageName,
            'status': 'active',
            'approvedAt': now.toIso8601String(),
            'price': approvedPackage.price.toString(),
          },
        );
        debugPrint('✅ Vendor notified of package approval');
      } catch (e) {
        debugPrint('⚠️ Failed to notify vendor: $e');
      }

      return Right(approvedPackage);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to approve package'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> rejectPackage({
    required String packageId,
    required String rejectionReason,
  }) async {
    try {
      final docRef = _firestore
          .collection(FirebaseCollections.packages)
          .doc(packageId);

      await docRef.update({
        'isApprovedByOwner': false,
        'status': 'rejected',
        'isActive': false,
        'rejectionReason': rejectionReason,
        'rejectedAt': Timestamp.fromDate(DateTime.now()),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to reject package'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ===== Withdrawal Requests =====

  @override
  Future<Either<Failure, List<WithdrawalRequestModel>>>
  getPendingWithdrawals() async {
    try {
      // ✅ جلب بدون index - تصفية يدويا
      final querySnapshot = await _firestore
          .collection(FirebaseCollections.withdrawals)
          .get();

      final withdrawals =
          querySnapshot.docs
              .map((doc) => WithdrawalRequestModel.fromJson(doc.data()))
              .where((w) => w.status == WithdrawalStatus.pending)
              .toList()
            ..sort((a, b) => b.requestedAt.compareTo(a.requestedAt));

      return Right(withdrawals);
    } on FirebaseException catch (e) {
      return Left(
        ServerFailure(e.message ?? 'Failed to get pending withdrawals'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WithdrawalRequestModel>> approveWithdrawal({
    required String withdrawalId,
    required String transactionReference,
    String? notes,
  }) async {
    try {
      final docRef = _firestore
          .collection(FirebaseCollections.withdrawals)
          .doc(withdrawalId);

      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        return Left(ServerFailure('Withdrawal request not found'));
      }

      final withdrawal = WithdrawalRequestModel.fromJson(docSnapshot.data()!);

      final now = DateTime.now();

      // ✅ Update withdrawal request
      await docRef.update({
        'status': 'completed',
        'transactionReference': transactionReference,
        'approvalNotes': notes,
        'approvedAt': Timestamp.fromDate(now),
        'completedAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      });

      // ✅ Update vendor balance
      await _firestore
          .collection(FirebaseCollections.vendors)
          .doc(withdrawal.vendorId)
          .update({
            'availableBalance': FieldValue.increment(-withdrawal.amount),
            'pendingWithdrawal': FieldValue.increment(-withdrawal.amount),
            'totalWithdrawn': FieldValue.increment(withdrawal.amount),
            'lastWithdrawalCompleted': Timestamp.fromDate(now),
          });

      // ✅ Create transaction log
      await _firestore.collection(FirebaseCollections.transactions).add({
        'type': 'vendor_payout',
        'vendorId': withdrawal.vendorId,
        'amount': withdrawal.amount,
        'walletType': withdrawal.walletType,
        'status': 'completed',
        'transactionReference': transactionReference,
        'createdAt': Timestamp.fromDate(now),
      });

      final updatedDoc = await docRef.get();
      final updatedWithdrawal = WithdrawalRequestModel.fromJson(
        updatedDoc.data()!,
      );

      return Right(updatedWithdrawal);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to approve withdrawal'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> rejectWithdrawal({
    required String withdrawalId,
    required String rejectionReason,
  }) async {
    try {
      final docRef = _firestore
          .collection(FirebaseCollections.withdrawals)
          .doc(withdrawalId);

      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        return Left(ServerFailure('Withdrawal request not found'));
      }

      final withdrawal = WithdrawalRequestModel.fromJson(docSnapshot.data()!);

      final now = DateTime.now();

      // ✅ Update withdrawal request
      await docRef.update({
        'status': 'rejected',
        'rejectionReason': rejectionReason,
        'rejectedAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      });

      // ✅ Update vendor pending withdrawal
      await _firestore
          .collection(FirebaseCollections.vendors)
          .doc(withdrawal.vendorId)
          .update({
            'pendingWithdrawal': FieldValue.increment(-withdrawal.amount),
          });

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to reject withdrawal'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ===== Financial Overview =====

  @override
  Future<Either<Failure, AppOwnerFinancialOverview>> getFinancialOverview({
    String? period,
  }) async {
    try {
      // ✅ جلب كل البيانات بدون filter معقد
      final requestsSnapshot = await _firestore
          .collection(FirebaseCollections.packageRequests)
          .get();

      DateTime startDate;

      // ✅ تحديد التاريخ حسب الفترة
      switch (period) {
        case 'Today':
          startDate = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          );
          break;
        case 'This Week':
          startDate = DateTime.now().subtract(const Duration(days: 7));
          break;
        case 'This Year':
          startDate = DateTime(DateTime.now().year, 1, 1);
          break;
        case 'All Time':
          startDate = DateTime(2020, 1, 1);
          break;
        case 'This Month':
        default:
          startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
      }

      double totalRevenue = 0;
      List<FinancialTransaction> transactions = [];

      // ✅ تصفية يدويا في البرنامج
      for (var doc in requestsSnapshot.docs) {
        final request = PackageRequestModel.fromJson(doc.data());

        // التحقق من الحالة والتاريخ
        if (request.status == RequestStatus.accepted &&
            request.acceptedAt != null &&
            request.acceptedAt!.isAfter(startDate)) {
          totalRevenue += request.packagePrice ?? 0.0;

          transactions.add(
            FinancialTransaction(
              id: request.requestId ?? '',
              type: 'revenue',
              title: 'Package Request Accepted',
              description:
                  'From: ${request.eventOwnerName ?? "Unknown"} - ${request.packageName ?? "Package"}',
              amount: request.packagePrice ?? 0.0,
              date: request.acceptedAt ?? DateTime.now(),
              status: 'completed',
            ),
          );
        }
      }

      // ✅ حساب الأرباح
      final vendorPayouts = totalRevenue * VENDOR_COMMISSION_RATE;
      final appProfit = totalRevenue * APP_PROFIT_RATE;

      // ✅ جلب الحجب المعلق
      final pendingSnapshot = await _firestore
          .collection(FirebaseCollections.withdrawals)
          .get();

      double pendingPayments = 0;
      for (var doc in pendingSnapshot.docs) {
        final withdrawal = WithdrawalRequestModel.fromJson(doc.data());
        if (withdrawal.status == WithdrawalStatus.pending) {
          pendingPayments += withdrawal.amount;
        }
      }

      // ✅ جلب الإحصائيات
      final stats = await _getDashboardStats();

      final overview = AppOwnerFinancialOverview(
        totalRevenue: totalRevenue,
        vendorPayouts: vendorPayouts,
        appProfit: appProfit,
        pendingPayments: pendingPayments,
        stats: stats,
        recentTransactions: transactions.take(10).toList(),
      );

      return Right(overview);
    } on FirebaseException catch (e) {
      return Left(
        ServerFailure(e.message ?? 'Failed to get financial overview'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getDashboardStats() async {
    try {
      final stats = await _getDashboardStats();
      return Right(stats);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to get stats'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ===== Helper Methods =====

  Future<Map<String, dynamic>> _getDashboardStats() async {
    try {
      // ✅ جلب البيانات بدون composite queries
      final packagesSnapshot = await _firestore
          .collection(FirebaseCollections.packages)
          .get();

      final withdrawalsSnapshot = await _firestore
          .collection(FirebaseCollections.withdrawals)
          .get();

      final vendorsSnapshot = await _firestore
          .collection(FirebaseCollections.vendors)
          .get();

      final requestsSnapshot = await _firestore
          .collection(FirebaseCollections.packageRequests)
          .get();

      // ✅ تصفية يدويا
      final pendingPackages = packagesSnapshot.docs
          .where((doc) => doc.data()['isApprovedByOwner'] != true)
          .length;

      final pendingWithdrawals = withdrawalsSnapshot.docs
          .where((doc) => doc.data()['status'] == 'pending')
          .length;

      final activeVendors = vendorsSnapshot.docs
          .where((doc) => doc.data()['status'] == 'active')
          .length;

      final acceptedRequests = requestsSnapshot.docs
          .where((doc) => doc.data()['status'] == 'accepted')
          .length;

      return {
        'totalEvents': 0, // سيتم جلبه من event owners إذا اللزم
        'activeVendors': activeVendors,
        'eventOwners': 0, // سيتم جلبه من users إذا اللزم
        'transactions': acceptedRequests,
        'pendingPackages': pendingPackages,
        'pendingWithdrawals': pendingWithdrawals,
      };
    } catch (e) {
      return {
        'totalEvents': 0,
        'activeVendors': 0,
        'eventOwners': 0,
        'transactions': 0,
        'pendingPackages': 0,
        'pendingWithdrawals': 0,
      };
    }
  }
}
