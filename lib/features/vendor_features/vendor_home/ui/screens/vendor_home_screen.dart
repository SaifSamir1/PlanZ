// lib/features/vendor_features/vendor_home/ui/screens/vendor_home_screen.dart

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/ui/screens/all_packages_screen.dart';
import 'package:plan_z/features/vendor_features/vendor_home/ui/screens/vendor_earnings_screen.dart';

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  int selectedTab = 0; // 0 = Requests, 1 = Notifications

  // Mock Data - Requests
  final List<Map<String, dynamic>> mockRequests = [
    {
      'id': 'req_001',
      'eventTitle': 'Annual Tech Conference',
      'packageName': 'Standard Catering Package',
      'date': DateTime(2024, 7, 15, 10, 0),
      'status': 'Verified',
      'statusColor': AppColors.success,
      'eventImage': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87',
      'price': 850.0,
      'attendees': 200,
    },
    {
      'id': 'req_002',
      'eventTitle': 'Wedding Ceremony',
      'packageName': 'Premium Photo & Video',
      'date': DateTime(2024, 8, 1, 15, 0),
      'status': 'Pending',
      'statusColor': AppColors.warning,
      'eventImage': 'https://images.unsplash.com/photo-1519741497674-611481863552',
      'price': 1200.0,
      'attendees': 150,
    },
    {
      'id': 'req_003',
      'eventTitle': 'Startup Pitch Event',
      'packageName': 'Full Audio Visual Setup',
      'date': DateTime(2024, 6, 28, 9, 0),
      'status': 'Rejected',
      'statusColor': AppColors.error,
      'eventImage': 'https://images.unsplash.com/photo-1511578314322-379afb476865',
      'price': 650.0,
      'attendees': 100,
    },
  ];

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
              backgroundImage: const NetworkImage(
                'https://i.pravatar.cc/150?img=3',
              ),
              backgroundColor: AppColors.primaryGold.withOpacity(0.2),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
    );
  }

  Widget _buildEarningsSummaryCard() {
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
                      '\$4,567.89',
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
                        '\$3,200.00',
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
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.event_available,
            title: 'Active Jobs',
            value: '8',
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.pending_actions,
            title: 'Pending',
            value: '3',
            color: AppColors.warning,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.inventory_2,
            title: 'Packages',
            value: '12',
            color: AppColors.primaryGold,
          ),
        ),
      ],
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
                  builder: (context) => const PackagesScreen(packages: []),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            icon: Icons.calendar_today_outlined,
            label: 'Availability',
            onTap: () {},
          ),
        ),
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
                  color: selectedTab == 0 ? AppColors.primaryGold : Colors.grey.shade300,
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
                  color: selectedTab == 1 ? AppColors.primaryGold : Colors.grey.shade300,
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

  Widget _buildRequestsList() {
    return Column(
      children: mockRequests.map((request) => _buildRequestCard(request)).toList(),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    request['eventImage'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request['eventTitle'],
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        request['packageName'],
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: request['statusColor'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    request['status'],
                    style: TextStyle(
                      color: request['statusColor'],
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
                  '${request['date'].day}/${request['date'].month}/${request['date'].year} at ${request['date'].hour}:${request['date'].minute.toString().padLeft(2, '0')}',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.people, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  '${request['attendees']} guests',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                if (request['status'] != 'Rejected')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
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
                if (request['status'] != 'Rejected') const SizedBox(width: 8),
                if (request['status'] == 'Pending')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
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
                if (request['status'] == 'Pending') const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
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
            ),
          ],
        ),
      ),
    );
  }

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
