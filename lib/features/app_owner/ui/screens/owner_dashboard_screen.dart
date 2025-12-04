// lib/features/app_owner/dashboard/ui/screens/owner_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/app_owner/cubit/app_owner_cubit.dart';
import 'package:plan_z/features/app_owner/cubit/app_owner_state.dart';
import 'package:plan_z/features/app_owner/ui/screens/app_owner_notification_screen.dart';
import 'package:plan_z/features/app_owner/ui/screens/financial_overview_screen.dart';
import 'package:plan_z/features/app_owner/ui/screens/package_approval_screen.dart';
import 'package:plan_z/features/app_owner/ui/screens/withdrawal_requests_screen.dart';
import 'package:plan_z/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:plan_z/features/on_boarding/ui/on_boarding_view.dart';
import 'package:shimmer/shimmer.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // ✅ Load dashboard stats on init
    context.read<AppOwnerCubit>().loadDashboardStats();

    // ✅ Load owner profits (جلب كل الأرباح من collection)
    context.read<AppOwnerCubit>().getOwnerProfits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Owner Dashboard',
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AppOwnerNotificationScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      body: BlocConsumer<AppOwnerCubit, AppOwnerState>(
        listener: (context, state) {
          // ✅ Show error snackbar
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }

          // ✅ Show success snackbar
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Welcome Section
                _buildWelcomeSection(),
                const SizedBox(height: 24),

                // ✅ Financial Overview Card
                // _buildFinancialCard(context, state),
                // const SizedBox(height: 20),

                // ✅ Owner Profits Card
                _buildOwnerProfitsCard(state),
                const SizedBox(height: 24),

                // ✅ Quick Actions
                _buildQuickActions(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back, Admin! ',
          style: AppTextStyles.title.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Here's what's happening with your platform today",
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialCard(BuildContext context, AppOwnerState state) {
    final stats = state.dashboardStats ?? {};
    final totalRevenue = stats['totalRevenue'] as double? ?? 0.0;
    final appProfit = stats['appProfit'] as double? ?? 0.0;
    final vendorPayouts = stats['vendorPayouts'] as double? ?? 0.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FinancialOverviewScreen(),
          ),
        );
      },
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total App Profit',
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // ✅ Loading state
                    if (context.watch<AppOwnerCubit>().state.isLoading)
                      const SizedBox(
                        width: 100,
                        height: 36,
                        child: Shimmer(
                          gradient: LinearGradient(
                            colors: [Colors.grey, Colors.white30],
                          ),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.grey,
                            ),
                          ),
                        ),
                      )
                    else
                      Text(
                        'EGP ${appProfit.toStringAsFixed(2)}',
                        style: AppTextStyles.title.copyWith(
                          color: AppColors.primaryGold,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      '20% Commission',
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGold.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.trending_up,
                    color: AppColors.primaryGold,
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Revenue',
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'EGP ${totalRevenue.toStringAsFixed(2)}',
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Vendor Payouts',
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'EGP ${vendorPayouts.toStringAsFixed(2)}',
                        style: AppTextStyles.body.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'View Details',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primaryGold,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.primaryGold,
                  size: 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerProfitsCard(AppOwnerState state) {
    final profits = state.ownerProfits ?? {};
    final totalProfit = (profits['totalProfit'] as num?)?.toDouble() ?? 0.0;
    final totalTransactions = profits['totalTransactions'] as int? ?? 0;
    // ✅ Owner profit = 20% من الفلوس الكلية
    final ownerProfit = totalProfit * 0.20;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGold.withOpacity(0.15),
            AppColors.primaryGold.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryGold.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGold.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Platform Earnings',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (state.isLoading)
                    const SizedBox(
                      width: 120,
                      height: 36,
                      child: Shimmer(
                        gradient: LinearGradient(
                          colors: [Colors.grey, Colors.white30],
                        ),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.grey,
                          ),
                        ),
                      ),
                    )
                  else
                    Text(
                      'EGP ${ownerProfit.toStringAsFixed(2)}',
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.primaryGold,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    '20% من إجمالي الأرباح',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: AppColors.primaryGold,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Revenue',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'EGP ${totalProfit.toStringAsFixed(2)}',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primaryDark,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transactions',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      totalTransactions.toString(),
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primaryDark,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTextStyles.title.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                icon: Icons.approval,
                label: 'Package Approvals',
                color: AppColors.primaryGold,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PackageApprovalScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                context,
                icon: Icons.attach_money,
                label: 'Withdrawal Requests',
                color: AppColors.success,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WithdrawalRequestsScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTextStyles.body.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Logout Dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.logout, color: AppColors.error, size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(child: Text('Logout')),
          ],
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTextStyles.body.copyWith(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // ✅ Call signOut from AuthCubit
              context.read<AuthCubit>().signOut();
              // ✅ Navigate to OnBoardingScreen
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const OnBoardingScreen(),
                ),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
