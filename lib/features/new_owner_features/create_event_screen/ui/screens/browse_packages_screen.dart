// lib/features/events/presentation/screens/browse_packages_screen.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/cubits/create_event_cubit/create_event_cubit.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/cubits/create_event_cubit/create_event_state.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/cubits/event_creation_cubit/event_creation_cubit.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/event_review_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_model.dart';

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
  // Current service navigation
  int _currentServiceIndex = 0;
  
  // Selected packages: serviceId → packageId
  final Map<String, PackageModel> _selectedPackages = {}; 
  // All packages data for current service
  List<PackageModel> _allPackages = [];
  List<PackageModel> _filteredPackages = [];
  
  // Filter & Sort
  String _sortBy = 'price_low';
  double _minPrice = 0;
  double _maxPrice = 200000;
  
  // Loading state
  bool _isLoadingPackages = false;

  @override
  void initState() {
    super.initState();
    _loadPackagesForCurrentService();
  }

  /// Load Packages for Current Service
  void _loadPackagesForCurrentService() {
    final currentService = _getCurrentService();
    if (currentService == null) return;

    final serviceId = currentService['serviceId'];

    // استدعاء getPackagesByService من EventOwnerCubit
    setState(() => _isLoadingPackages = true);
    
    context.read<EventOwnerCubit>().getPackagesByService(
          serviceId: serviceId,
          onlyActive: true,
        );
  }

  /// Get Current Service
  Map<String, dynamic>? _getCurrentService() {
    final services = widget.servicesData['selectedServices'] as List;
    if (_currentServiceIndex >= services.length) return null;
    return services[_currentServiceIndex];
  }

  /// Get Allocated Budget for Current Service
  double _getAllocatedBudget() {
    final currentService = _getCurrentService();
    if (currentService == null) return 0;

    final percentage = currentService['suggestedBudgetPercentage'] ?? 0;
    return (widget.budgetData['totalBudget'] * percentage / 100);
  }

 
  @override
  Widget build(BuildContext context) {
    final currentService = _getCurrentService();
    final services = widget.servicesData['selectedServices'] as List;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          currentService != null
              ? 'Select ${currentService['serviceName']}'
              : 'Browse Packages',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: BlocListener<EventOwnerCubit, EventOwnerState>(
        listener: (context, state) {
          if (state is GetPackagesByServiceSuccess) {
            setState(() {
              _allPackages = state.packages;
              _filteredPackages = state.packages;
              _isLoadingPackages = false;
            });
            _applyFilters();
          } else if (state is GetPackagesByServiceError) {
            setState(() => _isLoadingPackages = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: currentService == null
            ? const Center(child: Text('No services available'))
            : Column(
                children: [
                  // Progress Indicator
                  _buildProgressIndicator(services.length),

                  // Service Header
                  _buildServiceHeader(currentService),

                  // Budget Summary
                  _buildBudgetSummary(),

                  // Filter & Sort Bar
                  _buildFilterBar(),

                  // Packages List
                  Expanded(
                    child: _isLoadingPackages
                        ? const Center(child: CircularProgressIndicator())
                        : _filteredPackages.isEmpty
                            ? _buildEmptyState()
                            : _buildPackagesList(),
                  ),

                  // Navigation Buttons
                  _buildNavigationButtons(services.length),
                ],
              ),
      ),
    );
  }

  /// Progress Indicator
  Widget _buildProgressIndicator(int totalServices) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.cardBackground,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Service ${_currentServiceIndex + 1} of $totalServices',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${((_currentServiceIndex + 1) / totalServices * 100).toInt()}% Complete',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_currentServiceIndex + 1) / totalServices,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGold),
          ),
        ],
      ),
    );
  }

  /// Service Header
  Widget _buildServiceHeader(Map<String, dynamic> service) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.primaryDark.withOpacity(0.1),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryGold,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.business_center, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['serviceName'] ?? 'Service',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  service['description'] ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (service['required'] == true)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Required',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Budget Summary
  Widget _buildBudgetSummary() {
    final allocatedBudget = _getAllocatedBudget();
    final selectedPackageId = _selectedPackages[_getCurrentService()!['serviceId']];
    final selectedPackage = selectedPackageId != null
        ? _allPackages.firstWhere(
            (p) => p.packageId == selectedPackageId,
            orElse: () => _allPackages.first,
          )
        : null;
    final spentAmount = selectedPackage?.price ?? 0;
    final remaining = allocatedBudget - spentAmount;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryDark,
            AppColors.primaryDark.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBudgetItem('Allocated', allocatedBudget),
          _buildBudgetItem('Selected', spentAmount),
          _buildBudgetItem(
            'Remaining',
            remaining,
            isNegative: remaining < 0,
          ),
        ],
      ),
    );
  }

  /// Budget Item
  Widget _buildBudgetItem(String label, double amount, {bool isNegative = false}) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          'EGP ${_formatNumber(amount.toInt())}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isNegative ? Colors.red : Colors.white,
          ),
        ),
      ],
    );
  }

  /// Filter Bar
  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.cardBackground,
      child: Row(
        children: [
          // Sort Dropdown
          Expanded(
            child: DropdownButton<String>(
              value: _sortBy,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'price_low', child: Text('Price: Low to High')),
                DropdownMenuItem(value: 'price_high', child: Text('Price: High to Low')),
                DropdownMenuItem(value: 'rating', child: Text('Highest Rating')),
                DropdownMenuItem(value: 'popular', child: Text('Most Popular')),
              ],
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                  _applyFilters();
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          // Filter Button
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
    );
  }

  /// Packages List
  Widget _buildPackagesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredPackages.length,
      itemBuilder: (context, index) {
        final package = _filteredPackages[index];
        final isSelected = _selectedPackages[_getCurrentService()!['serviceId']] == package.packageId;
        
        return _buildPackageCard(package, isSelected);
      },
    );
  }

  /// Package Card
  Widget _buildPackageCard(PackageModel package, bool isSelected) {
    return GestureDetector(
      onTap: () => _selectPackage(package),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryGold : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with selection indicator
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryGold.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          package.packageName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'by ${package.vendorName}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGold,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),

            // Package Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price
                  Row(
                    children: [
                      Text(
                        'EGP ${_formatNumber(package.price.toInt())}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        package.priceUnit,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Rating & Stats
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${package.rating ?? 0} (${package.reviewCount} reviews)',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
                      Text(
                        '${package.bookingCount} bookings',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Text(
                    package.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Features
                  if (package.features.isNotEmpty) ...[
                    const Text(
                      'Features:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...package.features.take(3).map((feature) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle,
                                  size: 16, color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  feature,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],

                  // View Details Button
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => _showPackageDetails(package),
                    child: const Text('View Full Details →'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Empty State
  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No packages found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Try adjusting your filters'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _minPrice = 0;
                  _maxPrice = 200000;
                  // _selectedCity = null;
                  _sortBy = 'price_low';
                  _applyFilters();
                });
              },
              child: const Text('Reset Filters'),
            ),
          ],
        ),
      ),
    );
  }

  /// Navigation Buttons
  Widget _buildNavigationButtons(int totalServices) {
    final currentService = _getCurrentService();
    final isLastService = _currentServiceIndex == totalServices - 1;
    final canSkip = currentService?['required'] != true;
    final hasSelected = _selectedPackages.containsKey(currentService?['serviceId']);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Skip Button (for optional services)
          if (canSkip)
            Expanded(
              child: OutlinedButton(
                onPressed: _skipService,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.primaryGold),
                ),
                child: const Text('Skip (Optional)'),
              ),
            ),
          if (canSkip) const SizedBox(width: 12),

          // Next/Finish Button
          Expanded(
            flex: canSkip ? 1 : 2,
            child: ElevatedButton(
              onPressed: hasSelected
                  ? (isLastService ? _finishSelection : _nextService)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGold,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                isLastService ? 'Finish Selection' : 'Next Service →',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

 // ✅ اكتب:
void _selectPackage(PackageModel package) {
  setState(() {
    _selectedPackages[_getCurrentService()!['serviceId']] = package; // ✅ خزّن الـ Object كاملة
  });
}

  /// Skip Service
  void _skipService() {
    final serviceId = _getCurrentService()!['serviceId'];
    _selectedPackages.remove(serviceId);
    _nextService();
  }

  /// Next Service
  void _nextService() {
    setState(() {
      _currentServiceIndex++;
      _isLoadingPackages = true;
    });
    _loadPackagesForCurrentService();
  }

 /// ✅ Finish Selection - معدّل
void _finishSelection() {
  // ❌ البداية كانت غلط:
  // final selectedPackageId = _selectedPackages[currentService!['serviceId']];
  // final selectedPackage = _allPackages.firstWhere((p) => p.packageId == selectedPackageId);
  
  // ✅ الطريقة الصحيحة الآن:
  final currentService = _getCurrentService();
  if (currentService == null) return;

  final serviceId = currentService['serviceId'];
  
  // ✅ الـ selectedPackages خزّن الـ PackageModel Objects مباشرة!
  final selectedPackage = _selectedPackages[serviceId] as PackageModel?;
  
  if (selectedPackage == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('❌ Please select a package')),
    );
    return;
  }

  // ✅ Check if Replacement Mode
  final isReplacement = currentService['isReplacement'] == true;
  
  if (isReplacement) {
    // ✅ Return package للـ Previous Screen
    Navigator.pop(context, {
      'package': selectedPackage,
      'serviceId': serviceId,
    });
  } else {
    // Normal Flow: Save ALL Selected Packages & Navigate to EventReviewScreen
    
    // ✅ محفوظ في Cubit أيضاً (optional - للـ persistence)
    context.read<EventCreationCubit>().setSelectedPackages(
      selectedPackages: _selectedPackages, // ✅ كل الـ Packages مع Objects كاملة
    );
  
    // ✅ Navigator مع البيانات الصحيحة
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventReviewScreen(
          eventInfo: widget.eventInfo,
          budgetData: widget.budgetData,
          servicesData: widget.servicesData,
          selectedPackages: _selectedPackages, // ✅ Map<String, PackageModel> - كل الـ Packages!
        ),
      ),
    );
  }
}

  /// Apply Filters
  void _applyFilters() {
    setState(() {
      _filteredPackages = List.from(_allPackages);

      // Filter by price range
      _filteredPackages = _filteredPackages
          .where((p) => p.price >= _minPrice && p.price <= _maxPrice)
          .toList();

      // // Filter by city
      // if (_selectedCity != null && _selectedCity!.isNotEmpty) {
      //   _filteredPackages = _filteredPackages
      //       .where((p) => p.?.toLowerCase() == _selectedCity!.toLowerCase())
      //       .toList();
      // }

      // Sort
      switch (_sortBy) {
        case 'price_low':
          _filteredPackages.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'price_high':
          _filteredPackages.sort((a, b) => b.price.compareTo(a.price));
          break;
        case 'rating':
          _filteredPackages.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
          break;
        case 'popular':
          _filteredPackages.sort((a, b) => b.bookingCount.compareTo(a.bookingCount));
          break;
      }
    });
  }

  /// Show Filter Dialog
  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Price Range
                  Text('Price Range: EGP ${_minPrice.toInt()} - ${_maxPrice.toInt()}'),
                  RangeSlider(
                    values: RangeValues(_minPrice, _maxPrice),
                    min: 0,
                    max: 200000,
                    divisions: 100,
                    onChanged: (values) {
                      setModalState(() {
                        _minPrice = values.start;
                        _maxPrice = values.end;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  // Apply Button
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _applyFilters();
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGold,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Apply Filters'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Show Package Details
  void _showPackageDetails(PackageModel package) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: ListView(
                controller: scrollController,
                children: [
                  Text(
                    package.packageName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('by ${package.vendorName}'),
                  const Divider(height: 32),
                  Text('Description:', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(package.description),
                  const SizedBox(height: 16),
                  Text('Features:', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...package.features.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.check, size: 16),
                            const SizedBox(width: 8),
                            Expanded(child: Text(f)),
                          ],
                        ),
                      )),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Format Number
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
