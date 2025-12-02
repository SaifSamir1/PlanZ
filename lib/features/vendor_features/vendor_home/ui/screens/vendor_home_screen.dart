// lib/features/vendor_features/vendor_home/ui/screens/vendor_home_screen.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/auth/data/models/user_manager.dart';
import 'package:plan_z/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:plan_z/features/auth/logic/auth_cubit/auth_state.dart';
import 'package:plan_z/features/on_boarding/ui/on_boarding_view.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/cubit/vendor_cubit.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/cubit/vendor_state.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_request_model.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/ui/screens/all_packages_screen.dart';
import 'package:plan_z/features/vendor_features/vendor_home/ui/screens/vendor_earnings_screen.dart';
import 'package:plan_z/features/vendor_features/vendor_home/ui/screens/request_details_screen.dart';
import 'package:plan_z/features/vendor_features/vendor_settings/ui/screens/vendor_settings_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:plan_z/features/event_owners/chat_bot/cubits/chat_cubit.dart';
import 'package:plan_z/features/event_owners/chat_bot/ui/chat_bot_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  final UserManager _userManager = UserManager();
  int selectedTab = 0; // 0 = Requests, 1 = Notifications

  // ✅ Cache the balance locally
  double _cachedBalance = 0.0;

  // ✅ Cache stats locally
  int _cachedActiveJobs = 0;
  int _cachedPendingRequests = 0;
  int _cachedTotalPackages = 0;

  @override
  void initState() {
    super.initState();
    // Initialize date formatting for Arabic locale
    initializeDateFormatting('ar_SA', null);
    _loadData();
  }

  /// Load all required data
  void _loadData() {
    final vendorId = _userManager.userId;
    debugPrint('📱 [VendorHomeScreen._loadData] Starting...');
    debugPrint('   vendorId: $vendorId');
    debugPrint('   userName: ${_userManager.userName}');
    debugPrint('   userEmail: ${_userManager.userEmail}');

    if (vendorId != null) {
      // ✅ Load vendor balance (المهم!)
      debugPrint('💰 [VendorHomeScreen._loadData] Loading balance...');
      context.read<VendorCubit>().getVendorBalance(vendorId);

      // ✅ Load vendor requests
      debugPrint('🔄 [VendorHomeScreen._loadData] Loading requests...');
      context.read<VendorCubit>().getVendorRequests(vendorId);

      // ✅ Load vendor stats
      debugPrint('📊 [VendorHomeScreen._loadData] Loading stats...');
      context.read<VendorCubit>().getVendorStats(vendorId);

      // ✅ Load vendor packages (for count)
      debugPrint('📦 [VendorHomeScreen._loadData] Loading packages...');
      context.read<VendorCubit>().getVendorPackages(vendorId);
    } else {
      debugPrint('❌ [VendorHomeScreen._loadData] vendorId is null!');
    }
  }

  /// Refresh data
  Future<void> _refreshData() async {
    _loadData();
  }

  /// ============================================
  /// Chat Floating Action Button
  /// ============================================
  Widget _buildChatFAB() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => ChatCubit(),
              child: const ChatScreen(),
            ),
          ),
        );
      },
      backgroundColor: AppColors.primaryGold,
      foregroundColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tooltip: 'Chat with Assistant',
      child: const Icon(Icons.chat_bubble_rounded, size: 26),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'vendor.home.title'.tr(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VendorSettingsScreen(),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Text(
                  _userManager.getUserInitials(),
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildChatFAB(),
      body: BlocListener<AuthCubit, AuthState>(
        listenWhen: (previous, current) => current is AuthSignOutSuccess,
        listener: (context, state) {
          if (state is AuthSignOutSuccess) {
            debugPrint(
              '✅ [BlocListener] Logout successful, navigating to OnBoarding',
            );
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
              (route) => false,
            );
          }
        },
        child: BlocListener<VendorCubit, VendorState>(
          listenWhen: (previous, current) {
            // ✅ Listen to balance, requests, and packages updates
            return current is GetVendorBalanceSuccess ||
                current is GetVendorRequestsSuccess ||
                current is GetVendorPackagesSuccess;
          },
          listener: (context, state) {
            // ✅ Cache balance when it arrives
            if (state is GetVendorBalanceSuccess) {
              setState(() {
                _cachedBalance = state.balance;
              });
              debugPrint('💰 [BlocListener] Cached balance: $_cachedBalance');
            }

            // ✅ Cache requests stats when they arrive
            if (state is GetVendorRequestsSuccess) {
              setState(() {
                _cachedPendingRequests = state.requests
                    .where((r) => r.status == RequestStatus.pending)
                    .length;
                _cachedActiveJobs = state.requests
                    .where((r) => r.status == RequestStatus.accepted)
                    .length;
              });
              debugPrint(
                '📊 [BlocListener] Cached stats - Active: $_cachedActiveJobs, Pending: $_cachedPendingRequests',
              );
            }

            // ✅ Cache packages count when they arrive
            if (state is GetVendorPackagesSuccess) {
              setState(() {
                _cachedTotalPackages = state.packages.length;
              });
              debugPrint(
                '📦 [BlocListener] Cached packages: $_cachedTotalPackages',
              );
            }
          },
          child: RefreshIndicator(
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

                  // Requests List (separate builder)
                  if (selectedTab == 0) _buildRequestsListWidget(),

                  // Notifications List
                  if (selectedTab == 1) _buildNotificationsList(),
                ],
              ),
            ),
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
          'vendor.home.welcome'.tr(),
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
      buildWhen: (previous, current) {
        // ✅ Only rebuild for requests-related states
        final isRequestsState =
            current is GetVendorRequestsLoading ||
            current is GetVendorRequestsSuccess ||
            current is GetVendorRequestsError;

        debugPrint(
          '🔄 [_buildEarningsSummaryCard.buildWhen] Current: ${current.runtimeType}, Rebuild: $isRequestsState',
        );
        return isRequestsState;
      },
      builder: (context, state) {
        // ✅ Show loading state
        if (state is GetVendorRequestsLoading ||
            state is GetVendorBalanceLoading) {
          return _buildLoadingCard();
        }

        // ✅ Get earnings from accepted requests
        double totalEarnings = 0.0;
        int acceptedCount = 0;

        // ✅ Calculate from accepted requests
        if (state is GetVendorRequestsSuccess) {
          final acceptedRequests = state.requests
              .where((r) => r.status == RequestStatus.accepted)
              .toList();

          acceptedCount = acceptedRequests.length;

          totalEarnings = acceptedRequests.fold<double>(0, (sum, request) {
            final price = request.packagePrice ?? 0.0;
            debugPrint('💰 Request: ${request.packageName} - Price: $price');
            return sum + price;
          });

          debugPrint('💰 [EarningsSummary] Accepted requests: $acceptedCount');
          debugPrint('   Total Earnings (calculated): $totalEarnings');
        }

        // ✅ Use cached balance (always available!)
        debugPrint(
          '💰 [EarningsSummary] Available Balance (cached): $_cachedBalance',
        );

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
                          'vendor.home.total_earnings'.tr(),
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
                            'vendor.home.available_balance'.tr(),
                            style: AppTextStyles.body.copyWith(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'EGP ${_cachedBalance.toStringAsFixed(2)}',
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
                            'vendor.home.view_all'.tr(),
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
      buildWhen: (previous, current) {
        // ✅ Only rebuild for requests and packages states
        final isRelevantState =
            current is GetVendorRequestsLoading ||
            current is GetVendorRequestsSuccess ||
            current is GetVendorRequestsError ||
            current is GetVendorPackagesLoading ||
            current is GetVendorPackagesSuccess ||
            current is GetVendorPackagesError;

        debugPrint(
          '🔄 [_buildQuickStats.buildWhen] Current: ${current.runtimeType}, Rebuild: $isRelevantState',
        );
        return isRelevantState;
      },
      builder: (context, state) {
        // ✅ Show loading state
        if (state is GetVendorRequestsLoading ||
            state is GetVendorPackagesLoading) {
          return Row(
            children: [
              Expanded(child: _buildLoadingStatCard()),
              const SizedBox(width: 12),
              Expanded(child: _buildLoadingStatCard()),
              const SizedBox(width: 12),
              Expanded(child: _buildLoadingStatCard()),
            ],
          );
        }

        // ✅ Use cached values (always available!)
        debugPrint(
          '📊 [QuickStats] Using cached - Active: $_cachedActiveJobs, Pending: $_cachedPendingRequests, Packages: $_cachedTotalPackages',
        );

        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.event_available,
                title: 'vendor.home.active_jobs'.tr(),
                value: _cachedActiveJobs.toString(),
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.pending_actions,
                title: 'vendor.requests.pending'.tr(),
                value: _cachedPendingRequests.toString(),
                color: AppColors.warning,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.inventory_2,
                title: 'vendor.home.my_packages'.tr(),
                value: _cachedTotalPackages.toString(),
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
            label: 'vendor.home.my_packages'.tr(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllPackagesScreen()),
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
            border: Border.all(color: AppColors.primaryGold, width: 1.5),
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
                  'vendor.home.requests'.tr(),
                  style: TextStyle(
                    color: selectedTab == 0
                        ? Colors.white
                        : AppColors.primaryDark,
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
                  'vendor.home.notifications'.tr(),
                  style: TextStyle(
                    color: selectedTab == 1
                        ? Colors.white
                        : AppColors.primaryDark,
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
  Widget _buildRequestsListWidget() {
    return BlocBuilder<VendorCubit, VendorState>(
      buildWhen: (previous, current) {
        // ✅ Only rebuild when requests-related states change
        final isRequestsState =
            current is GetVendorRequestsLoading ||
            current is GetVendorRequestsSuccess ||
            current is GetVendorRequestsError;

        debugPrint(
          '🔄 [_buildRequestsListWidget.buildWhen] Current: ${current.runtimeType}, Rebuild: $isRequestsState',
        );
        return isRequestsState;
      },
      builder: (context, state) {
        debugPrint('📋 [_buildRequestsList] State: ${state.runtimeType}');

        // ✅ Loading State
        if (state is GetVendorRequestsLoading) {
          debugPrint('⏳ [_buildRequestsList] Loading...');
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(color: AppColors.primaryGold),
            ),
          );
        }

        // ✅ Error State
        if (state is GetVendorRequestsError) {
          debugPrint('❌ [_buildRequestsList] Error: ${state.message}');
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
                    'vendor.packages.error_loading'.tr(),
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
                    child: Text('vendor.packages.retry'.tr()),
                  ),
                ],
              ),
            ),
          );
        }

        // ✅ Success State
        if (state is GetVendorRequestsSuccess) {
          final requests = state.requests;
          debugPrint(
            '✅ [_buildRequestsList] Success: ${requests.length} requests',
          );

          for (var i = 0; i < requests.length; i++) {
            debugPrint(
              '   [$i] ${requests[i].packageName} - ${requests[i].status.name}',
            );
          }

          if (requests.isEmpty) {
            debugPrint('📭 [_buildRequestsList] No requests');
            return _buildEmptyRequestsState();
          }

          return Column(
            children: requests
                .map((request) => _buildRequestCard(request))
                .toList(),
          );
        }

        // ✅ Initial/Empty State
        debugPrint('❓ [_buildRequestsList] Initial state');
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
              'vendor.home.no_requests'.tr(),
              style: AppTextStyles.title.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'vendor.packages.no_packages'.tr(),
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
    String statusText;

    switch (request.status) {
      case RequestStatus.pending:
        statusColor = AppColors.warning;
        statusText = 'vendor.requests.pending'.tr();
        break;
      case RequestStatus.accepted:
        statusColor = AppColors.success;
        statusText = 'vendor.requests.accepted'.tr();
        break;
      case RequestStatus.rejected:
        statusColor = AppColors.error;
        statusText = 'vendor.requests.rejected'.tr();
        break;
      case RequestStatus.expired:
        statusColor = AppColors.textSecondary;
        statusText = 'vendor.requests.expired'.tr();
        break;
      case RequestStatus.cancelled:
        statusColor = AppColors.error;
        statusText = 'vendor.requests.cancelled'.tr();
        break;
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
                        '${'vendor.requests.event_name'.tr()}: ${request.eventId}', // ✅ Can be replaced with event name
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusText,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(request.createdAt),
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                // ✅ Show package price
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.attach_money,
                        size: 14,
                        color: AppColors.primaryGold,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'EGP ${(request.packagePrice ?? 0.0).toStringAsFixed(2)}',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.primaryGold,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildRequestActions(request),
          ],
        ),
      ),
    );
  }

  /// Request Actions (Details Button Only)
  Widget _buildRequestActions(PackageRequestModel request) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showRequestDetails(request),
        icon: const Icon(Icons.info_outline, size: 18),
        label: Text('vendor.requests.details'.tr()),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGold,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  /// Show Request Details
  void _showRequestDetails(PackageRequestModel request) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequestDetailsScreen(request: request),
      ),
    );
  }

  /// Format date safely
  String _formatDate(DateTime date) {
    try {
      // Initialize locale if not already done
      initializeDateFormatting('ar_SA', null);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      // Fallback to simple format
      debugPrint('⚠️ [_formatDate] Error formatting date: $e');
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Helper to format time ago
  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays >= 1) {
      return 'vendor.notifications.days_ago'.tr(
        args: [difference.inDays.toString()],
      );
    } else if (difference.inHours >= 1) {
      return 'vendor.notifications.hours_ago'.tr(
        args: [difference.inHours.toString()],
      );
    } else if (difference.inMinutes >= 1) {
      return 'vendor.notifications.minutes_ago'.tr(
        args: [difference.inMinutes.toString()],
      );
    } else {
      return 'vendor.notifications.just_now'.tr();
    }
  }

  /// Notifications List
  Widget _buildNotificationsList() {
    final vendorId = _userManager.userId;
    if (vendorId == null) {
      return Center(child: Text('vendor.notifications.please_login'.tr()));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('notifications')
          .where('receiverId', isEqualTo: vendorId)
          .where('receiverRole', isEqualTo: 'vendor')
          // .orderBy('createdAt', descending: true) // Removed to avoid index error
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
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
                    'vendor.notifications.no_notifications'.tr(),
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // ✅ Client-side sorting workaround
        final docs = snapshot.data!.docs;
        docs.sort((a, b) {
          final aTime = (a['createdAt'] as Timestamp).toDate();
          final bTime = (b['createdAt'] as Timestamp).toDate();
          return bTime.compareTo(aTime); // Descending
        });

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final notificationId = docs[index].id;
            final title = data['title'] ?? 'No Title';
            final body = data['body'] ?? 'No Body';
            final isRead = data['isRead'] ?? false;
            final createdAt = (data['createdAt'] as Timestamp).toDate();
            final type = data['type'] ?? 'general';

            return Dismissible(
              key: Key(notificationId),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                FirebaseFirestore.instance
                    .collection('notifications')
                    .doc(notificationId)
                    .delete();
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isRead
                      ? Colors.white
                      : AppColors.primaryGold.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isRead
                        ? Colors.grey.withOpacity(0.2)
                        : AppColors.primaryGold.withOpacity(0.3),
                  ),
                  boxShadow: [
                    if (!isRead)
                      BoxShadow(
                        color: AppColors.primaryGold.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isRead
                            ? Colors.grey.withOpacity(0.1)
                            : AppColors.primaryGold.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getNotificationIcon(type),
                        color: isRead ? Colors.grey : AppColors.primaryGold,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: AppTextStyles.body.copyWith(
                                    fontWeight: isRead
                                        ? FontWeight.w600
                                        : FontWeight.bold,
                                    color: isRead
                                        ? AppColors.textPrimary
                                        : AppColors.primaryDark,
                                  ),
                                ),
                              ),
                              Text(
                                _formatTimeAgo(createdAt),
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            body,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              height: 1.4,
                            ),
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
      },
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'package_approved':
        return Icons.check_circle_outline;
      case 'package_rejected':
        return Icons.cancel_outlined;
      case 'withdrawal_approved':
        return Icons.attach_money;
      case 'package_request':
        return Icons.card_giftcard;
      default:
        return Icons.notifications_outlined;
    }
  }

  /// ============================================
  /// Loading Widgets
  /// ============================================

  /// Loading Card for Earnings Summary
  Widget _buildLoadingCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGold.withOpacity(0.3),
            AppColors.primaryDark.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 32,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(6),
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
                  color: Colors.white54,
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
                    Container(
                      height: 10,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 18,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(5),
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

  /// Loading Card for Stats
  Widget _buildLoadingStatCard() {
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
          Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 20,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 11,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }
}
