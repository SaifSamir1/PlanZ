// lib/features/events/presentation/screens/browse_packages_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/event_owners/create_event_screen/cubits/create_event_cubit/create_event_cubit.dart';
import 'package:plan_z/features/event_owners/create_event_screen/cubits/create_event_cubit/create_event_state.dart';

import 'package:plan_z/features/event_owners/create_event_screen/ui/screens/event_review_screen.dart';
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
    _initializeSelectedPackages();
    _loadPackagesForCurrentService();
  }

  /// ✅ Initialize selected packages from servicesData
  void _initializeSelectedPackages() {
    final services = widget.servicesData['selectedServices'] as List;
    for (var service in services) {
      final serviceId = service['serviceId'];
      final currentPackageId = service['currentPackageId'];

      // ✅ في replacement mode، نحفظ الـ current package كـ selected في البداية
      // حتى يظهر كـ selected عند الدخول للصفحة
      if (currentPackageId != null && currentPackageId.toString().isNotEmpty) {
        debugPrint(
          '📦 [Init] Service: $serviceId, Current Package: $currentPackageId',
        );
        // سيتم تحديثه لاحقاً عندما يتم تحميل الـ packages من الـ API
        // ونعرف الـ PackageModel الكاملة
      }
    }
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

  @override
  Widget build(BuildContext context) {
    final currentService = _getCurrentService();
    final services = widget.servicesData['selectedServices'] as List;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        title: Text(
          'browse_packages.title'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: currentService == null
          ? const Center(child: CircularProgressIndicator())
          : BlocConsumer<EventOwnerCubit, EventOwnerState>(
              listener: (context, state) {
                if (state is GetPackagesByServiceSuccess) {
                  setState(() {
                    _allPackages = state.packages;
                    _filteredPackages = state.packages;
                    _isLoadingPackages = false;
                    _applyFilters();
                  });
                } else if (state is GetPackagesByServiceError) {
                  setState(() => _isLoadingPackages = false);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                return _BrowsePackagesContent(
                  currentService: currentService,
                  services: services,
                  isLoadingPackages: _isLoadingPackages,
                  filteredPackages: _filteredPackages,
                  allPackages: _allPackages,
                  selectedPackages: _selectedPackages,
                  sortBy: _sortBy,
                  minPrice: _minPrice,
                  maxPrice: _maxPrice,
                  currentServiceIndex: _currentServiceIndex,
                  onSelectPackage: _selectPackage,
                  onShowFilterDialog: _showFilterDialog,
                  onShowPackageDetails: _showPackageDetails,
                  onSkipService: _skipService,
                  onNextService: _nextService,
                  onFinishSelection: _finishSelection,
                  onSortChanged: _onSortChanged,
                  onApplyFilters: _applyFilters,
                );
              },
            ),
    );
  }

  void _selectPackage(PackageModel package) {
    final currentService = _getCurrentService();
    if (currentService == null) return;

    final serviceId = currentService['serviceId'];
    setState(() {
      if (_selectedPackages[serviceId]?.packageId == package.packageId) {
        _selectedPackages.remove(serviceId);
      } else {
        _selectedPackages[serviceId] = package;
      }
    });
  }

  void _skipService() {
    _nextService();
  }

  void _nextService() {
    final services = widget.servicesData['selectedServices'] as List;
    if (_currentServiceIndex < services.length - 1) {
      setState(() {
        _currentServiceIndex++;
        _loadPackagesForCurrentService();
      });
    }
  }

  void _finishSelection() {
    // Navigate to Event Review Screen
    // We need to pass the selected packages and other data
    // For now, let's just print or navigate

    // Construct the final data
    final Map<String, dynamic> finalSelection = {};
    _selectedPackages.forEach((serviceId, package) {
      finalSelection[serviceId] = package;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventReviewScreen(
          eventInfo: widget.eventInfo,
          budgetData: widget.budgetData,
          servicesData: widget.servicesData,
          selectedPackages: _selectedPackages,
        ),
      ),
    );
  }

  void _onSortChanged(String? value) {
    if (value != null) {
      setState(() {
        _sortBy = value;
        _applyFilters();
      });
    }
  }

  void _applyFilters() {
    List<PackageModel> temp = List.from(_allPackages);

    // Filter by price
    temp = temp
        .where((p) => p.price >= _minPrice && p.price <= _maxPrice)
        .toList();

    // Sort
    switch (_sortBy) {
      case 'price_low':
        temp.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        temp.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        // Assuming rating is available, otherwise ignore
        // temp.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'popular':
        // Assuming popularity metric
        break;
    }

    setState(() {
      _filteredPackages = temp;
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'browse_packages.try_adjusting_filters'.tr(),
        ), // Using existing key for now or generic "Filter"
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Price Range: EGP ${_minPrice.toInt()} - EGP ${_maxPrice.toInt()}',
            ),
            RangeSlider(
              values: RangeValues(_minPrice, _maxPrice),
              min: 0,
              max: 500000, // Adjust max as needed
              divisions: 100,
              labels: RangeLabels(
                _minPrice.toInt().toString(),
                _maxPrice.toInt().toString(),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _minPrice = values.start;
                  _maxPrice = values.end;
                });
                // Note: In a real dialog, we might want to use a stateful builder for the slider
                // or update the parent state only on "Apply".
                // For simplicity here, we update parent state directly but it won't rebuild dialog content
                // unless we use StatefulBuilder.
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('attendee.cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              _applyFilters();
              Navigator.pop(context);
            },
            child: Text(
              'admin_access.access'.tr(),
            ), // Using "Access" as "Apply" or similar
          ),
        ],
      ),
    );
  }

  void _showPackageDetails(PackageModel package) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              package.packageName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'browse_packages.by_vendor'.tr(args: [package.vendorName]),
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 30),
            Text(package.description, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _selectPackage(package);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGold,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  _selectedPackages.values.any(
                        (p) => p.packageId == package.packageId,
                      )
                      ? 'browse_packages.selected'.tr()
                      : 'Select Package',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================
/// Stateless Widgets
/// ============================================

/// Main Content Widget
class _BrowsePackagesContent extends StatelessWidget {
  final Map<String, dynamic> currentService;
  final List<dynamic> services;
  final bool isLoadingPackages;
  final List<PackageModel> filteredPackages;
  final List<PackageModel> allPackages;
  final Map<String, PackageModel> selectedPackages;
  final String sortBy;
  final double minPrice;
  final double maxPrice;
  final int currentServiceIndex;
  final Function(PackageModel) onSelectPackage;
  final VoidCallback onShowFilterDialog;
  final Function(PackageModel) onShowPackageDetails;
  final VoidCallback onSkipService;
  final VoidCallback onNextService;
  final VoidCallback onFinishSelection;
  final Function(String?) onSortChanged;
  final VoidCallback onApplyFilters;

  const _BrowsePackagesContent({
    required this.currentService,
    required this.services,
    required this.isLoadingPackages,
    required this.filteredPackages,
    required this.allPackages,
    required this.selectedPackages,
    required this.sortBy,
    required this.minPrice,
    required this.maxPrice,
    required this.currentServiceIndex,
    required this.onSelectPackage,
    required this.onShowFilterDialog,
    required this.onShowPackageDetails,
    required this.onSkipService,
    required this.onNextService,
    required this.onFinishSelection,
    required this.onSortChanged,
    required this.onApplyFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Progress Indicator
        _ProgressIndicatorWidget(
          currentServiceIndex: currentServiceIndex,
          totalServices: services.length,
        ),

        // Service Header
        _ServiceHeaderWidget(service: currentService),

        // Budget Summary
        _BudgetSummaryWidget(
          currentService: currentService,
          allPackages: allPackages,
          selectedPackages: selectedPackages,
        ),

        // Filter & Sort Bar
        _FilterBarWidget(
          sortBy: sortBy,
          onSortChanged: onSortChanged,
          onShowFilterDialog: onShowFilterDialog,
        ),

        // Packages List
        Expanded(
          child: isLoadingPackages
              ? const Center(child: CircularProgressIndicator())
              : filteredPackages.isEmpty
              ? const _EmptyStateWidget()
              : _PackagesListWidget(
                  filteredPackages: filteredPackages,
                  currentService: currentService,
                  selectedPackages: selectedPackages,
                  onSelectPackage: onSelectPackage,
                  onShowPackageDetails: onShowPackageDetails,
                ),
        ),

        // Navigation Buttons
        _NavigationButtonsWidget(
          currentServiceIndex: currentServiceIndex,
          totalServices: services.length,
          currentService: currentService,
          selectedPackages: selectedPackages,
          onSkipService: onSkipService,
          onNextService: onNextService,
          onFinishSelection: onFinishSelection,
        ),
      ],
    );
  }
}

/// Progress Indicator Widget
class _ProgressIndicatorWidget extends StatelessWidget {
  final int currentServiceIndex;
  final int totalServices;

  const _ProgressIndicatorWidget({
    required this.currentServiceIndex,
    required this.totalServices,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.cardBackground,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'browse_packages.service_x_of_y'.tr(
                  args: [
                    (currentServiceIndex + 1).toString(),
                    totalServices.toString(),
                  ],
                ),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'browse_packages.percent_complete'.tr(
                  args: [
                    (((currentServiceIndex + 1) / totalServices * 100).toInt())
                        .toString(),
                  ],
                ),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: (currentServiceIndex + 1) / totalServices,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.primaryGold,
            ),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}

/// Service Header Widget
class _ServiceHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> service;

  const _ServiceHeaderWidget({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.primaryDark.withOpacity(0.1),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryGold,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.business_center,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['serviceName'] ?? 'attendee.services'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                if ((service['description'] ?? '').isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    service['description'] ?? '',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
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
              child: Text(
                'browse_packages.required'.tr(),
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Budget Summary Widget
class _BudgetSummaryWidget extends StatelessWidget {
  final Map<String, dynamic> currentService;
  final List<PackageModel> allPackages;
  final Map<String, PackageModel> selectedPackages;

  const _BudgetSummaryWidget({
    required this.currentService,
    required this.allPackages,
    required this.selectedPackages,
  });

  @override
  Widget build(BuildContext context) {
    final currentServiceId = currentService['serviceId'];
    final selectedPackage = selectedPackages[currentServiceId];
    final spentAmount = selectedPackage?.price ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          _BudgetItemWidget(
            label: 'browse_packages.selected'.tr(),
            amount: spentAmount,
          ),
        ],
      ),
    );
  }
}

/// Budget Item Widget
class _BudgetItemWidget extends StatelessWidget {
  final String label;
  final double amount;

  const _BudgetItemWidget({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
        const SizedBox(height: 3),
        Text(
          'browse_packages.currency_egp'.tr(
            args: [_formatNumberStatic(amount.toInt())],
          ),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

/// Filter Bar Widget
class _FilterBarWidget extends StatelessWidget {
  final String sortBy;
  final Function(String?) onSortChanged;
  final VoidCallback onShowFilterDialog;

  const _FilterBarWidget({
    required this.sortBy,
    required this.onSortChanged,
    required this.onShowFilterDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: AppColors.cardBackground,
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              value: sortBy,
              isExpanded: true,
              isDense: true,
              items: [
                DropdownMenuItem(
                  value: 'price_low',
                  child: Text('browse_packages.price_low_high'.tr()),
                ),
                DropdownMenuItem(
                  value: 'price_high',
                  child: Text('browse_packages.price_high_low'.tr()),
                ),
                DropdownMenuItem(
                  value: 'rating',
                  child: Text('browse_packages.highest_rating'.tr()),
                ),
                DropdownMenuItem(
                  value: 'popular',
                  child: Text('browse_packages.most_popular'.tr()),
                ),
              ],
              onChanged: onSortChanged,
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.filter_list, size: 20),
            onPressed: onShowFilterDialog,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }
}

/// Packages List Widget
class _PackagesListWidget extends StatelessWidget {
  final List<PackageModel> filteredPackages;
  final Map<String, dynamic> currentService;
  final Map<String, PackageModel> selectedPackages;
  final Function(PackageModel) onSelectPackage;
  final Function(PackageModel) onShowPackageDetails;

  const _PackagesListWidget({
    required this.filteredPackages,
    required this.currentService,
    required this.selectedPackages,
    required this.onSelectPackage,
    required this.onShowPackageDetails,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: filteredPackages.length,
      itemBuilder: (context, index) {
        final package = filteredPackages[index];
        final currentServiceId = currentService['serviceId'];

        final selectedPackage = selectedPackages[currentServiceId];
        // ✅ فقط تحقق من selectedPackages
        // في replacement mode، currentPackageId بتُستخدم فقط في البداية
        final isSelected = selectedPackage?.packageId == package.packageId;

        return _PackageCardWidget(
          key: ValueKey(package.packageId),
          package: package,
          isSelected: isSelected,
          onTap: () => onSelectPackage(package),
          onDetailsPressed: () => onShowPackageDetails(package),
        );
      },
    );
  }
}

/// Package Card Widget
class _PackageCardWidget extends StatelessWidget {
  final PackageModel package;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDetailsPressed;

  const _PackageCardWidget({
    super.key,
    required this.package,
    required this.isSelected,
    required this.onTap,
    required this.onDetailsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primaryGold : Colors.grey.shade300,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primaryGold.withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.packageName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'browse_packages.by_vendor'.tr(
                        args: [package.vendorName],
                      ),
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'browse_packages.currency_egp'.tr(
                            args: [_formatNumberStatic(package.price.toInt())],
                          ),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          package.priceUnit,
                          style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryGold,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    )
                  else
                    const SizedBox(width: 26, height: 26),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 28,
                    child: TextButton(
                      onPressed: onDetailsPressed,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: const Size(0, 28),
                      ),
                      child: Text(
                        'browse_packages.details'.tr(),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Empty State Widget
class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'browse_packages.no_packages_found'.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('browse_packages.try_adjusting_filters'.tr()),
          ],
        ),
      ),
    );
  }
}

/// Navigation Buttons Widget
class _NavigationButtonsWidget extends StatelessWidget {
  final int currentServiceIndex;
  final int totalServices;
  final Map<String, dynamic> currentService;
  final Map<String, PackageModel> selectedPackages;
  final VoidCallback onSkipService;
  final VoidCallback onNextService;
  final VoidCallback onFinishSelection;

  const _NavigationButtonsWidget({
    required this.currentServiceIndex,
    required this.totalServices,
    required this.currentService,
    required this.selectedPackages,
    required this.onSkipService,
    required this.onNextService,
    required this.onFinishSelection,
  });

  @override
  Widget build(BuildContext context) {
    final isLastService = currentServiceIndex == totalServices - 1;
    final canSkip = currentService['required'] != true;
    final currentServiceId = currentService['serviceId'];
    // ✅ فقط تحقق من selectedPackages
    // في replacement mode، currentPackageId بتُستخدم فقط في البداية
    final hasSelected = selectedPackages.containsKey(currentServiceId);

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
          if (canSkip)
            Expanded(
              child: OutlinedButton(
                onPressed: onSkipService,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.primaryGold),
                ),
                child: Text('browse_packages.skip_optional'.tr()),
              ),
            ),
          if (canSkip) const SizedBox(width: 12),
          Expanded(
            flex: canSkip ? 1 : 2,
            child: ElevatedButton(
              onPressed: hasSelected
                  ? (isLastService ? onFinishSelection : onNextService)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGold,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                isLastService
                    ? 'browse_packages.finish_selection'.tr()
                    : 'browse_packages.next_service'.tr(),
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
}

/// Static Helper Function
String _formatNumberStatic(int number) {
  return number.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]},',
  );
}
