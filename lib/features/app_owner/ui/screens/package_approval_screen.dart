// lib/features/app_owner/packages/ui/screens/package_approval_screen.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class PackageApprovalScreen extends StatefulWidget {
  const PackageApprovalScreen({super.key});

  @override
  State<PackageApprovalScreen> createState() => _PackageApprovalScreenState();
}

class _PackageApprovalScreenState extends State<PackageApprovalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock Data
  final List<Map<String, dynamic>> pendingPackages = [
    {
      'id': 'pkg_001',
      'name': 'Premium Wedding Photography',
      'vendorName': 'Ahmed Hassan',
      'vendorImage': 'https://i.pravatar.cc/150?img=12',
      'category': 'Photography',
      'price': 1200.0,
      'description':
          'Complete wedding photography package with 2 photographers, 8 hours coverage, edited photos, and album',
      'features': [
        '2 Professional Photographers',
        '8 Hours Coverage',
        '500+ Edited Photos',
        'Premium Photo Album',
        'Online Gallery',
      ],
      'submittedDate': DateTime(2024, 10, 20),
      // Google Drive Links for Portfolio
      'portfolioLinks': [
        {
          'type': 'image', // image or video
          'url': 'https://drive.google.com/file/d/1ABC123/view',
          'thumbnail': 'https://images.unsplash.com/photo-1606800052052-a08af7148866',
        },
        {
          'type': 'image',
          'url': 'https://drive.google.com/file/d/1XYZ789/view',
          'thumbnail': 'https://images.unsplash.com/photo-1511285560929-80b456fea0bc',
        },
        {
          'type': 'video',
          'url': 'https://drive.google.com/file/d/1VIDEO123/view',
          'thumbnail': 'https://images.unsplash.com/photo-1492691527719-9d1e07e534b4',
        },
      ],
    },
    {
      'id': 'pkg_002',
      'name': 'Standard Catering Package',
      'vendorName': 'Sara Mohamed',
      'vendorImage': 'https://i.pravatar.cc/150?img=5',
      'category': 'Catering',
      'price': 850.0,
      'description':
          'Professional catering service for corporate events up to 200 guests',
      'features': [
        'Buffet Setup',
        'Service for 200 guests',
        '3 Main Dishes',
        '2 Side Dishes',
        'Desserts & Beverages',
      ],
      'submittedDate': DateTime(2024, 10, 21),
      'portfolioLinks': [
        {
          'type': 'image',
          'url': 'https://drive.google.com/file/d/1CATERING123/view',
          'thumbnail': 'https://images.unsplash.com/photo-1555244162-803834f70033',
        },
      ],
    },
    {
      'id': 'pkg_003',
      'name': 'DJ & Sound System',
      'vendorName': 'Mohamed Ali',
      'vendorImage': 'https://i.pravatar.cc/150?img=8',
      'category': 'Entertainment',
      'price': 650.0,
      'description': 'Professional DJ service with premium sound system',
      'features': [
        'Professional DJ',
        'Premium Sound System',
        '6 Hours Service',
        'LED Lighting',
        'Playlist Customization',
      ],
      'submittedDate': DateTime(2024, 10, 19),
      'portfolioLinks': [
        {
          'type': 'video',
          'url': 'https://drive.google.com/file/d/1DJVIDEO/view',
          'thumbnail': 'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3',
        },
      ],
    },
  ];

  final List<Map<String, dynamic>> approvedPackages = [
    {
      'id': 'pkg_101',
      'name': 'Luxury Venue Decoration',
      'vendorName': 'Fatma Ibrahim',
      'vendorImage': 'https://i.pravatar.cc/150?img=9',
      'category': 'Decoration',
      'price': 2000.0,
      'approvedDate': DateTime(2024, 10, 15),
    },
    {
      'id': 'pkg_102',
      'name': 'Professional Video Coverage',
      'vendorName': 'Khaled Ahmed',
      'vendorImage': 'https://i.pravatar.cc/150?img=11',
      'category': 'Videography',
      'price': 1500.0,
      'approvedDate': DateTime(2024, 10, 14),
    },
  ];

  final List<Map<String, dynamic>> rejectedPackages = [
    {
      'id': 'pkg_201',
      'name': 'Basic DJ Service',
      'vendorName': 'Omar Hassan',
      'vendorImage': 'https://i.pravatar.cc/150?img=15',
      'category': 'Entertainment',
      'price': 300.0,
      'rejectedDate': DateTime(2024, 10, 10),
      'rejectionReason': 'Incomplete package details and missing portfolio',
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
        title: 'Package Approvals',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Stats Summary
          _buildStatsSummary(),

          // Tabs - WITH PADDING
          _buildTabs(),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPendingList(),
                _buildApprovedList(),
                _buildRejectedList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSummary() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGold.withOpacity(0.1),
            AppColors.primaryGold.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryGold.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.pending_actions,
            label: 'Pending',
            value: pendingPackages.length.toString(),
            color: AppColors.warning,
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade300,
          ),
          _buildStatItem(
            icon: Icons.check_circle,
            label: 'Approved',
            value: approvedPackages.length.toString(),
            color: AppColors.success,
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade300,
          ),
          _buildStatItem(
            icon: Icons.cancel,
            label: 'Rejected',
            value: rejectedPackages.length.toString(),
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
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.title.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16,),
      
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
        indicatorSize: TabBarIndicatorSize.tab,
        // إضافة Padding للـ Tabs
        labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        indicatorPadding: const EdgeInsets.all(4),
        tabs: const [
          Tab(text: 'Pending'),
          Tab(text: 'Approved'),
          Tab(text: 'Rejected'),
        ],
      ),
    );
  }

  Widget _buildPendingList() {
    if (pendingPackages.isEmpty) {
      return _buildEmptyState(
        icon: Icons.inbox,
        message: 'No pending packages',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pendingPackages.length,
      itemBuilder: (context, index) {
        return _buildPendingPackageCard(pendingPackages[index]);
      },
    );
  }

  Widget _buildApprovedList() {
    if (approvedPackages.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle_outline,
        message: 'No approved packages yet',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: approvedPackages.length,
      itemBuilder: (context, index) {
        return _buildApprovedPackageCard(approvedPackages[index]);
      },
    );
  }

  Widget _buildRejectedList() {
    if (rejectedPackages.isEmpty) {
      return _buildEmptyState(
        icon: Icons.cancel_outlined,
        message: 'No rejected packages',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rejectedPackages.length,
      itemBuilder: (context, index) {
        return _buildRejectedPackageCard(rejectedPackages[index]);
      },
    );
  }

  Widget _buildPendingPackageCard(Map<String, dynamic> package) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  radius: 24,
                  backgroundImage: NetworkImage(package['vendorImage']),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package['vendorName'],
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.category,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            package['category'],
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  package['name'],
                  style: AppTextStyles.title.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  package['description'],
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // Price
                Row(
                  children: [
                    Icon(
                      Icons.attach_money,
                      color: AppColors.primaryGold,
                      size: 20,
                    ),
                    Text(
                      '\$${package['price'].toStringAsFixed(2)}',
                      style: AppTextStyles.title.copyWith(
                        color: AppColors.primaryGold,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showPackageDetails(package),
                        icon: const Icon(Icons.visibility, size: 18),
                        label: const Text('View Details'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDark,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _approvePackage(package),
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
                      onPressed: () => _rejectPackage(package),
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

  Widget _buildApprovedPackageCard(Map<String, dynamic> package) {
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
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(package['vendorImage']),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  package['name'],
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  package['vendorName'],
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
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
                    Text(
                      'Approved: ${package['approvedDate'].day}/${package['approvedDate'].month}/${package['approvedDate'].year}',
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectedPackageCard(Map<String, dynamic> package) {
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
                backgroundImage: NetworkImage(package['vendorImage']),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package['name'],
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      package['vendorName'],
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
                  package['rejectionReason'],
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

  void _showPackageDetails(Map<String, dynamic> package) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
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

                // Package Name
                Text(
                  package['name'],
                  style: AppTextStyles.title.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                // Vendor Info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(package['vendorImage']),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          package['vendorName'],
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          package['category'],
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Price
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryGold.withOpacity(0.1),
                        AppColors.primaryGold.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Package Price:',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '\$${package['price'].toStringAsFixed(2)}',
                        style: AppTextStyles.title.copyWith(
                          color: AppColors.primaryGold,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Description
                Text(
                  'Description',
                  style: AppTextStyles.title.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  package['description'],
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 20),

                // Features
                Text(
                  'Package Features',
                  style: AppTextStyles.title.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(
                  package['features'].length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            package['features'][index],
                            style: AppTextStyles.body.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Portfolio Section (Images/Videos from Google Drive)
                if (package['portfolioLinks'] != null &&
                    package['portfolioLinks'].isNotEmpty) ...[
                  Text(
                    'Portfolio & Work Samples',
                    style: AppTextStyles.title.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPortfolioGallery(package['portfolioLinks']),
                  const SizedBox(height: 20),
                ],

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _approvePackage(package);
                        },
                        icon: const Icon(Icons.check_circle, size: 20),
                        label: const Text('Approve Package'),
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
                          _rejectPackage(package);
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
        ),
      ),
    );
  }

  // Portfolio Gallery Widget (Images & Videos)
  Widget _buildPortfolioGallery(List<dynamic> portfolioLinks) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: portfolioLinks.length,
        itemBuilder: (context, index) {
          final item = portfolioLinks[index];
          final isVideo = item['type'] == 'video';

          return GestureDetector(
            onTap: () => _openGoogleDriveLink(item['url']),
            child: Container(
              width: 180,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item['thumbnail'],
                      width: 180,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Overlay
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),

                  // Play Icon for Videos
                  if (isVideo)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: AppColors.primaryDark,
                          size: 32,
                        ),
                      ),
                    ),

                  // Type Badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isVideo
                            ? AppColors.error.withOpacity(0.9)
                            : AppColors.primaryGold.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isVideo ? Icons.videocam : Icons.image,
                            color: Colors.white,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isVideo ? 'Video' : 'Image',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // View on Drive Text
                  Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: Text(
                      'Tap to view on Google Drive',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Open Google Drive Link
  Future<void> _openGoogleDriveLink(String url) async {
    final Uri driveUri = Uri.parse(url);

    try {
      if (await canLaunchUrl(driveUri)) {
        await launchUrl(
          driveUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Could not open Google Drive link'),
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
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _approvePackage(Map<String, dynamic> package) {
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
            // FIX OVERFLOW IN TITLE
            Expanded(
              child: Text(
                'Approve Package?',
                style: AppTextStyles.title.copyWith(fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to approve this package?',
              style: AppTextStyles.body.copyWith(
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package['name'],
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'by ${package['vendorName']}',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
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
                      const Expanded(
                        child: Text('Package approved successfully!'),
                      ),
                    ],
                  ),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
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
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _rejectPackage(Map<String, dynamic> package) {
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
            const Expanded(
              child: Text(
                'Reject Package',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rejecting "${package['name']}"',
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
                        child: Text('Package rejected'),
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
