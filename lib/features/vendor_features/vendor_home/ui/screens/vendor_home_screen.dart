// lib/features/vendor_features/vendor_home/ui/screens/vendor_home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/auth/data/models/user_manager.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/cubit/vendor_cubit.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/cubit/vendor_state.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_request_model.dart';
  import 'package:plan_z/features/vendor_features/packages_mangment/ui/screens/all_packages_screen.dart';
import 'package:plan_z/features/vendor_features/vendor_home/ui/screens/vendor_earnings_screen.dart';
import 'package:intl/intl.dart';

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  final UserManager _userManager = UserManager();
  int selectedTab = 0; // 0 = Requests, 1 = Notifications

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Load all required data
  void _loadData() {
    final vendorId = _userManager.userId;
    if (vendorId != null) {
      // ✅ Load vendor requests
      context.read<VendorCubit>().getVendorRequests(vendorId);
      
      // ✅ Load vendor stats
      context.read<VendorCubit>().getVendorStats(vendorId);
      
      // ✅ Load vendor packages (for count)
      context.read<VendorCubit>().getVendorPackages(vendorId);
    }
  }

  /// Refresh data
  Future<void> _refreshData() async {
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Vendor Dashboard',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor:Colors.white,
              child: Text(
                _userManager.getUserInitials(),
                style: AppTextStyles.body.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppColors.primaryGold,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Message
              _buildWelcomeMessage(),
              const SizedBox(height: 20),

              // Earnings Summary Card
              _buildEarningsSummaryCard(),
              const SizedBox(height: 20),

              // Quick Stats
              _buildQuickStats(),
              const SizedBox(height: 20),

              // Quick Actions
              _buildQuickActions(),
              const SizedBox(height: 24),

              // Tabs
              _buildTabs(),
              const SizedBox(height: 16),

              // Requests List
              if (selectedTab == 0) _buildRequestsList(),

              // Notifications List
              if (selectedTab == 1) _buildNotificationsList(),
            ],
          ),
        ),
      ),
    );
  }

  /// Welcome Message
  Widget _buildWelcomeMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back,',
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _userManager.userName ?? 'Vendor',
          style: AppTextStyles.title.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
      ],
    );
  }

  /// Earnings Summary Card
  Widget _buildEarningsSummaryCard() {
    return BlocBuilder<VendorCubit, VendorState>(
      builder: (context, state) {
        // ✅ Get stats from Cubit
        double totalEarnings = 0.0;
        double availableBalance = 0.0;

        if (state is GetVendorStatsSuccess) {
          totalEarnings = (state.stats['totalEarnings'] ?? 0.0).toDouble();
          availableBalance = (state.stats['availableBalance'] ?? 0.0).toDouble();
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VendorEarningsScreen(),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryDark,
                  AppColors.primaryDark.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
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
                          'Total Earnings',
                          style: AppTextStyles.body.copyWith(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${totalEarnings.toStringAsFixed(2)}',
                          style: AppTextStyles.title.copyWith(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet,
                        color: AppColors.primaryGold,
                        size: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Available Balance',
                            style: AppTextStyles.body.copyWith(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${availableBalance.toStringAsFixed(2)}',
                            style: AppTextStyles.body.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'View Details',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.primaryGold,
                              fontSize: 13,
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
              ],
            ),
          ),
        );
      },
    );
  }

  /// Quick Stats
  Widget _buildQuickStats() {
    return BlocBuilder<VendorCubit, VendorState>(
      builder: (context, state) {
        int activeJobs = 0;
        int pendingRequests = 0;
        int totalPackages = 0;

        // ✅ Get stats from different states
        if (state is GetVendorStatsSuccess) {
          activeJobs = state.stats['activeJobs'] ?? 0;
          pendingRequests = state.stats['pendingRequests'] ?? 0;
        }

        if (state is GetVendorPackagesSuccess) {
          totalPackages = state.packages.length;
        }

        if (state is GetVendorRequestsSuccess) {
          pendingRequests = state.requests
              .where((r) => r.status == RequestStatus.pending)
              .length;
          activeJobs = state.requests
              .where((r) => r.status == RequestStatus.accepted)
              .length;
        }

        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.event_available,
                title: 'Active Jobs',
                value: activeJobs.toString(),
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.pending_actions,
                title: 'Pending',
                value: pendingRequests.toString(),
                color: AppColors.warning,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.inventory_2,
                title: 'Packages',
                value: totalPackages.toString(),
                color: AppColors.primaryGold,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.title.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Quick Actions
  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.inventory_2_outlined,
            label: 'Manage Packages',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllPackagesScreen(
                  ),
                ),
              );
            },
          ),
        ),
        // const SizedBox(width: 12),
        // Expanded(
        //   child: _buildActionButton(
        //     icon: Icons.calendar_today_outlined,
        //     label: 'Availability',
        //     onTap: () {
        //       // TODO: Navigate to availability screen
        //     },
        //   ),
        // ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.primaryGold,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primaryGold, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Tabs
  Widget _buildTabs() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => selectedTab = 0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: selectedTab == 0 ? AppColors.primaryGold : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selectedTab == 0
                      ? AppColors.primaryGold
                      : Colors.grey.shade300,
                ),
              ),
              child: Center(
                child: Text(
                  'Requests',
                  style: TextStyle(
                    color: selectedTab == 0 ? Colors.white : AppColors.primaryDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => selectedTab = 1),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: selectedTab == 1 ? AppColors.primaryGold : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selectedTab == 1
                      ? AppColors.primaryGold
                      : Colors.grey.shade300,
                ),
              ),
              child: Center(
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    color: selectedTab == 1 ? Colors.white : AppColors.primaryDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Requests List (from Firestore)
  Widget _buildRequestsList() {
    return BlocBuilder<VendorCubit, VendorState>(
      builder: (context, state) {
        // ✅ Loading State
        if (state is GetVendorRequestsLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(
                color: AppColors.primaryGold,
              ),
            ),
          );
        }

        // ✅ Error State
        if (state is GetVendorRequestsError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: AppColors.error.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading requests',
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGold,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // ✅ Success State
        if (state is GetVendorRequestsSuccess) {
          final requests = state.requests;

          if (requests.isEmpty) {
            return _buildEmptyRequestsState();
          }

          return Column(
            children: requests.map((request) => _buildRequestCard(request)).toList(),
          );
        }

        // ✅ Initial/Empty State
        return _buildEmptyRequestsState();
      },
    );
  }

  /// Empty Requests State
  Widget _buildEmptyRequestsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No Requests Yet',
              style: AppTextStyles.title.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Package requests will appear here',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Request Card (from Firestore data)
  Widget _buildRequestCard(PackageRequestModel request) {
    // ✅ Status configuration
    Color statusColor;
    switch (request.status) {
      case RequestStatus.pending:
        statusColor = AppColors.warning;
        break;
      case RequestStatus.accepted:
        statusColor = AppColors.success;
        break;
      case RequestStatus.rejected:
        statusColor = AppColors.error;
        break;
      case RequestStatus.expired:
        statusColor = AppColors.textSecondary;
        break;
      default:
        statusColor = AppColors.textSecondary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // ✅ Event Icon (placeholder since no image in model)
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.event,
                    color: AppColors.primaryGold,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.packageName,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Event: ${request.eventId}', // ✅ Can be replaced with event name
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    request.status.name.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  DateFormat('dd/MM/yyyy').format(request.createdAt),
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.attach_money, size: 14, color: AppColors.textSecondary),
                
              ],
            ),
            const SizedBox(height: 12),
            _buildRequestActions(request),
          ],
        ),
      ),
    );
  }

  /// Request Actions (Accept/Reject/Message)
  Widget _buildRequestActions(PackageRequestModel request) {
    if (request.status == RequestStatus.rejected ||
        request.status == RequestStatus.expired) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                // TODO: View details
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryDark,
                padding: const EdgeInsets.symmetric(vertical: 10),
                side: const BorderSide(color: AppColors.primaryDark),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('View Details'),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        if (request.status == RequestStatus.pending)
          Expanded(
            child: ElevatedButton(
              onPressed: () => _acceptRequest(request.requestId),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Accept'),
            ),
          ),
        if (request.status == RequestStatus.pending) const SizedBox(width: 8),
        if (request.status == RequestStatus.pending)
          Expanded(
            child: ElevatedButton(
              onPressed: () => _rejectRequest(request.requestId),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Reject'),
            ),
          ),
        if (request.status == RequestStatus.pending) const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // TODO: Message
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryDark,
              padding: const EdgeInsets.symmetric(vertical: 10),
              side: const BorderSide(color: AppColors.primaryDark),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Message'),
          ),
        ),
      ],
    );
  }

  /// Accept Request
  void _acceptRequest(String requestId) {
    context.read<VendorCubit>().acceptRequest(
          requestId: requestId,
          vendorResponse: 'Request accepted',
        );
  }

  /// Reject Request
  void _rejectRequest(String requestId) {
    // TODO: Show dialog to get rejection reason
    context.read<VendorCubit>().rejectRequest(
          requestId: requestId,
          rejectionReason: 'Not available for this date',
        );
  }

  /// Notifications List
  Widget _buildNotificationsList() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 80,
              color: AppColors.textSecondary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No Notifications',
              style: AppTextStyles.title.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
