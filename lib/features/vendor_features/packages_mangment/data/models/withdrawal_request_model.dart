// lib/features/vendor_features/earnings/data/models/withdrawal_request_model.dart

import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum WithdrawalStatus {
  pending,
  approved,
  rejected,
  completed;

  static WithdrawalStatus fromString(String value) {
    return WithdrawalStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => WithdrawalStatus.pending,
    );
  }
}

class WithdrawalRequestModel extends Equatable {
  final String id;
  final String vendorId;
  final double amount;
  final String currency;
  final String walletNumber;
  final String walletType; // vodafone_cash, bank_account, etisalat, orange, we
  final WithdrawalStatus status;
  final DateTime requestedAt;
  final DateTime? approvedAt;
  final DateTime? rejectedAt;
  final DateTime? completedAt;
  final String? rejectionReason;
  final String? bankName; // For bank transfers
  final String? bankAccountHolder;
  final String? notes;
  

  const WithdrawalRequestModel({
    required this.id,
    required this.vendorId,
    required this.amount,
    required this.currency,
    required this.walletNumber,
    required this.walletType,
    required this.status,
    required this.requestedAt,
    this.approvedAt,
    this.rejectedAt,
    this.completedAt,
    this.rejectionReason,
    this.bankName,
    this.bankAccountHolder,
    this.notes,
   
  });

  factory WithdrawalRequestModel.fromJson(Map<String, dynamic> json) {
    final status = WithdrawalStatus.fromString(json['status'] as String? ?? 'pending');

    return WithdrawalRequestModel(
      id: json['id'] as String? ?? '',
      vendorId: json['vendorId'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'EGP',
      walletNumber: json['walletNumber'] as String? ?? '',
      walletType: json['walletType'] as String? ?? '',
      status: status,
      requestedAt: json['requestedAt'] is Timestamp
          ? (json['requestedAt'] as Timestamp).toDate()
          : DateTime.tryParse(json['requestedAt'] as String? ?? '') ?? DateTime.now(),
      approvedAt: json['approvedAt'] != null
          ? json['approvedAt'] is Timestamp
              ? (json['approvedAt'] as Timestamp).toDate()
              : DateTime.tryParse(json['approvedAt'] as String)
          : null,
      rejectedAt: json['rejectedAt'] != null
          ? json['rejectedAt'] is Timestamp
              ? (json['rejectedAt'] as Timestamp).toDate()
              : DateTime.tryParse(json['rejectedAt'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? json['completedAt'] is Timestamp
              ? (json['completedAt'] as Timestamp).toDate()
              : DateTime.tryParse(json['completedAt'] as String)
          : null,
      rejectionReason: json['rejectionReason'] as String?,
      bankName: json['bankName'] as String?,
      bankAccountHolder: json['bankAccountHolder'] as String?,
      notes: json['notes'] as String?,
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendorId': vendorId,
      'amount': amount,
      'currency': currency,
      'walletNumber': walletNumber,
      'walletType': walletType,
      'status': status.name,
      'requestedAt': Timestamp.fromDate(requestedAt),
      'approvedAt': approvedAt != null ? Timestamp.fromDate(approvedAt!) : null,
      'rejectedAt': rejectedAt != null ? Timestamp.fromDate(rejectedAt!) : null,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'rejectionReason': rejectionReason,
      'bankName': bankName,
      'bankAccountHolder': bankAccountHolder,
      'notes': notes,
    };
  }

  WithdrawalRequestModel copyWith({
    String? id,
    String? vendorId,
    double? amount,
    String? currency,
    String? walletNumber,
    String? walletType,
    WithdrawalStatus? status,
    DateTime? requestedAt,
    DateTime? approvedAt,
    DateTime? rejectedAt,
    DateTime? completedAt,
    String? rejectionReason,
    String? bankName,
    String? bankAccountHolder,
    String? notes,
  }) {
    final newStatus = status ?? this.status;
    return WithdrawalRequestModel(
      id: id ?? this.id,
      vendorId: vendorId ?? this.vendorId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      walletNumber: walletNumber ?? this.walletNumber,
      walletType: walletType ?? this.walletType,
      status: newStatus,
      requestedAt: requestedAt ?? this.requestedAt,
      approvedAt: approvedAt ?? this.approvedAt,
      rejectedAt: rejectedAt ?? this.rejectedAt,
      completedAt: completedAt ?? this.completedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      bankName: bankName ?? this.bankName,
      bankAccountHolder: bankAccountHolder ?? this.bankAccountHolder,
      notes: notes ?? this.notes,
      
    );
  }

  @override
  List<Object?> get props => [
        id,
        vendorId,
        amount,
        currency,
        walletNumber,
        walletType,
        status,
        requestedAt,
        approvedAt,
        rejectedAt,
        completedAt,
        rejectionReason,
        bankName,
        bankAccountHolder,
        notes,
      ];
}
