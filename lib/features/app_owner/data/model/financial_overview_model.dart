// lib/features/app_owner/data/models/financial_overview_model.dart

class AppOwnerFinancialOverview {
  final double totalRevenue;
  final double vendorPayouts;
  final double appProfit;
  final double pendingPayments;
  final Map<String, dynamic> stats;
  final List<FinancialTransaction> recentTransactions;

  AppOwnerFinancialOverview({
    required this.totalRevenue,
    required this.vendorPayouts,
    required this.appProfit,
    required this.pendingPayments,
    required this.stats,
    required this.recentTransactions,
  });

  factory AppOwnerFinancialOverview.fromJson(Map<String, dynamic> json) {
    return AppOwnerFinancialOverview(
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      vendorPayouts: (json['vendorPayouts'] as num?)?.toDouble() ?? 0.0,
      appProfit: (json['appProfit'] as num?)?.toDouble() ?? 0.0,
      pendingPayments: (json['pendingPayments'] as num?)?.toDouble() ?? 0.0,
      stats: json['stats'] as Map<String, dynamic>? ?? {},
      recentTransactions: (json['recentTransactions'] as List<dynamic>?)
              ?.map((e) => FinancialTransaction.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class FinancialTransaction {
  final String id;
  final String type; // 'revenue' or 'payout'
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final String status; // 'completed' or 'pending'

  FinancialTransaction({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.status,
  });

  factory FinancialTransaction.fromJson(Map<String, dynamic> json) {
    return FinancialTransaction(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'revenue',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      date: json['date'] is DateTime
          ? json['date'] as DateTime
          : DateTime.parse(json['date'] as String? ?? ''),
      status: json['status'] as String? ?? 'completed',
    );
  }
}
