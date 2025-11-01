// lib/features/vendor/data/repositories/vendor_repo_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:plan_z/core/constants/constants.dart';
import 'package:plan_z/core/error/failures.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_model.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_request_model.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/withdrawal_request_model.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/repos/i_vendor_repository.dart';
import 'package:uuid/uuid.dart';

class VendorRepositoryImpl implements VendorRepository {
  final FirebaseFirestore _firestore;
  final Uuid _uuid;

  VendorRepositoryImpl({
    FirebaseFirestore? firestore,
    Uuid? uuid,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _uuid = uuid ?? const Uuid();

  // ===== Package Management =====

  @override
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
  }) async {
    try {
      final packageId = _uuid.v4();
      final package = PackageModel(
        packageId: packageId,
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
        status: PackageStatus.pending,
        isActive: false,
        isApprovedByOwner: false,
      );

      await _firestore
          .collection(FirebaseCollections.packages)
          .doc(packageId)
          .set(package.toJson());

      return Right(package);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to create package'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final docRef =
          _firestore.collection(FirebaseCollections.packages).doc(packageId);

      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        return Left(ServerFailure('Package not found'));
      }

      final Map<String, dynamic> updates = {
        'updatedAt': DateTime.now().toIso8601String(),
      };

      if (packageName != null) updates['packageName'] = packageName;
      if (packageNameAr != null) updates['packageNameAr'] = packageNameAr;
      if (description != null) updates['description'] = description;
      if (descriptionAr != null) updates['descriptionAr'] = descriptionAr;
      if (price != null) updates['price'] = price;
      if (features != null) updates['features'] = features;
      if (featuresAr != null) updates['featuresAr'] = featuresAr;
      if (keywords != null) updates['keywords'] = keywords;
      if (portfolioLinks != null) {
        updates['portfolioLinks'] =
            portfolioLinks.map((item) => item.toJson()).toList();
      }
      if (attributes != null) updates['attributes'] = attributes;
      if (isActive != null) updates['isActive'] = isActive;

      await docRef.update(updates);

      final updatedDoc = await docRef.get();
      final updatedPackage = PackageModel.fromJson(
        updatedDoc.data() as Map<String, dynamic>,
      );

      return Right(updatedPackage);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to update package'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePackage(String packageId) async {
    try {
      await _firestore
          .collection(FirebaseCollections.packages)
          .doc(packageId)
          .delete();
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to delete package'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> togglePackageStatus({
    required String packageId,
    required bool isActive,
  }) async {
    try {
      await _firestore
          .collection(FirebaseCollections.packages)
          .doc(packageId)
          .update({
        'isActive': isActive,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to toggle status'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ============================================
  // ✅ UPDATED: getVendorPackages (No Index)
  // ============================================
  @override
  Future<Either<Failure, List<PackageModel>>> getVendorPackages(
    String vendorId,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseCollections.packages)
          .where('vendorId', isEqualTo: vendorId)
          .get(); // ✅ Removed .orderBy('createdAt')

      // ✅ Sort manually in memory
      final packages = querySnapshot.docs
          .map((doc) => PackageModel.fromJson(doc.data()))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return Right(packages);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to get packages'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PackageModel>> getPackageById(
    String packageId,
  ) async {
    try {
      final docSnapshot = await _firestore
          .collection(FirebaseCollections.packages)
          .doc(packageId)
          .get();

      if (!docSnapshot.exists) {
        return Left(ServerFailure('Package not found'));
      }

      final package = PackageModel.fromJson(
        docSnapshot.data() as Map<String, dynamic>,
      );
      return Right(package);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to get package'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ============================================
  // ✅ UPDATED: getPackagesByService (No Index)
  // ============================================
  @override
  Future<Either<Failure, List<PackageModel>>> getPackagesByService({
    required String serviceId,
    bool? onlyActive,
  }) async {
    try {
      Query query = _firestore
          .collection(FirebaseCollections.packages)
          .where('serviceId', isEqualTo: serviceId);

      if (onlyActive == true) {
        query = query
            .where('isActive', isEqualTo: true)
            .where('isApprovedByOwner', isEqualTo: true);
      }

      final querySnapshot = await query.get(); // ✅ Removed .orderBy('createdAt')

      // ✅ Sort manually in memory
      final packages = querySnapshot.docs
          .map((doc) => PackageModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return Right(packages);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to get packages'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PackageModel>>> searchPackages({
    required String searchQuery,
    String? serviceId,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      Query query = _firestore
          .collection(FirebaseCollections.packages)
          .where('isActive', isEqualTo: true)
          .where('isApprovedByOwner', isEqualTo: true);

      if (serviceId != null) {
        query = query.where('serviceId', isEqualTo: serviceId);
      }

      final querySnapshot = await query.get();
      List<PackageModel> packages = querySnapshot.docs
          .map((doc) => PackageModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      // Filter by search query (keywords)
      if (searchQuery.isNotEmpty) {
        final lowerQuery = searchQuery.toLowerCase();
        packages = packages.where((pkg) {
          return pkg.keywords.any(
                (keyword) => keyword.toLowerCase().contains(lowerQuery),
              ) ||
              pkg.packageName.toLowerCase().contains(lowerQuery) ||
              pkg.description.toLowerCase().contains(lowerQuery);
        }).toList();
      }

      // Filter by price range
      if (minPrice != null) {
        packages = packages.where((pkg) => pkg.price >= minPrice).toList();
      }
      if (maxPrice != null) {
        packages = packages.where((pkg) => pkg.price <= maxPrice).toList();
      }

      return Right(packages);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to search packages'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ===== Package Requests Management =====

  // ============================================
  // ✅ UPDATED: getVendorRequests (No Index)
  // ============================================
  @override
  Future<Either<Failure, List<PackageRequestModel>>> getVendorRequests(
    String vendorId,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseCollections.packageRequests)
          .where('vendorId', isEqualTo: vendorId)
          .get(); // ✅ Removed .orderBy('requestedAt')

      // ✅ Sort manually in memory
      final requests = querySnapshot.docs
          .map((doc) => PackageRequestModel.fromJson(doc.data()))
          .toList()
        ..sort((a, b) => b.requestedAt.compareTo(a.requestedAt));

      return Right(requests);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to get requests'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ============================================
  // ✅ UPDATED: getPendingRequests (No Index)
  // ============================================
  @override
  Future<Either<Failure, List<PackageRequestModel>>> getPendingRequests(
    String vendorId,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseCollections.packageRequests)
          .where('vendorId', isEqualTo: vendorId)
          .where('status', isEqualTo: 'pending')
          .where('isExpired', isEqualTo: false)
          .get(); // ✅ Removed .orderBy('requestedAt')

      // ✅ Sort manually in memory
      final requests = querySnapshot.docs
          .map((doc) => PackageRequestModel.fromJson(doc.data()))
          .toList()
        ..sort((a, b) => b.requestedAt.compareTo(a.requestedAt));

      return Right(requests);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to get pending requests'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
// lib/features/vendor_features/packages_mangment/data/repos/vendor_repository_impl.dart
// ✅ اصلح جميع الـ Methods:

@override
Future<Either<Failure, double>> getVendorBalance(String vendorId) async {
  try {
    final docSnapshot = await _firestore
        .collection(FirebaseCollections.vendors)
        .doc(vendorId)
        .get();

    if (!docSnapshot.exists) {
      return const Right(0.0);
    }

    final data = docSnapshot.data() as Map<String, dynamic>;
    final balance = (data['availableBalance'] as num?)?.toDouble() ?? 0.0;

    return Right(balance);
  } on FirebaseException catch (e) {
    return Left(ServerFailure(e.message ?? 'Failed to get balance'));
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}

@override
Future<Either<Failure, WithdrawalRequestModel>> requestWithdrawal({
  required String vendorId,
  required double amount,
  required String walletNumber,
  required String walletType,
  String? bankName,
  String? bankAccountHolder,
  String? notes,
}) async {
  try {
    // ✅ Check available balance first
    final balanceResult = await getVendorBalance(vendorId);
    final availableBalance = balanceResult.fold(
      (failure) => 0.0,
      (balance) => balance,
    );

    // ✅ Validation
    if (walletNumber.isEmpty) {
      return Left(ServerFailure('Wallet number is required'));
    }

    if (amount <= 0) {
      return Left(ServerFailure('Amount must be greater than 0'));
    }

    if (amount > availableBalance) {
      return Left(ServerFailure('Insufficient balance. Available: EGP $availableBalance'));
    }

    final requestId = _uuid.v4();
    final now = DateTime.now();

    final withdrawalRequest = WithdrawalRequestModel(

      id: requestId,
      vendorId: vendorId,
      amount: amount,
      currency: 'EGP',
      walletNumber: walletNumber,
      walletType: walletType,
      status: WithdrawalStatus.pending,
      requestedAt: now,
      bankName: bankName,
      bankAccountHolder: bankAccountHolder,
      notes: notes,
    );

    // ✅ Save withdrawal request
    await _firestore
        .collection(FirebaseCollections.withdrawals)
        .doc(requestId)
        .set(withdrawalRequest.toJson());

    // ✅ Update vendor's pending withdrawal amount
    await _firestore
        .collection(FirebaseCollections.vendors)
        .doc(vendorId)
        .update({
      'pendingWithdrawal': FieldValue.increment(amount),
      'lastWithdrawalRequest': Timestamp.fromDate(now),
    });

    return Right(withdrawalRequest);
  } on FirebaseException catch (e) {
    return Left(ServerFailure(e.message ?? 'Failed to request withdrawal'));
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}

@override
Future<Either<Failure, List<Map<String, dynamic>>>> getTransactionHistory(
  String vendorId,
) async {
  try {
    final transactions = <Map<String, dynamic>>[];

    // ✅ Get package requests (earnings)
    final requestsSnapshot = await _firestore
        .collection(FirebaseCollections.packageRequests)
        .where('vendorId', isEqualTo: vendorId)
        .where('status', isEqualTo: RequestStatus.accepted.name)
        .get();

    for (var doc in requestsSnapshot.docs) {
      final request = PackageRequestModel.fromJson(doc.data());
      transactions.add({
        'id': request.packageId,
        'type': 'earning',
        'title': 'Booking - ${request.packageName ?? 'Package'}',
        'amount': request.packagePrice ?? 0.0,
        'date': request.acceptedAt ?? DateTime.now(),
        'status': 'Completed',
      });
    }

    // ✅ Get withdrawals
    final withdrawalsSnapshot = await _firestore
        .collection(FirebaseCollections.withdrawals)
        .where('vendorId', isEqualTo: vendorId)
        .get();

    for (var doc in withdrawalsSnapshot.docs) {
      final withdrawal = WithdrawalRequestModel.fromJson(doc.data());
      transactions.add({
        'id': withdrawal.id,
        'type': 'withdrawal',
        'title': 'Withdrawal to ${withdrawal.walletType}',
        'amount': -withdrawal.amount,
        'date': withdrawal.requestedAt,
        'status': withdrawal.status.name.toUpperCase(),
      });
    }

    // ✅ Sort by date (newest first)
    transactions.sort((a, b) {
      final dateA = a['date'] as DateTime;
      final dateB = b['date'] as DateTime;
      return dateB.compareTo(dateA);
    });

    return Right(transactions);
  } on FirebaseException catch (e) {
    return Left(ServerFailure(e.message ?? 'Failed to get transaction history'));
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}
  @override
  Future<Either<Failure, PackageRequestModel>> getRequestById(
    String requestId,
  ) async {
    try {
      final docSnapshot = await _firestore
          .collection(FirebaseCollections.packageRequests)
          .doc(requestId)
          .get();

      if (!docSnapshot.exists) {
        return Left(ServerFailure('Request not found'));
      }

      final request = PackageRequestModel.fromJson(
        docSnapshot.data() as Map<String, dynamic>,
      );
      return Right(request);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to get request'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PackageRequestModel>> acceptRequest({
    required String requestId,
    String? vendorResponse,
  }) async {
    try {
      final docRef = _firestore
          .collection(FirebaseCollections.packageRequests)
          .doc(requestId);

      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        return Left(ServerFailure('Request not found'));
      }

      final request = PackageRequestModel.fromJson(
        docSnapshot.data() as Map<String, dynamic>,
      );

      if (request.isExpired) {
        return Left(ServerFailure('Request has expired'));
      }

      if (request.status != RequestStatus.pending) {
        return Left(ServerFailure('Request already responded'));
      }

      final now = DateTime.now();
      await docRef.update({
        'status': RequestStatus.accepted.name,
        'isAccepted': true,
        'vendorResponse': vendorResponse,
        'respondedAt': Timestamp.fromDate(now),
        'acceptedAt': Timestamp.fromDate(now),
        'ownerNotifiedOfResponse': false,
        'updatedAt': Timestamp.fromDate(now),
      });

      final updatedRequest = request.copyWith(
        status: RequestStatus.accepted,
        isAccepted: true,
        vendorResponse: vendorResponse,
        respondedAt: now,
        acceptedAt: now,
        updatedAt: now,
      );

      return Right(updatedRequest);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to accept request'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PackageRequestModel>> rejectRequest({
    required String requestId,
    required String rejectionReason,
  }) async {
    try {
      final docRef = _firestore
          .collection(FirebaseCollections.packageRequests)
          .doc(requestId);

      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        return Left(ServerFailure('Request not found'));
      }

      final request = PackageRequestModel.fromJson(
        docSnapshot.data() as Map<String, dynamic>,
      );

      if (request.status != RequestStatus.pending) {
        return Left(ServerFailure('Request already responded'));
      }

      final now = DateTime.now();
      await docRef.update({
        'status': RequestStatus.rejected.name,
        'isAccepted': false,
        'rejectionReason': rejectionReason,
        'respondedAt': Timestamp.fromDate(now),
        'rejectedAt': Timestamp.fromDate(now),
        'ownerNotifiedOfResponse': false,
        'updatedAt': Timestamp.fromDate(now),
      });

      final updatedRequest = request.copyWith(
        status: RequestStatus.rejected,
        isAccepted: false,
        rejectionReason: rejectionReason,
        respondedAt: now,
        rejectedAt: now,
        updatedAt: now,
      );

      return Right(updatedRequest);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to reject request'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markExpiredRequests() async {
    try {
      final now = DateTime.now();
      final querySnapshot = await _firestore
          .collection(FirebaseCollections.packageRequests)
          .where('status', isEqualTo: 'pending')
          .where('isExpired', isEqualTo: false)
          .where('expiresAt', isLessThan: Timestamp.fromDate(now))
          .get();

      final batch = _firestore.batch();
      for (var doc in querySnapshot.docs) {
        batch.update(doc.reference, {
          'status': RequestStatus.expired.name,
          'isExpired': true,
          'updatedAt': Timestamp.fromDate(now),
        });
      }

      await batch.commit();
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to mark expired requests'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ===== Statistics =====

  @override
  Future<Either<Failure, Map<String, dynamic>>> getVendorStats(
    String vendorId,
  ) async {
    try {
      final packagesResult = await getVendorPackages(vendorId);
      if (packagesResult.isLeft()) {
        return Left(ServerFailure('Failed to get stats'));
      }

      final packages = packagesResult.getOrElse(() => []);

      final requestsSnapshot = await _firestore
          .collection(FirebaseCollections.packageRequests)
          .where('vendorId', isEqualTo: vendorId)
          .get();

      final requests = requestsSnapshot.docs
          .map((doc) => PackageRequestModel.fromJson(doc.data()))
          .toList();

      final stats = {
        'totalPackages': packages.length,
        'activePackages': packages.where((p) => p.isActive).length,
        'pendingApproval':
            packages.where((p) => p.status == PackageStatus.pending).length,
        'totalRequests': requests.length,
        'pendingRequests':
            requests.where((r) => r.status == RequestStatus.pending).length,
        'acceptedRequests':
            requests.where((r) => r.status == RequestStatus.accepted).length,
        'rejectedRequests':
            requests.where((r) => r.status == RequestStatus.rejected).length,
        'expiredRequests':
            requests.where((r) => r.status == RequestStatus.expired).length,
        'totalViews': packages.fold(0, (sum, pkg) => sum + pkg.viewCount),
        'totalBookings': packages.fold(0, (sum, pkg) => sum + pkg.bookingCount),
      };

      return Right(stats);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to get stats'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> incrementPackageViews(String packageId) async {
    try {
      await _firestore
          .collection(FirebaseCollections.packages)
          .doc(packageId)
          .update({
        'viewCount': FieldValue.increment(1),
        'updatedAt': DateTime.now().toIso8601String(),
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to increment views'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> incrementPackageBookings(String packageId) async {
    try {
      await _firestore
          .collection(FirebaseCollections.packages)
          .doc(packageId)
          .update({
        'bookingCount': FieldValue.increment(1),
        'updatedAt': DateTime.now().toIso8601String(),
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to increment bookings'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

@override
Future<Either<Failure, List<WithdrawalRequestModel>>> getWithdrawalRequests(
  String vendorId,
) async {
  try {
    final querySnapshot = await _firestore
        .collection(FirebaseCollections.withdrawals)
        .where('vendorId', isEqualTo: vendorId)
        .get();

    final requests = querySnapshot.docs
        .map((doc) => WithdrawalRequestModel.fromJson(doc.data()))
        .toList()
      ..sort((a, b) => b.requestedAt.compareTo(a.requestedAt));

    return Right(requests);
  } on FirebaseException catch (e) {
    return Left(ServerFailure(e.message ?? 'Failed to get withdrawals'));
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}

@override
Future<Either<Failure, List<WithdrawalRequestModel>>> getPendingWithdrawals(
  String vendorId,
) async {
  try {
    final querySnapshot = await _firestore
        .collection(FirebaseCollections.withdrawals)
        .where('vendorId', isEqualTo: vendorId)
        .where('status', isEqualTo: WithdrawalStatus.pending.name)
        .get();

    final requests = querySnapshot.docs
        .map((doc) => WithdrawalRequestModel.fromJson(doc.data()))
        .toList()
      ..sort((a, b) => b.requestedAt.compareTo(a.requestedAt));

    return Right(requests);
  } on FirebaseException catch (e) {
    return Left(ServerFailure(e.message ?? 'Failed to get pending withdrawals'));
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}

@override
Future<Either<Failure, WithdrawalRequestModel>> getWithdrawalById(
  String requestId,
) async {
  try {
    final docSnapshot = await _firestore
        .collection(FirebaseCollections.withdrawals)
        .doc(requestId)
        .get();

    if (!docSnapshot.exists) {
      return Left(ServerFailure('Withdrawal request not found'));
    }

    final request = WithdrawalRequestModel.fromJson(
      docSnapshot.data() as Map<String, dynamic>,
    );

    return Right(request);
  } on FirebaseException catch (e) {
    return Left(ServerFailure(e.message ?? 'Failed to get withdrawal'));
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}

}
