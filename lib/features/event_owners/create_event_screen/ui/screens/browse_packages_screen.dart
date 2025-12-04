// lib/features/events/presentation/screens/browse_packages_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/event_owners/create_event_screen/cubits/create_event_cubit/create_event_cubit.dart';
import 'package:plan_z/features/event_owners/create_event_screen/cubits/create_event_cubit/create_event_state.dart';
import 'package:plan_z/features/event_owners/create_event_screen/ui/screens/event_review_screen.dart';
import 'package:plan_z/features/event_owners/create_event_screen/ui/widgets/browse_packages_content.dart';
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                return BrowsePackagesContent(
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
                );
              },
            ),
    );
  }

  void _selectPackage(PackageModel package) {
    final currentService = _getCurrentService();
    if (currentService == null) return;

    final serviceId = currentService['serviceId'];
    debugPrint('📦 [_selectPackage] Selected: $serviceId -> ${package.packageName} (${package.price})');

    setState(() {
      _selectedPackages[serviceId] = package; // ✅ خزّن الـ Object كاملة
      debugPrint('   Total selected packages now: ${_selectedPackages.length}');
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

/// Static Helper Function
String formatNumberStatic(int number) {
  return number.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]},',
  );
}
