


import 'package:flutter/material.dart';
import 'package:plan_z/features/event_owners/create_event_screen/ui/widgets/package_card_widget.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_model.dart';

/// Packages List Widget
class PackagesListWidget extends StatelessWidget {
  final List<PackageModel> filteredPackages;
  final Map<String, dynamic> currentService;
  final Map<String, PackageModel> selectedPackages;
  final Function(PackageModel) onSelectPackage;
  final Function(PackageModel) onShowPackageDetails;

  const PackagesListWidget({
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

        return PackageCardWidget(
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

