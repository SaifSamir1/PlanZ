// lib/features/vendor_features/packages_mangment/presentation/widgets/package_basic_info_section.dart

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/core/services/json_service.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/auth/data/models/user_manager.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/cubit/vendor_cubit.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/cubit/vendor_state.dart';
import 'package:easy_localization/easy_localization.dart';

class CreatePackageScreen extends StatefulWidget {
  final bool isEdit;
  final PackageModel? package;

  const CreatePackageScreen({super.key, this.isEdit = false, this.package});

  @override
  State<CreatePackageScreen> createState() => _CreatePackageScreenState();
}

class _CreatePackageScreenState extends State<CreatePackageScreen> {
  // Form Key
  final _formKey = GlobalKey<FormState>();

  // Controllers (Single Language)
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;

  // State Variables
  List<Map<String, dynamic>> _availableServices = [];
  Map<String, dynamic>? _selectedService;
  String _selectedCurrency = 'EGP';
  String _selectedPriceUnit = 'per_event';
  List<String> _features = [];
  List<String> _keywords = [];
  List<String> _suggestedKeywords = [];
  List<PortfolioItem> _portfolioLinks = [];
  bool _isLoadingServices = true;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadServices();
    _loadPackageData();
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
  }

  Future<void> _loadServices() async {
    try {
      final services = await JsonService.getAllServices();
      setState(() {
        _availableServices = services;
        _isLoadingServices = false;
      });
    } catch (e) {
      setState(() => _isLoadingServices = false);
      _showErrorSnackBar('vendor.packages.failed_load_services'.tr());
    }
  }

  void _loadPackageData() {
    if (widget.isEdit && widget.package != null) {
      final package = widget.package!;
      _nameController.text = package.packageName;
      _descriptionController.text = package.description;
      _priceController.text = package.price.toString();
      _selectedCurrency = package.currency;
      _selectedPriceUnit = package.priceUnit;
      _features = List<String>.from(package.features);
      _keywords = List<String>.from(package.keywords);
      _portfolioLinks = List<PortfolioItem>.from(package.portfolioLinks);

      // Load selected service
      if (_availableServices.isNotEmpty) {
        _selectedService = _availableServices.firstWhere(
          (s) => s['serviceId'] == package.serviceId,
          orElse: () => {},
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _onServiceSelected(Map<String, dynamic> service) async {
    setState(() {
      _selectedService = service;
    });

    // Load suggested keywords from service
    if (service['keywords'] != null) {
      final keywords = (service['keywords'] as List)
          .map((k) => k.toString())
          .toList();
      setState(() {
        _suggestedKeywords = keywords;
      });
    }
  }

  void _submitPackage() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedService == null) {
      _showErrorSnackBar('vendor.packages.select_service_required'.tr());
      return;
    }

    if (_features.isEmpty) {
      _showErrorSnackBar('vendor.packages.add_feature_required'.tr());
      return;
    }

    if (_keywords.isEmpty) {
      _showErrorSnackBar('vendor.packages.add_keyword_required'.tr());
      return;
    }

    final userManager = UserManager();

    if (widget.isEdit && widget.package != null) {
      // Update Package
      context.read<VendorCubit>().updatePackage(
        packageId: widget.package!.packageId,
        packageName: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        features: _features,
        keywords: _keywords,
        portfolioLinks: _portfolioLinks,
      );
    } else {
      // Create Package
      context.read<VendorCubit>().createPackage(
        vendorId: userManager.userId!,
        vendorName: userManager.userName!,
        serviceId: _selectedService!['serviceId'],
        serviceName: _selectedService!['serviceName'],
        packageName: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        currency: _selectedCurrency,
        priceUnit: _selectedPriceUnit,
        features: _features,
        keywords: _keywords,
        portfolioLinks: _portfolioLinks,
      );
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: widget.isEdit
            ? 'vendor.packages.edit_package'.tr()
            : 'vendor.packages.create_package'.tr(),
      ),
      body: BlocListener<VendorCubit, VendorState>(
        listener: (context, state) {
          if (state is CreatePackageSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('vendor.packages.package_created_success'.tr()),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is CreatePackageError) {
            _showErrorSnackBar(state.message);
          } else if (state is UpdatePackageSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('vendor.packages.package_updated_success'.tr()),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is UpdatePackageError) {
            _showErrorSnackBar(state.message);
          }
        },
        child: _isLoadingServices
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Basic Info Section
                    PackageBasicInfoSection(
                      nameController: _nameController,
                      descriptionController: _descriptionController,
                      formKey: _formKey,
                    ),

                    const SizedBox(height: 16),

                    // Service Selector
                    ServiceSelectorSection(
                      services: _availableServices,
                      selectedService: _selectedService,
                      onServiceSelected: _onServiceSelected,
                    ),

                    const SizedBox(height: 16),

                    // Pricing
                    PricingSection(
                      priceController: _priceController,
                      selectedCurrency: _selectedCurrency,
                      selectedPriceUnit: _selectedPriceUnit,
                      onCurrencyChanged: (currency) {
                        setState(() => _selectedCurrency = currency);
                      },
                      onPriceUnitChanged: (unit) {
                        setState(() => _selectedPriceUnit = unit);
                      },
                    ),

                    const SizedBox(height: 16),

                    // Features
                    FeaturesSection(
                      features: _features,
                      onFeaturesChanged: (features) {
                        setState(() => _features = features);
                      },
                    ),

                    const SizedBox(height: 16),

                    // Keywords
                    KeywordsSection(
                      keywords: _keywords,
                      suggestedKeywords: _suggestedKeywords,
                      onKeywordsChanged: (keywords) {
                        setState(() => _keywords = keywords);
                      },
                    ),

                    const SizedBox(height: 16),

                    // Portfolio
                    PortfolioSection(
                      portfolioLinks: _portfolioLinks,
                      onPortfolioChanged: (links) {
                        setState(() => _portfolioLinks = links);
                      },
                    ),

                    const SizedBox(height: 32),

                    // Submit Button
                    _buildSubmitButton(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<VendorCubit, VendorState>(
      builder: (context, state) {
        final isLoading =
            state is CreatePackageLoading || state is UpdatePackageLoading;

        return FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: isLoading ? null : _submitPackage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGold,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: isLoading ? 0 : 4,
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      widget.isEdit
                          ? 'vendor.packages.update_package'.tr()
                          : 'vendor.packages.create_package'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

class PackageBasicInfoSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final GlobalKey<FormState> formKey;

  const PackageBasicInfoSection({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 500),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppColors.primaryDark.withOpacity(0.08),
                AppColors.primaryDark.withOpacity(0.008),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(),
              const SizedBox(height: 20),
              _buildNameField(),
              const SizedBox(height: 16),
              _buildDescriptionField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryGold.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.info_outline,
            color: AppColors.primaryGold,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '📝  ${'vendor.packages.basic_information'.tr()}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: nameController,
      decoration: InputDecoration(
        labelText: 'vendor.packages.package_name'.tr(),
        hintText: 'vendor.packages.package_name_hint'.tr(),
        prefixIcon: Icon(Icons.card_giftcard, color: AppColors.primaryGold),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryGold, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'vendor.packages.package_name_required'.tr();
        }
        if (value.trim().length < 3) {
          return 'vendor.packages.package_name_min'.tr();
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: descriptionController,
      maxLines: 4,
      decoration: InputDecoration(
        labelText: 'vendor.packages.description'.tr(),
        hintText: 'vendor.packages.description_hint'.tr(),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: Icon(Icons.description, color: AppColors.primaryGold),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryGold, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'vendor.packages.description_required'.tr();
        }
        if (value.trim().length < 20) {
          return 'vendor.packages.description_min'.tr();
        }
        return null;
      },
    );
  }
}

class ServiceSelectorSection extends StatelessWidget {
  final List<Map<String, dynamic>> services;
  final Map<String, dynamic>? selectedService;
  final Function(Map<String, dynamic>) onServiceSelected;

  const ServiceSelectorSection({
    super.key,
    required this.services,
    required this.selectedService,
    required this.onServiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 100),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppColors.primaryDark.withOpacity(0.08),
                AppColors.primaryDark.withOpacity(0.008),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(),
              const SizedBox(height: 20),
              _buildServiceDropdown(context),
              if (selectedService != null) ...[
                const SizedBox(height: 16),
                _buildServicePreview(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryGold.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.category, color: AppColors.primaryGold, size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          'vendor.packages.service_category'.tr(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceDropdown(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGold.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text('vendor.packages.service_category'.tr()),
          value: selectedService?['serviceId'],
          icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryGold),
          items: services.map((service) {
            return DropdownMenuItem<String>(
              value: service['serviceId'],
              child: Row(
                children: [
                  _buildServiceIcon(service['icon']),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      service['serviceName'] ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            final service = services.firstWhere((s) => s['serviceId'] == value);
            onServiceSelected(service);
          },
        ),
      ),
    );
  }

  Widget _buildServiceIcon(dynamic icon) {
    if (icon == null) return const SizedBox.shrink();

    final iconStr = icon.toString();

    if (iconStr.startsWith('assets/')) {
      return Image.asset(
        iconStr,
        width: 32,
        height: 32,
        errorBuilder: (_, __, ___) => const Icon(Icons.category, size: 32),
      );
    }

    return Text(iconStr, style: const TextStyle(fontSize: 28));
  }

  Widget _buildServicePreview() {
    return FadeIn(
      duration: const Duration(milliseconds: 400),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryGold.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primaryGold.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildServiceIcon(selectedService!['icon']),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedService!['serviceName'] ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (selectedService!['description'] != null)
                        Text(
                          selectedService!['description'],
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (selectedService!['keywords'] != null) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (selectedService!['keywords'] as List).take(5).map((
                  keyword,
                ) {
                  return Chip(
                    label: Text(
                      keyword.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: AppColors.primaryGold),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class FeaturesSection extends StatefulWidget {
  final List<String> features;
  final Function(List<String>) onFeaturesChanged;

  const FeaturesSection({
    super.key,
    required this.features,
    required this.onFeaturesChanged,
  });

  @override
  State<FeaturesSection> createState() => _FeaturesSectionState();
}

class _FeaturesSectionState extends State<FeaturesSection> {
  final TextEditingController _featureController = TextEditingController();

  @override
  void dispose() {
    _featureController.dispose();
    super.dispose();
  }

  void _addFeature() {
    final feature = _featureController.text.trim();
    if (feature.isNotEmpty && !widget.features.contains(feature)) {
      final updatedFeatures = [...widget.features, feature];
      widget.onFeaturesChanged(updatedFeatures);
      _featureController.clear();
    }
  }

  void _removeFeature(int index) {
    final updatedFeatures = [...widget.features];
    updatedFeatures.removeAt(index);
    widget.onFeaturesChanged(updatedFeatures);
  }

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 800),
      delay: const Duration(milliseconds: 300),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppColors.primaryDark.withOpacity(0.08),
                AppColors.primaryDark.withOpacity(0.008),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(),
              const SizedBox(height: 20),
              _buildAddFeatureField(),
              const SizedBox(height: 16),
              _buildFeaturesList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryGold.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.stars, color: AppColors.primaryGold, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'vendor.packages.features'.tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryGold.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${widget.features.length}',
            style: TextStyle(
              color: AppColors.primaryGold,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddFeatureField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _featureController,
            decoration: InputDecoration(
              hintText: 'vendor.packages.add_feature'.tr(),
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(
                Icons.add_circle_outline,
                color: AppColors.primaryGold,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primaryGold, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            onSubmitted: (_) => _addFeature(),
          ),
        ),
        const SizedBox(width: 12),
        Material(
          color: AppColors.primaryGold,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: _addFeature,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: const Icon(Icons.add, color: Colors.white, size: 24),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesList() {
    if (widget.features.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.inbox, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                'vendor.packages.no_features_yet'.tr(),
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: widget.features.asMap().entries.map((entry) {
        final index = entry.key;
        final feature = entry.value;

        return FadeInLeft(
          key: ValueKey(feature),
          duration: const Duration(milliseconds: 300),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryGold.withOpacity(0.2)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              leading: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              title: Text(
                feature,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 22,
                ),
                onPressed: () => _removeFeature(index),
                tooltip: 'vendor.packages.remove_feature_tooltip'.tr(),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class KeywordsSection extends StatefulWidget {
  final List<String> keywords;
  final List<String> suggestedKeywords;
  final Function(List<String>) onKeywordsChanged;

  const KeywordsSection({
    super.key,
    required this.keywords,
    required this.suggestedKeywords,
    required this.onKeywordsChanged,
  });

  @override
  State<KeywordsSection> createState() => _KeywordsSectionState();
}

class _KeywordsSectionState extends State<KeywordsSection> {
  final TextEditingController _keywordController = TextEditingController();

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  void _addKeyword(String keyword) {
    final trimmedKeyword = keyword.trim().toLowerCase();

    if (trimmedKeyword.isEmpty) {
      _showError('vendor.packages.keyword_empty_error'.tr());
      return;
    }

    if (trimmedKeyword.length < 2) {
      _showError('vendor.packages.keyword_min_error'.tr());
      return;
    }

    if (widget.keywords.map((k) => k.toLowerCase()).contains(trimmedKeyword)) {
      _showError('vendor.packages.keyword_exists_error'.tr());
      return;
    }

    final updatedKeywords = [...widget.keywords, trimmedKeyword];
    widget.onKeywordsChanged(updatedKeywords);
    _keywordController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'vendor.packages.keyword_added_success'.tr(args: [trimmedKeyword]),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _removeKeyword(String keyword) {
    final updatedKeywords = [...widget.keywords];
    updatedKeywords.remove(keyword);
    widget.onKeywordsChanged(updatedKeywords);
  }

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 900),
      delay: const Duration(milliseconds: 400),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppColors.primaryDark.withOpacity(0.08),
                AppColors.primaryDark.withOpacity(0.008),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(),
              const SizedBox(height: 20),
              _buildAddKeywordField(),
              if (widget.suggestedKeywords.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildSuggestedKeywords(),
              ],
              const SizedBox(height: 16),
              _buildSelectedKeywords(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryGold.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.local_offer,
            color: AppColors.primaryGold,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'vendor.packages.search_keywords_title'.tr(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        if (widget.keywords.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${widget.keywords.length}',
              style: TextStyle(
                color: AppColors.primaryGold,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAddKeywordField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _keywordController,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: 'vendor.packages.add_keyword_hint_text'.tr(),
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(Icons.search, color: AppColors.primaryGold),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primaryGold, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            onSubmitted: _addKeyword,
          ),
        ),
        const SizedBox(width: 12),
        Material(
          color: AppColors.primaryGold,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () => _addKeyword(_keywordController.text.trim()),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: const Icon(Icons.add, color: Colors.white, size: 24),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestedKeywords() {
    final unselectedSuggestions = widget.suggestedKeywords
        .where(
          (keyword) => !widget.keywords
              .map((k) => k.toLowerCase())
              .contains(keyword.toLowerCase()),
        )
        .toList();

    if (unselectedSuggestions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'vendor.packages.suggested_keywords_label'.tr(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: unselectedSuggestions.map((keyword) {
            return GestureDetector(
              onTap: () => _addKeyword(keyword),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold.withOpacity(0.08),
                  border: Border.all(
                    color: AppColors.primaryGold.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      size: 16,
                      color: AppColors.primaryGold,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      keyword,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSelectedKeywords() {
    if (widget.keywords.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.label_off, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                'vendor.packages.no_keywords_yet'.tr(),
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                'vendor.packages.keywords_help_text'.tr(),
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'vendor.packages.added_keywords_label'.tr(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.keywords.map((keyword) {
            return FadeIn(
              key: ValueKey(keyword),
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGold.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      keyword,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => _removeKeyword(keyword),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class PortfolioSection extends StatefulWidget {
  final List<PortfolioItem> portfolioLinks;
  final Function(List<PortfolioItem>) onPortfolioChanged;

  const PortfolioSection({
    super.key,
    required this.portfolioLinks,
    required this.onPortfolioChanged,
  });

  @override
  State<PortfolioSection> createState() => _PortfolioSectionState();
}

class _PortfolioSectionState extends State<PortfolioSection> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  String _selectedType = 'website';

  @override
  void dispose() {
    _urlController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _addPortfolioLink() {
    final url = _urlController.text.trim();
    final title = _titleController.text.trim();

    if (url.isEmpty) {
      _showError('vendor.packages.enter_url_error'.tr());
      return;
    }

    // Validate URL
    final uri = Uri.tryParse(url);
    if (uri == null ||
        !uri.hasAbsolutePath ||
        (!uri.scheme.startsWith('http'))) {
      _showError('vendor.packages.valid_url_error'.tr());
      return;
    }

    final link = PortfolioItem(
      url: url,
      type: _selectedType,
      thumbnail: title.isNotEmpty ? title : null,
    );

    final updatedLinks = [...widget.portfolioLinks, link];
    widget.onPortfolioChanged(updatedLinks);

    _urlController.clear();
    _titleController.clear();
    setState(() => _selectedType = 'website');

    // Show success
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('vendor.packages.proof_added_success'.tr()),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _removePortfolioLink(int index) {
    final updatedLinks = [...widget.portfolioLinks];
    updatedLinks.removeAt(index);
    widget.onPortfolioChanged(updatedLinks);
  }

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 1000),
      delay: const Duration(milliseconds: 500),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppColors.primaryDark.withOpacity(0.08),
                AppColors.primaryDark.withOpacity(0.008),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(),
              const SizedBox(height: 16),
              _buildInfoText(),
              const SizedBox(height: 20),
              _buildUrlField(),
              const SizedBox(height: 12),
              _buildTitleField(),
              const SizedBox(height: 12),
              _buildTypeSelector(),
              const SizedBox(height: 16),
              _buildAddButton(),
              const SizedBox(height: 16),
              _buildPortfolioList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryGold.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.verified, color: AppColors.primaryGold, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            '✓ ${'vendor.packages.work_proof'.tr()}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        if (widget.portfolioLinks.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${widget.portfolioLinks.length}',
              style: TextStyle(
                color: AppColors.primaryGold,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoText() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'vendor.packages.work_proof_info'.tr(),
              style: TextStyle(
                fontSize: 13,
                color: Colors.blue[900],
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUrlField() {
    return TextField(
      controller: _urlController,
      keyboardType: TextInputType.url,
      decoration: InputDecoration(
        labelText: '${'vendor.packages.work_proof_link'.tr()}*',
        hintText: 'vendor.packages.work_proof_url_hint'.tr(),
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(Icons.link, color: AppColors.primaryGold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryGold, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText:
            '${'vendor.packages.work_proof_title'.tr()} ${'vendor.packages.work_proof_title_optional'.tr()}',
        hintText: 'vendor.packages.work_proof_title_hint'.tr(),
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(Icons.description, color: AppColors.primaryGold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryGold, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    final types = [
      {
        'value': 'website',
        'label': 'vendor.packages.type_website'.tr(),
        'icon': Icons.language,
      },
      {
        'value': 'image',
        'label': 'vendor.packages.type_image'.tr(),
        'icon': Icons.image,
      },
      {
        'value': 'video',
        'label': 'vendor.packages.type_video'.tr(),
        'icon': Icons.video_library,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'vendor.packages.content_type_label'.tr(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: types.map((type) {
            final isSelected = _selectedType == type['value'];
            return GestureDetector(
              onTap: () =>
                  setState(() => _selectedType = type['value'] as String),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryGold : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryGold
                        : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      type['icon'] as IconData,
                      size: 18,
                      color: isSelected ? Colors.white : Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      type['label'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _addPortfolioLink,
        icon: const Icon(Icons.add, size: 20),
        label: Text(
          '${'vendor.packages.add_proof_link'.tr()}',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGold,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  Widget _buildPortfolioList() {
    if (widget.portfolioLinks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.link_off, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                '${'vendor.packages.no_proof_links_yet'.tr()}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                '${'vendor.packages.add_links_to_showcase_your_work'.tr()}',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: widget.portfolioLinks.asMap().entries.map((entry) {
        final index = entry.key;
        final link = entry.value;

        return FadeInLeft(
          key: ValueKey(link.url),
          duration: const Duration(milliseconds: 300),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryGold.withOpacity(0.2)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _getTypeIcon(link.type),
              ),
              title: Text(
                link.thumbnail ??
                    'vendor.packages.proof_link_default'.tr(
                      args: [(index + 1).toString()],
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                link.url,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 22,
                ),
                onPressed: () => _removePortfolioLink(index),
                tooltip: 'Remove link',
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Icon _getTypeIcon(String type) {
    Color iconColor = AppColors.primaryGold;

    switch (type) {
      case 'image':
        return Icon(Icons.image, color: iconColor, size: 24);
      case 'video':
        return Icon(Icons.video_library, color: iconColor, size: 24);
      default:
        return Icon(Icons.language, color: iconColor, size: 24);
    }
  }
}

class PricingSection extends StatelessWidget {
  final TextEditingController priceController;
  final String selectedCurrency;
  final String selectedPriceUnit;
  final Function(String) onCurrencyChanged;
  final Function(String) onPriceUnitChanged;

  const PricingSection({
    super.key,
    required this.priceController,
    required this.selectedCurrency,
    required this.selectedPriceUnit,
    required this.onCurrencyChanged,
    required this.onPriceUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 700),
      delay: const Duration(milliseconds: 200),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppColors.primaryDark.withOpacity(0.08),
                AppColors.primaryDark.withOpacity(0.008),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(flex: 2, child: _buildPriceField()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildCurrencyDropdown()),
                ],
              ),
              const SizedBox(height: 16),
              _buildPriceUnitSelector(),
              const SizedBox(height: 16),
              _buildPricePreview(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryGold.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.attach_money,
            color: AppColors.primaryGold,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            '💰 ${'vendor.packages.pricing'.tr()}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      controller: priceController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: '${'vendor.packages.price'.tr()}',
        hintText: '0',
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(Icons.monetization_on, color: AppColors.primaryGold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryGold, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '${'vendor.packages.enter_price'.tr()}';
        }
        final price = double.tryParse(value);
        if (price == null || price <= 0) {
          return '${'vendor.packages.invalid_price'.tr()}';
        }
        return null;
      },
    );
  }

  Widget _buildCurrencyDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCurrency,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryGold),
          items: ['EGP', 'USD', 'EUR', 'SAR'].map((currency) {
            return DropdownMenuItem(
              value: currency,
              child: Text(
                currency,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) => onCurrencyChanged(value ?? 'EGP'),
        ),
      ),
    );
  }

  Widget _buildPriceUnitSelector() {
    final units = [
      {
        'value': 'per_event',
        'label': '${'vendor.packages.per_event'.tr()}',
        'icon': Icons.event,
      },
      {
        'value': 'per_hour',
        'label': '${'vendor.packages.per_hour'.tr()}',
        'icon': Icons.access_time,
      },
      {
        'value': 'per_day',
        'label': '${'vendor.packages.per_day'.tr()}',
        'icon': Icons.today,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${'vendor.packages.price_unit'.tr()}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: units.map((unit) {
            final isSelected = selectedPriceUnit == unit['value'];
            return GestureDetector(
              onTap: () => onPriceUnitChanged(unit['value'] as String),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryGold : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryGold
                        : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      unit['icon'] as IconData,
                      size: 18,
                      color: isSelected ? Colors.white : Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      unit['label'] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPricePreview() {
    final price = double.tryParse(priceController.text) ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryGold.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGold.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${'vendor.packages.total_price'.tr()}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '$selectedCurrency ${_formatPrice(price)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryGold,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _formatUnit(selectedPriceUnit),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    return price
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  String _formatUnit(String unit) {
    switch (unit) {
      case 'per_event':
        return 'vendor.packages.unit_event'.tr();
      case 'per_hour':
        return 'vendor.packages.unit_hour'.tr();
      case 'per_day':
        return 'vendor.packages.unit_day'.tr();
      default:
        return 'vendor.packages.unit_event'.tr();
    }
  }
}
