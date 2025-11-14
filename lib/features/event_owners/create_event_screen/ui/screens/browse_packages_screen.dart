// lib/features/events/presentation/screens/browse_packages_screen.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/event_owners/create_event_screen/cubits/create_event_cubit/create_event_cubit.dart';
import 'package:plan_z/features/event_owners/create_event_screen/cubits/create_event_cubit/create_event_state.dart';
import 'package:plan_z/features/event_owners/create_event_screen/cubits/event_creation_cubit/event_creation_cubit.dart';
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
        debugPrint('📦 [Init] Service: $serviceId, Current Package: $currentPackageId');
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
            final currentService = _getCurrentService();
            final currentPackageId = currentService?['currentPackageId'];
            
            setState(() {
              _allPackages = state.packages;
              _filteredPackages = state.packages;
              _isLoadingPackages = false;
              
              // ✅ في replacement mode، حفظ الـ current package كـ selected
              if (currentPackageId != null && currentPackageId.toString().isNotEmpty) {
                try {
                  final currentPackage = state.packages.firstWhere(
                    (p) => p.packageId == currentPackageId,
                  );
                  final serviceId = currentService!['serviceId'];
                  _selectedPackages[serviceId] = currentPackage;
                  debugPrint('✅ [GetPackagesByServiceSuccess] Selected current package: ${currentPackage.packageName}');
                } catch (e) {
                  debugPrint('❌ [GetPackagesByServiceSuccess] Current package not found: $e');
                }
              }
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
            : _BrowsePackagesContent(
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
                onSortChanged: (value) => setState(() {
                  _sortBy = value!;
                  _applyFilters();
                }),
                onApplyFilters: _applyFilters,
              ),
      ),
    );
  }


 // ✅ اكتب:
void _selectPackage(PackageModel package) {
  final serviceId = _getCurrentService()!['serviceId'];
  debugPrint('📦 [_selectPackage] Selected: $serviceId -> ${package.packageName} (${package.price})');
  
  setState(() {
    _selectedPackages[serviceId] = package; // ✅ خزّن الـ Object كاملة
    debugPrint('   Total selected packages now: ${_selectedPackages.length}');
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
  debugPrint('🎯 [_finishSelection] Starting...');
  debugPrint('   Total selected packages: ${_selectedPackages.length}');
  _selectedPackages.forEach((serviceId, package) {
    debugPrint('   ✅ $serviceId -> ${package.packageName} (${package.price})');
  });
  
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
    // ✅ في replacement mode، نرجع الـ package للـ EventPackagesScreen
    // والـ EventPackagesScreen بتستدعي replacePackage من الـ Cubit
    // والـ Cubit بتتحدث في Firestore وترجع ReplacePackageSuccess
    // والـ EventPackagesScreen بتنتظر النتيجة وتعيد load البيانات
    debugPrint('🔄 [_finishSelection] Replacement Mode - Returning package');
    Navigator.pop(context, {
      'package': selectedPackage,
      'serviceId': serviceId,
      'isReplacement': true,
    });
  } else {
    // Normal Flow: Save ALL Selected Packages & Navigate to EventReviewScreen
    debugPrint('📤 [_finishSelection] Normal Mode - Navigating to EventReviewScreen with ${_selectedPackages.length} packages');
    
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

  /// Show Package Details - Professional Dialog
  void _showPackageDetails(PackageModel package) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.zero,
                children: [
                  // ✅ Header with Image/Icon
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryDark,
                          AppColors.primaryDark.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Background Icon
                        Center(
                          child: Icon(
                            Icons.business_center,
                            size: 100,
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        // Close Button
                        Positioned(
                          top: 12,
                          right: 12,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        // Package Info Overlay
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, -5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  package.packageName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'by ${package.vendorName}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // ✅ Content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Price & Rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Price',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'EGP ${_formatNumber(package.price.toInt())}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryGold,
                                  ),
                                ),
                                Text(
                                  package.priceUnit,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Rating',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${package.rating ?? 0}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${package.reviewCount} reviews',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        
                        // Description
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          package.description,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        
                        if (package.features.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                          
                          // Features
                          const Text(
                            'Features Included',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...package.features.map((feature) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Icon(
                                    Icons.check_circle,
                                    size: 14,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    feature,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textPrimary,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                        
                        const SizedBox(height: 16),
                        
                        // Stats
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryDark.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '${package.bookingCount}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryGold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Bookings',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    '${package.reviewCount}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryGold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Reviews',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
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
        _ServiceHeaderWidget(
          service: currentService,
        ),

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
                'Service ${currentServiceIndex + 1} of $totalServices',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${(((currentServiceIndex + 1) / totalServices * 100).toInt())}% Complete',
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
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGold),
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

  const _ServiceHeaderWidget({
    required this.service,
  });

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
            child: const Icon(Icons.business_center, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['serviceName'] ?? 'Service',
                  style: const TextStyle(
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
              child: const Text(
                'Required',
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
            label: 'Selected',
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

  const _BudgetItemWidget({
    required this.label,
    required this.amount,
  });

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
          'EGP ${_formatNumberStatic(amount.toInt())}',
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
              items: const [
                DropdownMenuItem(value: 'price_low', child: Text('Price: Low to High')),
                DropdownMenuItem(value: 'price_high', child: Text('Price: High to Low')),
                DropdownMenuItem(value: 'rating', child: Text('Highest Rating')),
                DropdownMenuItem(value: 'popular', child: Text('Most Popular')),
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
                      'by ${package.vendorName}',
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
                          'EGP ${_formatNumberStatic(package.price.toInt())}',
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
                      child: const Text(
                        'Details',
                        style: TextStyle(fontSize: 10),
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
            const Text(
              'No packages found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Try adjusting your filters'),
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
                child: const Text('Skip (Optional)'),
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
}

/// Static Helper Function
String _formatNumberStatic(int number) {
  return number.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
}
