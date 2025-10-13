// lib/features/events/presentation/screens/browse_packages_screen.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';

import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/basic_event_info_screen.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/event_review_screen.dart';

class BrowsePackagesScreen extends StatefulWidget {
  final Map<String, dynamic> eventInfo;
  final Map<String, dynamic> budgetData;
  final Map<String, dynamic> servicesData;

  const BrowsePackagesScreen({
    super.key,
    required this.eventInfo,
    required this.budgetData,
    required this.servicesData,
  });

  @override
  State<BrowsePackagesScreen> createState() => _BrowsePackagesScreenState();
}

class _BrowsePackagesScreenState extends State<BrowsePackagesScreen> {
  int _currentServiceIndex = 0;
  final Map<String, String> _selectedPackages = {};

  String _sortBy = 'price_low';
  double _minPrice = 0;
  double _maxPrice = 200000;
  String? _selectedCity;

  late List<Map<String, dynamic>> _allPackages;
  List<Map<String, dynamic>> _filteredPackages = [];

  @override
  void initState() {
    super.initState();
    _loadPackages();
    _filterPackages();
  }

  void _loadPackages() {
    _allPackages = _mockPackagesData;
  }

  void _filterPackages() {
    final currentService = _getCurrentService();
    final serviceId = currentService['serviceId'];

    var packages = _allPackages
        .where((pkg) => pkg['serviceId'] == serviceId)
        .toList();
    packages = packages
        .where((pkg) => pkg['price'] >= _minPrice && pkg['price'] <= _maxPrice)
        .toList();

    if (_selectedCity != null) {
      packages = packages
          .where((pkg) => pkg['location']['city'] == _selectedCity)
          .toList();
    }

    if (_sortBy == 'price_low') {
      packages.sort((a, b) => a['price'].compareTo(b['price']));
    } else if (_sortBy == 'price_high') {
      packages.sort((a, b) => b['price'].compareTo(a['price']));
    } else if (_sortBy == 'rating') {
      packages.sort((a, b) => b['rating'].compareTo(a['rating']));
    }

    setState(() {
      _filteredPackages = packages;
    });
  }

  Map<String, dynamic> _getCurrentService() {
    final selectedServices = widget.servicesData['selectedServices'] as List;
    return selectedServices[_currentServiceIndex];
  }

  double _getCurrentServiceBudget() {
    final service = _getCurrentService();
    final totalBudget = widget.budgetData['totalBudget'].toDouble();
    final percentage = service['suggestedBudgetPercentage'].toDouble();
    return totalBudget * percentage / 100;
  }

  double _getCurrentServiceSpent() {
    final serviceId = _getCurrentService()['serviceId'];
    final selectedPackageId = _selectedPackages[serviceId];

    if (selectedPackageId == null) return 0;

    final package = _allPackages.firstWhere(
      (pkg) => pkg['packageId'] == selectedPackageId,
      orElse: () => {'price': 0},
    );

    return package['price'].toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final selectedServices = widget.servicesData['selectedServices'] as List;
    final totalServices = selectedServices.length;
    final currentService = _getCurrentService();
    final isLastService = _currentServiceIndex == totalServices - 1;
    final allocated = _getCurrentServiceBudget();
    final spent = _getCurrentServiceSpent();
    final remaining = allocated - spent;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(currentService, totalServices),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Progress Indicator
          SliverToBoxAdapter(child: _buildProgressIndicator()),

          // Compact Budget Tracker
          SliverToBoxAdapter(
            child: _buildCompactBudgetTracker(allocated, spent, remaining),
          ),

          // Filters & Sort Bar
          SliverToBoxAdapter(child: _buildFiltersBar()),

          // Packages List
          _filteredPackages.isEmpty
              ? SliverFillRemaining(child: _buildEmptyState())
              : SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final package = _filteredPackages[index];
                      final serviceId = _getCurrentService()['serviceId'];
                      final isSelected =
                          package['packageId'] == _selectedPackages[serviceId];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildPackageCard(package, isSelected),
                      );
                    }, childCount: _filteredPackages.length),
                  ),
                ),

          // Bottom padding for FAB
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: _buildFloatingActionButtons(
        currentService,
        isLastService,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Map<String, dynamic> service, int total) {
    return AppBar(
      backgroundColor: AppColors.primaryDark,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: AppColors.textLight),
        onPressed: () {
          if (_currentServiceIndex > 0) {
            setState(() {
              _currentServiceIndex--;
              _filterPackages();
            });
          } else {
            Navigator.pop(context);
          }
        },
      ),
      title: Column(
        children: [
          Text(
            service['serviceName'],
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Service ${_currentServiceIndex + 1} of $total',
            style: TextStyle(
              color: AppColors.textLight.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        if (_currentServiceIndex < total - 1)
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textLight,
            ),
            onPressed: _goToNextService,
          ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const StepProgressIndicator(currentStep: 5, totalSteps: 8),
    );
  }

  /// Compact Budget Tracker (simplified version)
  Widget _buildCompactBudgetTracker(
    double allocated,
    double spent,
    double remaining,
  ) {
    final percentageSpent = spent > 0 ? (spent / allocated * 100) : 0.0;
    final isOverBudget = spent > allocated;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryGold.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryGold.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Title & Values
          Row(
            children: [
              const Icon(
                Icons.account_balance_wallet,
                color: AppColors.primaryGold,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Budget: ${_formatCurrency(allocated)} EGP',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Spent: ${_formatCurrency(spent)} EGP • Remaining: ${_formatCurrency(remaining)} EGP',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isOverBudget ? AppColors.error : AppColors.success,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${percentageSpent.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (percentageSpent / 100).clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: AppColors.blue100,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOverBudget ? AppColors.error : AppColors.primaryGold,
              ),
            ),
          ),

          // Warning
          if (isOverBudget)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.error,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Over budget! Consider a lower-priced package.',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFiltersBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _showFiltersBottomSheet,
              icon: const Icon(Icons.filter_list, size: 18),
              label: const Text('Filters', style: TextStyle(fontSize: 13)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryGold,
                side: const BorderSide(color: AppColors.primaryGold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryGold),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: _sortBy,
                isExpanded: true,
                underline: const SizedBox.shrink(),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.primaryGold,
                  size: 20,
                ),
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textPrimary,
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'price_low',
                    child: Text('Price: Low → High'),
                  ),
                  DropdownMenuItem(
                    value: 'price_high',
                    child: Text('Price: High → Low'),
                  ),
                  DropdownMenuItem(
                    value: 'rating',
                    child: Text('Rating: High → Low'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _sortBy = value!;
                    _filterPackages();
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageCard(Map<String, dynamic> package, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.success : AppColors.blue100,
          width: isSelected ? 2.5 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? AppColors.success.withOpacity(0.15)
                : AppColors.shadow.withOpacity(0.08),
            blurRadius: isSelected ? 10 : 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Placeholder
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: AppColors.blue50,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(Icons.image, size: 40, color: AppColors.blue200),
                ),
                if (isSelected)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 14,
                            color: AppColors.textLight,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Selected',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Package Name
                Text(
                  package['packageName'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                // Vendor & Rating
                Row(
                  children: [
                    const Icon(
                      Icons.store,
                      size: 13,
                      color: AppColors.primaryGold,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        package['vendorName'],
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.star, size: 13, color: Colors.amber),
                    const SizedBox(width: 2),
                    Text(
                      '${package['rating']}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Price
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Price',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '${package['price']} EGP',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showPackageDetails(package),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.info,
                          side: const BorderSide(color: AppColors.info),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text(
                          'Details',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _selectPackage(package),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? AppColors.success
                              : AppColors.primaryGold,
                          foregroundColor: AppColors.textLight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: Text(
                          isSelected ? 'Selected ✓' : 'Select',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 70,
            color: AppColors.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No packages found',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try adjusting your filters',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  /// Floating Action Buttons (Navigation)
  Widget _buildFloatingActionButtons(
    Map<String, dynamic> service,
    bool isLast,
  ) {
    final serviceId = service['serviceId'];
    final hasSelection = _selectedPackages.containsKey(serviceId);
    final isRequired = service['required'] == true;
    final canProceed = hasSelection || !isRequired;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Skip button (if optional)
        if (!isRequired)
          FloatingActionButton.extended(
            onPressed: _skipService,
            backgroundColor: AppColors.textLight,
            foregroundColor: AppColors.textSecondary,
            heroTag: 'skip',
            label: const Text(
              'Skip',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            icon: const Icon(Icons.skip_next, size: 18),
          ),

        if (!isRequired) const SizedBox(height: 12),

        // Next/Finish button
        FloatingActionButton.extended(
          onPressed: canProceed
              ? (isLast ? _finishSelection : _goToNextService)
              : null,
          backgroundColor: canProceed
              ? AppColors.primaryGold
              : AppColors.blue100,
          foregroundColor: canProceed
              ? AppColors.textPrimary
              : AppColors.textSecondary,
          heroTag: 'next',
          label: Text(
            isLast ? 'Review Event' : 'Next Service',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          icon: Icon(
            isLast ? Icons.check_circle : Icons.arrow_forward,
            size: 20,
          ),
        ),
      ],
    );
  }

  void _selectPackage(Map<String, dynamic> package) {
    final serviceId = _getCurrentService()['serviceId'];
    setState(() {
      if (_selectedPackages[serviceId] == package['packageId']) {
        _selectedPackages.remove(serviceId);
      } else {
        _selectedPackages[serviceId] = package['packageId'];
      }
    });
  }

  void _showPackageDetails(Map<String, dynamic> package) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.blue200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package['packageName'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.store,
                          size: 16,
                          color: AppColors.primaryGold,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          package['vendorName'],
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${package['rating']} (${package['reviewsCount']})',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGold.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Package Price',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '${package['price']} EGP',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      package['description'],
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Package Includes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...(package['includes'] as List<String>).map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 18,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _selectPackage(package);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGold,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Select This Package',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFiltersBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FilterBottomSheet(
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        selectedCity: _selectedCity,
        onApply: (min, max, city) {
          setState(() {
            _minPrice = min;
            _maxPrice = max;
            _selectedCity = city;
            _filterPackages();
          });
        },
      ),
    );
  }

  void _skipService() {
    _selectedPackages.remove(_getCurrentService()['serviceId']);
    _goToNextService();
  }

  void _goToNextService() {
    final selectedServices = widget.servicesData['selectedServices'] as List;
    if (_currentServiceIndex < selectedServices.length - 1) {
      setState(() {
        _currentServiceIndex++;
        _filterPackages();
      });
    } else {
      _finishSelection();
    }
  }

  /// Finish Selection
  void _finishSelection() {
    // Check if user selected packages for all required services
    final selectedServices = widget.servicesData['selectedServices'] as List;
    final requiredServices = selectedServices
        .where((s) => s['required'] == true)
        .toList();

    bool allRequiredSelected = true;
    for (var service in requiredServices) {
      if (!_selectedPackages.containsKey(service['serviceId'])) {
        allRequiredSelected = false;
        break;
      }
    }

    if (!allRequiredSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select packages for all required services'),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Navigate to Event Review Screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventReviewScreen(
          eventInfo: widget.eventInfo,
          budgetData: widget.budgetData,
          servicesData: widget.servicesData,
          selectedPackages: _selectedPackages,
          allPackages: _allPackages,
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) return '${(amount / 1000000).toStringAsFixed(1)}M';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(1)}K';
    return amount.toStringAsFixed(0);
  }

  static final List<Map<String, dynamic>> _mockPackagesData = [
    // ========== VENUE PACKAGES ==========
    {
      'packageId': 'pkg_venue_001',
      'serviceId': 'srv_venue',
      'packageName': 'Premium Wedding Hall Package',
      'vendorName': 'Grand Events Hall',
      'description':
          'Luxurious wedding hall with modern amenities, crystal chandeliers, and elegant decor. Perfect for large celebrations.',
      'price': 50000,
      'rating': 4.8,
      'reviewsCount': 120,
      'capacity': 500,
      'duration': 6,
      'location': {'city': 'Cairo', 'area': 'Nasr City'},
      'includes': [
        'Hall rental for 6 hours',
        'Tables and chairs setup',
        'Basic stage decoration',
        'Sound system and microphones',
        'Air conditioning',
        'Parking facilities',
        'Security staff',
      ],
    },
    {
      'packageId': 'pkg_venue_002',
      'serviceId': 'srv_venue',
      'packageName': 'Garden Wedding Venue',
      'vendorName': 'Green Paradise Venues',
      'description':
          'Beautiful outdoor garden venue with natural scenery, perfect for romantic outdoor weddings.',
      'price': 35000,
      'rating': 4.5,
      'reviewsCount': 85,
      'capacity': 300,
      'duration': 5,
      'location': {'city': 'Cairo', 'area': 'Maadi'},
      'includes': [
        'Garden venue rental',
        'Outdoor seating arrangement',
        'Lighting setup',
        'Backup indoor space',
        'Restroom facilities',
        'Garden maintenance',
      ],
    },
    {
      'packageId': 'pkg_venue_003',
      'serviceId': 'srv_venue',
      'packageName': 'Luxury Hotel Ballroom',
      'vendorName': 'Royal Palace Hotel',
      'description':
          'Elegant hotel ballroom with marble floors, crystal chandeliers, and five-star service.',
      'price': 80000,
      'rating': 4.9,
      'reviewsCount': 200,
      'capacity': 600,
      'duration': 8,
      'location': {'city': 'Cairo', 'area': 'Zamalek'},
      'includes': [
        'Ballroom rental for 8 hours',
        'Premium furniture setup',
        'Professional lighting',
        'Valet parking service',
        'Dressing rooms for bride and groom',
        'Security services',
        'Red carpet entrance',
      ],
    },
    {
      'packageId': 'pkg_venue_004',
      'serviceId': 'srv_venue',
      'packageName': 'Rooftop Venue with City View',
      'vendorName': 'Sky Events Venue',
      'description':
          'Modern rooftop venue with stunning city views, perfect for contemporary celebrations.',
      'price': 45000,
      'rating': 4.6,
      'reviewsCount': 95,
      'capacity': 350,
      'duration': 6,
      'location': {'city': 'Cairo', 'area': 'New Cairo'},
      'includes': [
        'Rooftop venue rental',
        'Modern furniture',
        'Ambient lighting',
        'Sound system',
        'Bar area',
        'Elevator access',
      ],
    },
    {
      'packageId': 'pkg_venue_005',
      'serviceId': 'srv_venue',
      'packageName': 'Beach Resort Venue',
      'vendorName': 'Coastal Dreams Resort',
      'description':
          'Beachfront resort venue with ocean views and sandy beach ceremony area.',
      'price': 70000,
      'rating': 4.7,
      'reviewsCount': 110,
      'capacity': 400,
      'duration': 7,
      'location': {'city': 'Alexandria', 'area': 'Miami'},
      'includes': [
        'Beach ceremony setup',
        'Reception hall',
        'Beach chairs and umbrellas',
        'Lighting for evening events',
        'Sound system',
        'Hotel accommodation discount',
      ],
    },

    // ========== CATERING PACKAGES ==========
    {
      'packageId': 'pkg_catering_001',
      'serviceId': 'srv_catering',
      'packageName': 'Premium Buffet Package',
      'vendorName': 'Delicious Catering Co.',
      'description':
          'Extensive buffet with international and oriental dishes, appetizers, main courses, and desserts.',
      'price': 38000,
      'rating': 4.7,
      'reviewsCount': 150,
      'capacity': 300,
      'duration': 6,
      'location': {'city': 'Cairo', 'area': 'Nasr City'},
      'includes': [
        '4 appetizer stations',
        '6 main course options',
        'Pasta and rice station',
        'Dessert buffet with cake',
        'Welcome drinks',
        'Coffee and tea service',
        'Professional waiters',
      ],
    },
    {
      'packageId': 'pkg_catering_002',
      'serviceId': 'srv_catering',
      'packageName': 'Oriental Feast Package',
      'vendorName': 'Eastern Delights Catering',
      'description':
          'Authentic oriental cuisine featuring traditional recipes with modern presentation.',
      'price': 32000,
      'rating': 4.6,
      'reviewsCount': 95,
      'capacity': 250,
      'duration': 5,
      'location': {'city': 'Cairo', 'area': 'Heliopolis'},
      'includes': [
        'Mezze platter',
        'Grilled meats selection',
        'Traditional rice dishes',
        'Fresh salads bar',
        'Arabic sweets',
        'Soft drinks and juices',
      ],
    },
    {
      'packageId': 'pkg_catering_003',
      'serviceId': 'srv_catering',
      'packageName': 'Gourmet Plated Dinner',
      'vendorName': 'Fine Dining Events',
      'description':
          'Elegant three-course plated dinner with chef-prepared dishes, perfect for sophisticated events.',
      'price': 55000,
      'rating': 4.9,
      'reviewsCount': 110,
      'capacity': 200,
      'duration': 4,
      'location': {'city': 'Cairo', 'area': 'New Cairo'},
      'includes': [
        'Three-course plated dinner',
        'Amuse-bouche',
        'Premium wine selection',
        'Professional table service',
        'Custom menu design',
        'Table decorations',
      ],
    },
    {
      'packageId': 'pkg_catering_004',
      'serviceId': 'srv_catering',
      'packageName': 'BBQ Grill Station Package',
      'vendorName': 'Grill Masters Catering',
      'description':
          'Live BBQ grill stations with fresh grilled meats, seafood, and vegetables.',
      'price': 42000,
      'rating': 4.5,
      'reviewsCount': 88,
      'capacity': 300,
      'duration': 6,
      'location': {'city': 'Giza', 'area': 'Haram'},
      'includes': [
        'Live grill stations',
        'Assorted grilled meats',
        'Seafood options',
        'Grilled vegetables',
        'Salad bar',
        'Fresh bread',
        'Professional chefs',
      ],
    },
    {
      'packageId': 'pkg_catering_005',
      'serviceId': 'srv_catering',
      'packageName': 'International Fusion Buffet',
      'vendorName': 'Global Tastes Catering',
      'description':
          'Diverse international menu featuring Italian, Asian, Middle Eastern, and Western cuisines.',
      'price': 48000,
      'rating': 4.8,
      'reviewsCount': 130,
      'capacity': 350,
      'duration': 6,
      'location': {'city': 'Cairo', 'area': 'Zamalek'},
      'includes': [
        'Italian pasta station',
        'Asian stir-fry station',
        'Middle Eastern mezze',
        'Western entrees',
        'International desserts',
        'Fresh juice bar',
      ],
    },

    // ========== PHOTOGRAPHY & VIDEOGRAPHY PACKAGES ==========
    {
      'packageId': 'pkg_photo_001',
      'serviceId': 'srv_photography',
      'packageName': 'Full Day Coverage Package',
      'vendorName': 'Moments Photography Studio',
      'description':
          'Comprehensive photo and video coverage from preparation to departure, including aerial drone shots.',
      'price': 20000,
      'rating': 4.8,
      'reviewsCount': 180,
      'capacity': 0,
      'duration': 8,
      'location': {'city': 'Cairo', 'area': 'Nasr City'},
      'includes': [
        '2 professional photographers',
        'Videographer with 4K camera',
        'Drone aerial shots',
        '500+ edited photos',
        '5-minute highlight video',
        'Photo album (30x40cm)',
        'Online gallery access',
      ],
    },
    {
      'packageId': 'pkg_photo_002',
      'serviceId': 'srv_photography',
      'packageName': 'Essential Photo Package',
      'vendorName': 'Click & Capture Studios',
      'description':
          'Essential photography coverage focusing on key moments with professional editing.',
      'price': 12000,
      'rating': 4.5,
      'reviewsCount': 95,
      'capacity': 0,
      'duration': 5,
      'location': {'city': 'Cairo', 'area': 'Dokki'},
      'includes': [
        '1 professional photographer',
        'Ceremony and reception coverage',
        '300+ edited photos',
        'Online gallery',
        'USB with all photos',
        'Photo prints (50 photos)',
      ],
    },
    {
      'packageId': 'pkg_photo_003',
      'serviceId': 'srv_photography',
      'packageName': 'Cinematic Video Package',
      'vendorName': 'Cinematic Weddings',
      'description':
          'Professional cinematic video coverage with storytelling approach and advanced editing.',
      'price': 25000,
      'rating': 4.9,
      'reviewsCount': 140,
      'capacity': 0,
      'duration': 8,
      'location': {'city': 'Cairo', 'area': 'New Cairo'},
      'includes': [
        '2 videographers',
        'Cinematic 4K filming',
        'Drone footage',
        'Same-day edit video',
        '10-15 minute highlight film',
        'Full ceremony video',
        'Blu-ray and USB delivery',
      ],
    },
    {
      'packageId': 'pkg_photo_004',
      'serviceId': 'srv_photography',
      'packageName': 'Pre-Wedding Photoshoot',
      'vendorName': 'Love Stories Photography',
      'description':
          'Romantic pre-wedding photoshoot at outdoor locations with professional styling.',
      'price': 8000,
      'rating': 4.6,
      'reviewsCount': 75,
      'capacity': 0,
      'duration': 3,
      'location': {'city': 'Cairo', 'area': 'Maadi'},
      'includes': [
        '1 photographer',
        '3-hour outdoor shoot',
        '2 location changes',
        '100+ edited photos',
        'Online gallery',
        'Photo prints',
      ],
    },

    // ========== DECORATION & FLOWERS PACKAGES ==========
    {
      'packageId': 'pkg_decor_001',
      'serviceId': 'srv_decoration',
      'packageName': 'Romantic Rose Garden Theme',
      'vendorName': 'Elegant Designs Co.',
      'description':
          'Stunning rose garden theme with fresh flowers, elegant draping, and romantic lighting.',
      'price': 25000,
      'rating': 4.7,
      'reviewsCount': 130,
      'capacity': 0,
      'duration': 0,
      'location': {'city': 'Cairo', 'area': 'Heliopolis'},
      'includes': [
        'Fresh rose arrangements',
        'Ceiling draping with fabric',
        'Fairy lights installation',
        'Stage backdrop design',
        'Table centerpieces',
        'Entrance decoration',
        'Bridal bouquet',
      ],
    },
    {
      'packageId': 'pkg_decor_002',
      'serviceId': 'srv_decoration',
      'packageName': 'Modern Luxury Theme',
      'vendorName': 'Contemporary Events Design',
      'description':
          'Sleek modern design with minimalist elegance, metallic accents, and sophisticated lighting.',
      'price': 30000,
      'rating': 4.8,
      'reviewsCount': 105,
      'capacity': 0,
      'duration': 0,
      'location': {'city': 'Cairo', 'area': 'New Cairo'},
      'includes': [
        'LED lighting system',
        'Modern furniture rental',
        'Metallic gold/silver accents',
        'Geometric installations',
        'Custom neon signs',
        'Photo booth setup',
        'Floral arrangements',
      ],
    },
    {
      'packageId': 'pkg_decor_003',
      'serviceId': 'srv_decoration',
      'packageName': 'Classic Elegance Package',
      'vendorName': 'Timeless Decorations',
      'description':
          'Traditional elegant decor with white and gold theme, perfect for classic weddings.',
      'price': 22000,
      'rating': 4.6,
      'reviewsCount': 118,
      'capacity': 0,
      'duration': 0,
      'location': {'city': 'Giza', 'area': 'Mohandessin'},
      'includes': [
        'White and gold theme',
        'Elegant table settings',
        'Chair covers and sashes',
        'Stage decoration',
        'Floral centerpieces',
        'Entrance archway',
      ],
    },
    {
      'packageId': 'pkg_decor_004',
      'serviceId': 'srv_decoration',
      'packageName': 'Rustic Garden Theme',
      'vendorName': 'Nature\'s Touch Decor',
      'description':
          'Charming rustic decor with natural elements, wooden accents, and wildflowers.',
      'price': 18000,
      'rating': 4.5,
      'reviewsCount': 92,
      'capacity': 0,
      'duration': 0,
      'location': {'city': 'Cairo', 'area': 'Maadi'},
      'includes': [
        'Wooden furniture rentals',
        'Wildflower arrangements',
        'Burlap and lace accents',
        'Mason jar centerpieces',
        'String lights',
        'Rustic signage',
      ],
    },

    // ========== MUSIC & ENTERTAINMENT PACKAGES ==========
    {
      'packageId': 'pkg_ent_001',
      'serviceId': 'srv_entertainment',
      'packageName': 'Premium DJ & MC Package',
      'vendorName': 'Party Vibes Entertainment',
      'description':
          'Professional DJ with complete sound system and charismatic MC to keep the energy high.',
      'price': 15000,
      'rating': 4.6,
      'reviewsCount': 140,
      'capacity': 0,
      'duration': 6,
      'location': {'city': 'Cairo', 'area': 'Nasr City'},
      'includes': [
        'Professional DJ',
        'Professional MC/Host',
        'Premium sound system',
        'Dance floor lighting',
        'Custom playlist creation',
        'Wireless microphones',
        'Backup equipment',
      ],
    },
    {
      'packageId': 'pkg_ent_002',
      'serviceId': 'srv_entertainment',
      'packageName': 'Live Band Performance',
      'vendorName': 'Harmony Live Music',
      'description':
          'Five-piece live band covering popular songs, traditional music, and taking requests.',
      'price': 25000,
      'rating': 4.9,
      'reviewsCount': 88,
      'capacity': 0,
      'duration': 4,
      'location': {'city': 'Cairo', 'area': 'Zamalek'},
      'includes': [
        '5-piece live band',
        'Professional singer',
        'Complete audio equipment',
        'Song requests available',
        'Background music during breaks',
        'Sound technician',
      ],
    },
    {
      'packageId': 'pkg_ent_003',
      'serviceId': 'srv_entertainment',
      'packageName': 'Traditional Zaffa Package',
      'vendorName': 'Heritage Entertainment',
      'description':
          'Authentic traditional zaffa with drummers, dancers, and traditional performers.',
      'price': 12000,
      'rating': 4.7,
      'reviewsCount': 115,
      'capacity': 0,
      'duration': 2,
      'location': {'city': 'Cairo', 'area': 'Nasr City'},
      'includes': [
        'Traditional drummers',
        'Professional dancers',
        'Traditional costumes',
        'LED props',
        'Fireworks display',
        'Traditional songs',
      ],
    },
    {
      'packageId': 'pkg_ent_004',
      'serviceId': 'srv_entertainment',
      'packageName': 'Kids Entertainment Package',
      'vendorName': 'Happy Kids Events',
      'description':
          'Fun entertainment for children including games, magic show, and face painting.',
      'price': 8000,
      'rating': 4.5,
      'reviewsCount': 95,
      'capacity': 0,
      'duration': 3,
      'location': {'city': 'Giza', 'area': 'Dokki'},
      'includes': [
        'Professional animator',
        'Magic show',
        'Face painting',
        'Balloon twisting',
        'Interactive games',
        'Kids music playlist',
      ],
    },

    // ========== WEDDING CAKE PACKAGES ==========
    {
      'packageId': 'pkg_cake_001',
      'serviceId': 'srv_cake',
      'packageName': 'Grand Tiered Wedding Cake',
      'vendorName': 'Sweet Dreams Bakery',
      'description':
          'Elegant 5-tier wedding cake with custom design, fondant decoration, and fresh flowers.',
      'price': 8000,
      'rating': 4.8,
      'reviewsCount': 125,
      'capacity': 300,
      'duration': 0,
      'location': {'city': 'Cairo', 'area': 'Nasr City'},
      'includes': [
        '5-tier cake (serves 300)',
        'Custom design consultation',
        'Fondant decoration',
        'Fresh flower decoration',
        'Cake stand rental',
        'Delivery and setup',
        'Cutting service',
      ],
    },
    {
      'packageId': 'pkg_cake_002',
      'serviceId': 'srv_cake',
      'packageName': 'Classic Elegance Cake',
      'vendorName': 'Royal Cakes',
      'description':
          'Beautiful 3-tier classic wedding cake with buttercream and elegant piping.',
      'price': 5000,
      'rating': 4.6,
      'reviewsCount': 98,
      'capacity': 200,
      'duration': 0,
      'location': {'city': 'Cairo', 'area': 'Heliopolis'},
      'includes': [
        '3-tier cake (serves 200)',
        'Buttercream frosting',
        'Elegant piping design',
        'Sugar flowers',
        'Delivery and setup',
        'Cake topper included',
      ],
    },
    {
      'packageId': 'pkg_cake_003',
      'serviceId': 'srv_cake',
      'packageName': 'Cupcake Tower Package',
      'vendorName': 'Cupcake Delight',
      'description':
          'Modern cupcake tower with assorted flavors and elegant presentation.',
      'price': 6000,
      'rating': 4.7,
      'reviewsCount': 110,
      'capacity': 250,
      'duration': 0,
      'location': {'city': 'Cairo', 'area': 'New Cairo'},
      'includes': [
        '250 assorted cupcakes',
        'Custom tower design',
        'Multiple flavors',
        'Fondant toppers',
        'Display stand rental',
        'Delivery and setup',
      ],
    },

    // ========== MAKEUP & HAIR PACKAGES ==========
    {
      'packageId': 'pkg_makeup_001',
      'serviceId': 'srv_makeup',
      'packageName': 'Bridal Glam Package',
      'vendorName': 'Glamour Beauty Studio',
      'description':
          'Complete bridal makeup and hair styling with trial session and on-site service.',
      'price': 7000,
      'rating': 4.8,
      'reviewsCount': 145,
      'capacity': 0,
      'duration': 4,
      'location': {'city': 'Cairo', 'area': 'Nasr City'},
      'includes': [
        'Bridal makeup (trial + wedding day)',
        'Bridal hairstyling',
        'Airbrush makeup',
        'False eyelashes',
        'Touch-up kit',
        'On-site service',
        'Assistant for help',
      ],
    },
    {
      'packageId': 'pkg_makeup_002',
      'serviceId': 'srv_makeup',
      'packageName': 'Bride & Bridesmaids Package',
      'vendorName': 'Beauty Squad',
      'description':
          'Makeup and hair for bride plus 5 bridesmaids with professional team.',
      'price': 12000,
      'rating': 4.7,
      'reviewsCount': 102,
      'capacity': 0,
      'duration': 5,
      'location': {'city': 'Cairo', 'area': 'Heliopolis'},
      'includes': [
        'Bridal makeup and hair',
        '5 bridesmaids makeup',
        '5 bridesmaids hairstyling',
        'Professional team',
        'On-site service',
        'Touch-up kits',
      ],
    },
  ];
}

// Filter Bottom Sheet (same as before with fix)
class _FilterBottomSheet extends StatefulWidget {
  final double minPrice;
  final double maxPrice;
  final String? selectedCity;
  final Function(double, double, String?) onApply;

  const _FilterBottomSheet({
    required this.minPrice,
    required this.maxPrice,
    this.selectedCity,
    required this.onApply,
  });

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  late RangeValues _priceRange;
  String? _selectedCity;
  final List<String> _cities = [
    'Cairo',
    'Alexandria',
    'Giza',
    'Mansoura',
    'Tanta',
  ];

  @override
  void initState() {
    super.initState();
    double minValue = widget.minPrice.clamp(0.0, 200000.0);
    double maxValue = widget.maxPrice.clamp(0.0, 200000.0);
    if (minValue >= maxValue) {
      minValue = 0;
      maxValue = 200000;
    }
    _priceRange = RangeValues(minValue, maxValue);
    _selectedCity = widget.selectedCity;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.blue200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    _priceRange = const RangeValues(0, 200000);
                    _selectedCity = null;
                  }),
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Price Range',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 200000,
                    divisions: 100,
                    activeColor: AppColors.primaryGold,
                    labels: RangeLabels(
                      '${_priceRange.start.toInt()}',
                      '${_priceRange.end.toInt()}',
                    ),
                    onChanged: (v) => setState(() => _priceRange = v),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_priceRange.start.toInt()} EGP',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${_priceRange.end.toInt()} EGP',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Location',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _cities.map((city) {
                      final isSelected = _selectedCity == city;
                      return FilterChip(
                        label: Text(city),
                        selected: isSelected,
                        onSelected: (s) =>
                            setState(() => _selectedCity = s ? city : null),
                        backgroundColor: AppColors.blue50,
                        selectedColor: AppColors.primaryGold.withOpacity(0.3),
                        checkmarkColor: AppColors.primaryGold,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApply(
                    _priceRange.start,
                    _priceRange.end,
                    _selectedCity,
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// lib/features/events/presentation/widgets/service_budget_tracker.dart

class ServiceBudgetTracker extends StatelessWidget {
  final String serviceName;
  final double allocated;
  final double spent;
  final double remaining;

  const ServiceBudgetTracker({
    super.key,
    required this.serviceName,
    required this.allocated,
    required this.spent,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    final percentageSpent = spent > 0 ? (spent / allocated * 100) : 0.0;
    final isOverBudget = spent > allocated;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGold.withOpacity(0.1),
            AppColors.primaryGold.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryGold.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: AppColors.primaryGold,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Budget Tracker',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Budget Items
          Row(
            children: [
              Expanded(
                child: _buildBudgetItem(
                  'Allocated',
                  allocated,
                  Icons.savings,
                  AppColors.info,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.primaryGold.withOpacity(0.3),
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
              Expanded(
                child: _buildBudgetItem(
                  'Spent',
                  spent,
                  Icons.shopping_bag,
                  isOverBudget ? AppColors.error : AppColors.success,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.primaryGold.withOpacity(0.3),
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
              Expanded(
                child: _buildBudgetItem(
                  'Remaining',
                  remaining,
                  Icons.account_balance,
                  remaining >= 0 ? AppColors.primaryGold : AppColors.error,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentageSpent / 100,
              minHeight: 8,
              backgroundColor: AppColors.blue100,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOverBudget ? AppColors.error : AppColors.primaryGold,
              ),
            ),
          ),

          const SizedBox(height: 4),

          // Percentage Text
          Text(
            '${percentageSpent.toStringAsFixed(1)}% of budget used',
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),

          // Warning Message
          if (isOverBudget)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.error,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Over budget! Consider a lower-priced package.',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBudgetItem(
    String label,
    double amount,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 2),
        Text(
          _formatCurrency(amount),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          'EGP',
          style: TextStyle(fontSize: 9, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}
// lib/features/events/presentation/widgets/package_card.dart

class PackageCard extends StatelessWidget {
  final Map<String, dynamic> package;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onViewDetails;

  const PackageCard({
    super.key,
    required this.package,
    required this.isSelected,
    required this.onSelect,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.success : AppColors.blue100,
          width: isSelected ? 2.5 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? AppColors.success.withOpacity(0.2)
                : AppColors.shadow,
            blurRadius: isSelected ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section (Placeholder)
          _buildImageSection(),

          // Content Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Package Name
                Text(
                  package['packageName'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Vendor Info
                Row(
                  children: [
                    const Icon(
                      Icons.store,
                      size: 14,
                      color: AppColors.primaryGold,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'by ${package['vendorName']}',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 2),
                    Text(
                      '${package['rating']}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      ' (${package['reviewsCount']})',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Price
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Package Price',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${package['price']} EGP',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Details Row
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    if (package['capacity'] > 0)
                      _buildDetailChip(
                        Icons.people,
                        '${package['capacity']} guests',
                      ),
                    if (package['duration'] > 0)
                      _buildDetailChip(
                        Icons.access_time,
                        '${package['duration']} hrs',
                      ),
                    _buildDetailChip(
                      Icons.location_on,
                      package['location']['area'],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Includes (First 3 items)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: (package['includes'] as List<String>)
                      .take(3)
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                size: 14,
                                color: AppColors.success,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),

                if ((package['includes'] as List).length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '+${(package['includes'] as List).length - 3} more',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary.withOpacity(0.7),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onViewDetails,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.info,
                          side: const BorderSide(color: AppColors.info),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'View Details',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onSelect,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? AppColors.success
                              : AppColors.primaryGold,
                          foregroundColor: AppColors.textLight,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isSelected) const Icon(Icons.check, size: 16),
                            if (isSelected) const SizedBox(width: 4),
                            Text(
                              isSelected ? 'Selected' : 'Select',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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

  /// Image Section (Placeholder)
  Widget _buildImageSection() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.blue50,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: Stack(
        children: [
          // Placeholder Image
          Center(child: Icon(Icons.image, size: 60, color: AppColors.blue200)),

          // Selected Badge
          if (isSelected)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: AppColors.textLight,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Selected',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Detail Chip
  Widget _buildDetailChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.blue50,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.info),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 11, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
