// lib/features/app_owner/finances/ui/screens/financial_overview_screen.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';

class FinancialOverviewScreen extends StatefulWidget {
  const FinancialOverviewScreen({super.key});

  @override
  State<FinancialOverviewScreen> createState() =>
      _FinancialOverviewScreenState();
}

class _FinancialOverviewScreenState extends State<FinancialOverviewScreen> {
  String selectedPeriod = 'This Month';
  
  // Mock Data
  final double totalRevenue = 125000.0; // من Event Owners
  final double vendorPayouts = 100000.0; // 80% للـ Vendors
  final double appProfit = 25000.0; // 20% ربح التطبيق
  final double pendingPayments = 15000.0;
  
  final List<Map<String, dynamic>> recentTransactions = [
    {
      'id': 'txn_001',
      'type': 'revenue',
      'title': 'Event Payment - Annual Tech Conference',
      'eventOwner': 'Ahmed Hassan',
      'amount': 5000.0,
      'date': DateTime(2024, 10, 22),
      'status': 'completed',
      'vendorShare': 4000.0,
      'appShare': 1000.0,
    },
    {
      'id': 'txn_002',
      'type': 'payout',
      'title': 'Vendor Payout - Sara Mohamed',
      'vendorName': 'Sara Mohamed',
      'amount': 1200.0,
      'date': DateTime(2024, 10, 21),
      'status': 'completed',
    },
    {
      'id': 'txn_003',
      'type': 'revenue',
      'title': 'Event Payment - Wedding Ceremony',
      'eventOwner': 'Fatma Ibrahim',
      'amount': 8000.0,
      'date': DateTime(2024, 10, 20),
      'status': 'completed',
      'vendorShare': 6400.0,
      'appShare': 1600.0,
    },
    {
      'id': 'txn_004',
      'type': 'payout',
      'title': 'Vendor Payout - Mohamed Ali',
      'vendorName': 'Mohamed Ali',
      'amount': 800.0,
      'date': DateTime(2024, 10, 19),
      'status': 'completed',
    },
    {
      'id': 'txn_005',
      'type': 'revenue',
      'title': 'Event Payment - Corporate Event',
      'eventOwner': 'Khaled Ahmed',
      'amount': 3500.0,
      'date': DateTime(2024, 10, 18),
      'status': 'pending',
      'vendorShare': 2800.0,
      'appShare': 700.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Financial Overview',
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterOptions,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Selector
            _buildPeriodSelector(),
            
            const SizedBox(height: 20),
            
            // Main Financial Card
            _buildMainFinancialCard(),
            
            const SizedBox(height: 20),
            
            // Stats Grid
            _buildStatsGrid(),
            
            const SizedBox(height: 24),
            
            // Revenue Breakdown
            _buildRevenueBreakdown(),
            
            const SizedBox(height: 24),
            
            // Recent Transactions
            _buildRecentTransactions(),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final periods = ['Today', 'This Week', 'This Month', 'This Year', 'All Time'];
    
    return Container(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: periods.length,
        itemBuilder: (context, index) {
          final period = periods[index];
          final isSelected = selectedPeriod == period;
          
          return GestureDetector(
            onTap: () => setState(() => selectedPeriod = period),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryGold : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? AppColors.primaryGold : Colors.grey.shade300,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primaryGold.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  period,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainFinancialCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            AppColors.primaryDark.withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // App Profit (Main Focus)
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.trending_up,
                    color: AppColors.primaryGold,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'App Profit (20%)',
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '\$${appProfit.toStringAsFixed(2)}',
                        style: AppTextStyles.title.copyWith(
                          color: AppColors.primaryGold,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Financial Breakdown
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildFinancialRow(
                  icon: Icons.arrow_downward,
                  label: 'Total Revenue',
                  value: '\$${totalRevenue.toStringAsFixed(2)}',
                  color: AppColors.success,
                ),
                const SizedBox(height: 12),
                _buildFinancialRow(
                  icon: Icons.arrow_upward,
                  label: 'Vendor Payouts (80%)',
                  value: '\$${vendorPayouts.toStringAsFixed(2)}',
                  color: AppColors.error,
                ),
                const SizedBox(height: 12),
                _buildFinancialRow(
                  icon: Icons.pending,
                  label: 'Pending Payments',
                  value: '\$${pendingPayments.toStringAsFixed(2)}',
                  color: AppColors.warning,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.body.copyWith(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.body.copyWith(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.event,
                title: 'Total Events',
                value: '120',
                subtitle: '+15 this month',
                color: AppColors.primaryGold,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.store,
                title: 'Active Vendors',
                value: '45',
                subtitle: '+3 this month',
                color: AppColors.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.people,
                title: 'Event Owners',
                value: '85',
                subtitle: '+8 this month',
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.receipt_long,
                title: 'Transactions',
                value: '340',
                subtitle: '+45 this month',
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.title.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.body.copyWith(
              color: AppColors.success,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueBreakdown() {
    final percentageVendor = (vendorPayouts / totalRevenue * 100).toInt();
    final percentageApp = (appProfit / totalRevenue * 100).toInt();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revenue Breakdown',
            style: AppTextStyles.title.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Progress Bar
          Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Row(
                children: [
                  // Vendor Share
                  Expanded(
                    flex: percentageVendor,
                    child: Container(
                      color: AppColors.primaryDark,
                      alignment: Alignment.center,
                      child: Text(
                        '$percentageVendor%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  // App Share
                  Expanded(
                    flex: percentageApp,
                    child: Container(
                      color: AppColors.primaryGold,
                      alignment: Alignment.center,
                      child: Text(
                        '$percentageApp%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem(
                color: AppColors.primaryDark,
                label: 'Vendor Share (80%)',
                value: '\$${vendorPayouts.toStringAsFixed(2)}',
              ),
              _buildLegendItem(
                color: AppColors.primaryGold,
                label: 'App Profit (20%)',
                value: '\$${appProfit.toStringAsFixed(2)}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: AppTextStyles.title.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to all transactions
              },
              child: Text(
                'View All',
                style: TextStyle(
                  color: AppColors.primaryGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentTransactions.length,
          itemBuilder: (context, index) {
            return _buildTransactionCard(recentTransactions[index]);
          },
        ),
      ],
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final isRevenue = transaction['type'] == 'revenue';
    final isPending = transaction['status'] == 'pending';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPending
              ? AppColors.warning.withOpacity(0.3)
              : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isRevenue
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isRevenue ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isRevenue ? AppColors.success : AppColors.error,
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 12),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction['title'],
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isRevenue
                          ? 'From: ${transaction['eventOwner']}'
                          : 'To: ${transaction['vendorName']}',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 11,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${transaction['date'].day}/${transaction['date'].month}/${transaction['date'].year}',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isRevenue ? '+' : '-'}\$${transaction['amount'].toStringAsFixed(2)}',
                    style: AppTextStyles.body.copyWith(
                      color: isRevenue ? AppColors.success : AppColors.error,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isPending
                          ? AppColors.warning.withOpacity(0.1)
                          : AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isPending ? 'Pending' : 'Completed',
                      style: TextStyle(
                        color: isPending ? AppColors.warning : AppColors.success,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Revenue Breakdown (only for revenue transactions)
          if (isRevenue) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'Vendor Share',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${transaction['vendorShare'].toStringAsFixed(2)}',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.grey.shade300,
                  ),
                  Column(
                    children: [
                      Text(
                        'App Profit',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${transaction['appShare'].toStringAsFixed(2)}',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.primaryGold,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Text(
              'Filter Options',
              style: AppTextStyles.title.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 20),
            
            ListTile(
              leading: const Icon(Icons.arrow_downward, color: AppColors.success),
              title: const Text('Revenue Only'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Filter revenue
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.arrow_upward, color: AppColors.error),
              title: const Text('Payouts Only'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Filter payouts
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.pending, color: AppColors.warning),
              title: const Text('Pending Only'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Filter pending
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.date_range, color: AppColors.primaryGold),
              title: const Text('Custom Date Range'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Show date picker
              },
            ),
          ],
        ),
      ),
    );
  }
}
