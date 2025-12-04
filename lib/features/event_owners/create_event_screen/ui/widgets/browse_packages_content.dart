
import 'package:flutter/material.dart';
import 'package:plan_z/features/event_owners/create_event_screen/ui/widgets/browse_packages_empty_state.dart';
import 'package:plan_z/features/event_owners/create_event_screen/ui/widgets/budget_summry_widget.dart';
import 'package:plan_z/features/event_owners/create_event_screen/ui/widgets/filtter_bar_widget.dart';
import 'package:plan_z/features/event_owners/create_event_screen/ui/widgets/navigation_botton_widget.dart';
import 'package:plan_z/features/event_owners/create_event_screen/ui/widgets/packages_list_widgets.dart';
import 'package:plan_z/features/event_owners/create_event_screen/ui/widgets/progress_indicator_widget.dart';
import 'package:plan_z/features/event_owners/create_event_screen/ui/widgets/service_header_widget.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_model.dart';

class BrowsePackagesContent extends StatelessWidget {
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

  const BrowsePackagesContent({
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
        ProgressIndicatorWidget(
          currentServiceIndex: currentServiceIndex,
          totalServices: services.length,
        ),

        // Service Header
        ServiceHeaderWidget(
          service: currentService,
        ),

        // Budget Summary
        BudgetSummaryWidget(
          currentService: currentService,
          allPackages: allPackages,
          selectedPackages: selectedPackages,
        ),

        // Filter & Sort Bar
        FilterBarWidget(
          sortBy: sortBy,
          onSortChanged: onSortChanged,
          onShowFilterDialog: onShowFilterDialog,
        ),

        // Packages List
        Expanded(
          child: isLoadingPackages
              ? const Center(child: CircularProgressIndicator())
              : filteredPackages.isEmpty
                  ? const BrowsePackagesEmptyStateWidget()
                  : PackagesListWidget(
                      filteredPackages: filteredPackages,
                      currentService: currentService,
                      selectedPackages: selectedPackages,
                      onSelectPackage: onSelectPackage,
                      onShowPackageDetails: onShowPackageDetails,
                    ),
        ),

        // Navigation Buttons
        NavigationButtonsWidget(
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

