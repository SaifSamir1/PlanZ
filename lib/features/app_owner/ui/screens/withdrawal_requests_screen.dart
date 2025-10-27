// lib/features/app_owner/withdrawals/ui/screens/withdrawal_requests_screen.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';

class WithdrawalRequestsScreen extends StatefulWidget {
  const WithdrawalRequestsScreen({super.key});

  @override
  State<WithdrawalRequestsScreen> createState() =>
      _WithdrawalRequestsScreenState();
}

class _WithdrawalRequestsScreenState extends State<WithdrawalRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock Data
  final List<Map<String, dynamic>> pendingRequests = [
    {
      'id': 'wd_001',
      'vendorName': 'Ahmed Hassan',
      'vendorImage': 'https://i.pravatar.cc/150?img=12',
      'amount': 1200.0,
      'walletNumber': '01012345678',
      'walletType': 'Vodafone Cash',
      'requestDate': DateTime(2024, 10, 22),
      'vendorBalance': 3500.0,
      'vendorEarnings': 4700.0,
    },
    {
      'id': 'wd_002',
      'vendorName': 'Sara Mohamed',
      'vendorImage': 'https://i.pravatar.cc/150?img=5',
      'amount': 800.0,
      'walletNumber': '01198765432',
      'walletType': 'Orange Money',
      'requestDate': DateTime(2024, 10, 21),
      'vendorBalance': 2300.0,
      'vendorEarnings': 3100.0,
    },
    {
      'id': 'wd_003',
      'vendorName': 'Mohamed Ali',
      'vendorImage': 'https://i.pravatar.cc/150?img=8',
      'amount': 500.0,
      'walletNumber': '01234567890',
      'walletType': 'Etisalat Cash',
      'requestDate': DateTime(2024, 10, 20),
      'vendorBalance': 1800.0,
      'vendorEarnings': 2300.0,
    },
  ];

  final List<Map<String, dynamic>> completedRequests = [
    {
      'id': 'wd_101',
      'vendorName': 'Fatma Ibrahim',
      'vendorImage': 'https://i.pravatar.cc/150?img=9',
      'amount': 1500.0,
      'walletNumber': '01087654321',
      'walletType': 'Vodafone Cash',
      'requestDate': DateTime(2024, 10, 15),
      'completedDate': DateTime(2024, 10, 16),
      'transactionId': 'TXN_20241016_001',
    },
    {
      'id': 'wd_102',
      'vendorName': 'Khaled Ahmed',
      'vendorImage': 'https://i.pravatar.cc/150?img=11',
      'amount': 900.0,
      'walletNumber': '01123456789',
      'walletType': 'Orange Money',
      'requestDate': DateTime(2024, 10, 10),
      'completedDate': DateTime(2024, 10, 11),
      'transactionId': 'TXN_20241011_002',
    },
  ];

  final List<Map<String, dynamic>> rejectedRequests = [
    {
      'id': 'wd_201',
      'vendorName': 'Omar Hassan',
      'vendorImage': 'https://i.pravatar.cc/150?img=15',
      'amount': 2000.0,
      'walletNumber': '01234567890',
      'walletType': 'Vodafone Cash',
      'requestDate': DateTime(2024, 10, 8),
      'rejectedDate': DateTime(2024, 10, 9),
      'rejectionReason': 'Insufficient balance',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Withdrawal Requests',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Stats Summary
          _buildStatsSummary(),

          // Tabs
          _buildTabs(),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPendingList(),
                _buildCompletedList(),
                _buildRejectedList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSummary() {
    final totalPending = pendingRequests.fold<double>(
      0.0,
      (sum, request) => sum + request['amount'],
    );

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            AppColors.primaryDark.withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.pending_actions,
            label: 'Pending',
            value: pendingRequests.length.toString(),
            amount: '\$${totalPending.toStringAsFixed(2)}',
            color: AppColors.warning,
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.white.withOpacity(0.3),
          ),
          _buildStatItem(
            icon: Icons.check_circle,
            label: 'Completed',
            value: completedRequests.length.toString(),
            amount: null,
            color: AppColors.success,
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.white.withOpacity(0.3),
          ),
          _buildStatItem(
            icon: Icons.cancel,
            label: 'Rejected',
            value: rejectedRequests.length.toString(),
            amount: null,
            color: AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    String? amount,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.title.copyWith(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        if (amount != null) ...[
          const SizedBox(height: 4),
          Text(
            amount,
            style: AppTextStyles.body.copyWith(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primaryGold,
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        tabs: const [
          Tab(text: 'Pending'),
          Tab(text: 'Completed'),
          Tab(text: 'Rejected'),
        ],
      ),
    );
  }

  Widget _buildPendingList() {
    if (pendingRequests.isEmpty) {
      return _buildEmptyState(
        icon: Icons.inbox,
        message: 'No pending withdrawal requests',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pendingRequests.length,
      itemBuilder: (context, index) {
        return _buildPendingRequestCard(pendingRequests[index]);
      },
    );
  }

  Widget _buildCompletedList() {
    if (completedRequests.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle_outline,
        message: 'No completed withdrawals yet',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: completedRequests.length,
      itemBuilder: (context, index) {
        return _buildCompletedRequestCard(completedRequests[index]);
      },
    );
  }

  Widget _buildRejectedList() {
    if (rejectedRequests.isEmpty) {
      return _buildEmptyState(
        icon: Icons.cancel_outlined,
        message: 'No rejected requests',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rejectedRequests.length,
      itemBuilder: (context, index) {
        return _buildRejectedRequestCard(rejectedRequests[index]);
      },
    );
  }

  Widget _buildPendingRequestCard(Map<String, dynamic> request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(request['vendorImage']),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request['vendorName'],
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Requested: ${request['requestDate'].day}/${request['requestDate'].month}/${request['requestDate'].year}',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Pending',
                        style: TextStyle(
                          color: AppColors.warning,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Amount Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryGold.withOpacity(0.15),
                        AppColors.primaryGold.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryGold.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.monetization_on,
                        color: AppColors.primaryGold,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Withdrawal Amount',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '\$${request['amount'].toStringAsFixed(2)}',
                            style: AppTextStyles.title.copyWith(
                              color: AppColors.primaryGold,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Wallet Info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        icon: Icons.phone_android,
                        label: 'Wallet Number',
                        value: request['walletNumber'],
                      ),
                      const Divider(height: 16),
                      _buildInfoRow(
                        icon: Icons.payment,
                        label: 'Wallet Type',
                        value: request['walletType'],
                      ),
                      const Divider(height: 16),
                      _buildInfoRow(
                        icon: Icons.account_balance_wallet,
                        label: 'Available Balance',
                        value: '\$${request['vendorBalance'].toStringAsFixed(2)}',
                        valueColor: AppColors.success,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showRequestDetails(request),
                        icon: const Icon(Icons.visibility, size: 18),
                        label: const Text('Details'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryDark,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: AppColors.primaryDark),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _approveWithdrawal(request),
                        icon: const Icon(Icons.check_circle, size: 18),
                        label: const Text('Approve'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _rejectWithdrawal(request),
                      icon: const Icon(Icons.cancel),
                      color: AppColors.error,
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.error.withOpacity(0.1),
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.body.copyWith(
            color: valueColor ?? AppColors.primaryDark,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedRequestCard(Map<String, dynamic> request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.success.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 32,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request['vendorName'],
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${request['amount'].toStringAsFixed(2)} • ${request['walletType']}',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'TXN: ${request['transactionId']}',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Completed',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${request['completedDate'].day}/${request['completedDate'].month}/${request['completedDate'].year}',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRejectedRequestCard(Map<String, dynamic> request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.error.withOpacity(0.3),
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
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(request['vendorImage']),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request['vendorName'],
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${request['amount'].toStringAsFixed(2)}',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.cancel,
                  color: AppColors.error,
                  size: 24,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.error.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rejection Reason:',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  request['rejectionReason'],
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showRequestDetails(Map<String, dynamic> request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
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

            // Title
            Text(
              'Withdrawal Request Details',
              style: AppTextStyles.title.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            // Vendor Info
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(request['vendorImage']),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request['vendorName'],
                        style: AppTextStyles.title.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Request ID: ${request['id']}',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Amount Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryGold.withOpacity(0.2),
                    AppColors.primaryGold.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryGold.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Requested Amount',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${request['amount'].toStringAsFixed(2)}',
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.primaryGold,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Details
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildDetailRow('Wallet Number', request['walletNumber']),
                    _buildDetailRow('Wallet Type', request['walletType']),
                    _buildDetailRow(
                      'Request Date',
                      '${request['requestDate'].day}/${request['requestDate'].month}/${request['requestDate'].year}',
                    ),
                    _buildDetailRow(
                      'Vendor Balance',
                      '\$${request['vendorBalance'].toStringAsFixed(2)}',
                      valueColor: AppColors.success,
                    ),
                    _buildDetailRow(
                      'Total Earnings',
                      '\$${request['vendorEarnings'].toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _approveWithdrawal(request);
                    },
                    icon: const Icon(Icons.check_circle, size: 20),
                    label: const Text('Approve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _rejectWithdrawal(request);
                    },
                    icon: const Icon(Icons.cancel, size: 20),
                    label: const Text('Reject'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              color: valueColor ?? AppColors.primaryDark,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _approveWithdrawal(Map<String, dynamic> request) {
    final TextEditingController transactionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Approve Withdrawal'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Approving withdrawal for ${request['vendorName']}',
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Amount:'),
                      Text(
                        '\$${request['amount'].toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Wallet:'),
                      Text(
                        request['walletNumber'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Enter transaction ID (optional):',
              style: AppTextStyles.body.copyWith(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: transactionController,
              decoration: InputDecoration(
                hintText: 'e.g., TXN_20241024_001',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryGold,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement approval logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('Withdrawal approved! Transfer \$${request['amount'].toStringAsFixed(2)} to ${request['walletNumber']}'),
                      ),
                    ],
                  ),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Approve & Transfer'),
          ),
        ],
      ),
    );
  }

  void _rejectWithdrawal(Map<String, dynamic> request) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.cancel,
                color: AppColors.error,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Reject Withdrawal'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rejecting withdrawal for ${request['vendorName']}',
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Please provide a reason for rejection:',
              style: AppTextStyles.body.copyWith(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter rejection reason...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryGold,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please provide a rejection reason'),
                  ),
                );
                return;
              }

              Navigator.pop(context);
              // TODO: Implement rejection logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.info, color: Colors.white),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text('Withdrawal request rejected'),
                      ),
                    ],
                  ),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }
}
