// lib/features/app_owner/finances/ui/screens/financial_overview_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/app_owner/cubit/app_owner_cubit.dart';
import 'package:plan_z/features/app_owner/cubit/app_owner_state.dart';
import 'package:plan_z/features/app_owner/data/model/financial_overview_model.dart';

class FinancialOverviewScreen extends StatefulWidget {
  const FinancialOverviewScreen({super.key});

  @override
  State<FinancialOverviewScreen> createState() =>
      _FinancialOverviewScreenState();
}

class _FinancialOverviewScreenState extends State<FinancialOverviewScreen> {
  String selectedPeriod = 'This Month';

  @override
  void initState() {
    super.initState();
    // ✅ Load financial overview on init
    Future.microtask(() {
      context.read<AppOwnerCubit>().loadFinancialOverview(
            period: selectedPeriod,
          );
    });
  }
// lib/features/app_owner/finances/ui/screens/financial_overview_screen.dart

Widget _buildRevenueBreakdown(AppOwnerFinancialOverview? overview) {
  final totalRevenue = overview?.totalRevenue ?? 1; // ✅ تغيرها من 0 لـ 1
  final vendorPayouts = overview?.vendorPayouts ?? 0;
  final appProfit = overview?.appProfit ?? 0;

  // ✅ تحقق من إذا totalRevenue أقل من أو تساوي 0
  if (totalRevenue <= 0) {
    return _buildEmptyRevenueBreakdown(); // رجع widget فارغ
  }

  // ✅ الحساب الآمن الآن
  final percentageVendor = 
    ((vendorPayouts / totalRevenue.abs()) * 100).toInt().clamp(0, 100);
  final percentageApp = 
    ((appProfit / totalRevenue.abs()) * 100).toInt().clamp(0, 100);

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

        // ✅ Progress Bar - آمن الآن
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
                  flex: percentageVendor > 0 ? percentageVendor : 1,
                  child: Container(
                    color: AppColors.primaryDark,
                    alignment: Alignment.center,
                    child: percentageVendor > 0
                        ? Text(
                            '$percentageVendor%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),

                // App Share
                Expanded(
                  flex: percentageApp > 0 ? percentageApp : 1,
                  child: Container(
                    color: AppColors.primaryGold,
                    alignment: Alignment.center,
                    child: percentageApp > 0
                        ? Text(
                            '$percentageApp%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ✅ Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildLegendItem(
              color: AppColors.primaryDark,
              label: 'Vendor Share (80%)',
              value: 'EGP ${vendorPayouts.toStringAsFixed(2)}',
            ),
            _buildLegendItem(
              color: AppColors.primaryGold,
              label: 'App Profit (20%)',
              value: 'EGP ${appProfit.toStringAsFixed(2)}',
            ),
          ],
        ),
      ],
    ),
  );
}

// ✅ Widget لما تكون البيانات فارغة
Widget _buildEmptyRevenueBreakdown() {
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
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.trending_up,
            size: 60,
            color: AppColors.primaryGold.withOpacity(0.3),
          ),
          const SizedBox(height: 12),
          Text(
            'No Revenue Data Yet',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ),
  );
}

// ✅ حل للـ Stats Grid أيضاً
Widget _buildStatsGrid(AppOwnerFinancialOverview? overview) {
  final stats = overview?.stats ?? {};
  
  // ✅ تحويل القيم بشكل آمن
  final totalEvents = (stats['totalEvents'] ?? 0) as int;
  final activeVendors = (stats['activeVendors'] ?? 0) as int;
  final eventOwners = (stats['eventOwners'] ?? 0) as int;
  final transactions = (stats['transactions'] ?? 0) as int;

  return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.event,
              title: 'Total Events',
              value: totalEvents.toString(),
              subtitle: '+15 this month',
              color: AppColors.primaryGold,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.store,
              title: 'Active Vendors',
              value: activeVendors.toString(),
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
              value: eventOwners.toString(),
              subtitle: '+8 this month',
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.receipt_long,
              title: 'Transactions',
              value: transactions.toString(),
              subtitle: '+45 this month',
              color: Colors.purple,
            ),
          ),
        ],
      ),
    ],
  );
}

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
      body: BlocBuilder<AppOwnerCubit, AppOwnerState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryGold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading financial data...',
                    style: AppTextStyles.body,
                  ),
                ],
              ),
            );
          }

          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    size: 80,
                    color: AppColors.error.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage!,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AppOwnerCubit>().loadFinancialOverview(
                            period: selectedPeriod,
                          );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final overview = state.financialOverview;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Period Selector
                _buildPeriodSelector(),
                const SizedBox(height: 20),

                // ✅ Main Financial Card
                _buildMainFinancialCard(overview),
                const SizedBox(height: 20),

                // ✅ Stats Grid
                _buildStatsGrid(overview),
                const SizedBox(height: 24),

                // ✅ Revenue Breakdown
                _buildRevenueBreakdown(overview),
                const SizedBox(height: 24),

                // ✅ Recent Transactions
                _buildRecentTransactions(overview),
              ],
            ),
          );
        },
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
            onTap: () {
              setState(() => selectedPeriod = period);
              // ✅ Load data for selected period
              context.read<AppOwnerCubit>().loadFinancialOverview(
                    period: period,
                  );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryGold : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryGold
                      : Colors.grey.shade300,
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

  Widget _buildMainFinancialCard(AppOwnerFinancialOverview? overview) {
    final totalRevenue = overview?.totalRevenue ?? 0.0;
    final vendorPayouts = overview?.vendorPayouts ?? 0.0;
    final appProfit = overview?.appProfit ?? 0.0;
    final pendingPayments = overview?.pendingPayments ?? 0.0;

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
          // ✅ App Profit (Main Focus)
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
                    'EGP ${appProfit.toStringAsFixed(2)}',
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
          const SizedBox(height: 24),

          // ✅ Financial Breakdown
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
                  value: 'EGP ${totalRevenue.toStringAsFixed(2)}',
                  color: AppColors.success,
                ),
                const SizedBox(height: 12),
                _buildFinancialRow(
                  icon: Icons.arrow_upward,
                  label: 'Vendor Payouts (80%)',
                  value: 'EGP ${vendorPayouts.toStringAsFixed(2)}',
                  color: AppColors.error,
                ),
                const SizedBox(height: 12),
                _buildFinancialRow(
                  icon: Icons.pending,
                  label: 'Pending Payments',
                  value: 'EGP ${pendingPayments.toStringAsFixed(2)}',
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

  Widget _buildRecentTransactions(AppOwnerFinancialOverview? overview) {
    final transactions = overview?.recentTransactions ?? [];

    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No recent transactions',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

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
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            return _buildTransactionCard(transactions[index]);
          },
        ),
      ],
    );
  }

  Widget _buildTransactionCard(FinancialTransaction transaction) {
    final isRevenue = transaction.type == 'revenue';
    final isPending = transaction.status == 'pending';

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
                  isRevenue
                      ? Icons.arrow_downward
                      : Icons.arrow_upward,
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
                      transaction.title,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaction.description,
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
                          _formatDate(transaction.date),
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
                    '${isRevenue ? '+' : '-'}EGP ${transaction.amount.toStringAsFixed(2)}',
                    style: AppTextStyles.body.copyWith(
                      color:
                          isRevenue ? AppColors.success : AppColors.error,
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
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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
