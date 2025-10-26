// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:plan_z/core/theming/text_stayls.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_text_form.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_model.dart';

class PackagesScreen extends StatelessWidget {
  final List<PackageModel> packages;

  const PackagesScreen({super.key, required this.packages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Manage Packages',
          style: AppTextStyles.title.copyWith(
            color: AppColors.primaryDark,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primaryDark,
        centerTitle: true,
        elevation: 1,
        toolbarHeight: 60,
      ),
      body: packages.isEmpty
          ? const _EmptyPackagesWidget()
          : _PackagesListWidget(packages: packages),
      floatingActionButton: const _AddPackageFloatingButton(),
    );
  }
}

class _EmptyPackagesWidget extends StatelessWidget {
  const _EmptyPackagesWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeInUp(
        duration: const Duration(milliseconds: 800),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryGold.withOpacity(0.1),
                      AppColors.blue100.withOpacity(0.3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  color: AppColors.primaryGold,
                  size: 70.0,
                ),
              ),
              const SizedBox(height: 32.0),
              Text(
                'No Packages Available',
                style: AppTextStyles.headline3.copyWith(
                  fontSize: 22,
                  color: AppColors.primaryDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12.0),
              Text(
                'Create your first package to get started\nwith managing your services',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40.0),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGold.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showAddPackageDialog(context);
                  },
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: const Text('Add Package'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGold,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 16.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddPackageDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const EnhancedPackageDialog(
        isEditing: false,
        onSave: _handleSavePackage,
      ),
    );
  }

  static void _handleSavePackage(PackageModel package) {
    // Handle save logic
    print('Added package: ${package.name}');
  }
}

class _PackagesListWidget extends StatelessWidget {
  final List<PackageModel> packages;

  const _PackagesListWidget({required this.packages});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Packages',
                  style: AppTextStyles.headline3.copyWith(
                    fontSize: 20,
                    color: AppColors.primaryDark,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blue50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primaryGold.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    '${packages.length} packages',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                  final childAspectRatio = constraints.maxWidth > 600
                      ? 0.85
                      : 0.78;

                  return GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: childAspectRatio,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: packages.length,
                    itemBuilder: (context, index) {
                      return _PackageCard(package: packages[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  final PackageModel package;

  const _PackageCard({required this.package});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: Duration(
        milliseconds: 300 + (package.packageId.hashCode % 10) * 80,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _showEditPackageDialog(context, package),
            borderRadius: BorderRadius.circular(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 110.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getPackageColor(package.type),
                        _getPackageColor(package.type).withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -20,
                        top: -20,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Center(
                        child: Icon(
                          _getPackageIcon(package.type),
                          color: AppColors.textLight,
                          size: 45.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                package.name,
                                style: AppTextStyles.title.copyWith(
                                  fontSize: 16,
                                  color: AppColors.primaryDark,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(package.status),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text(
                                package.status,
                                style: AppTextStyles.overline.copyWith(
                                  color: AppColors.textLight,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          package.type,
                          style: AppTextStyles.caption.copyWith(
                            color: _getPackageColor(package.type),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Expanded(
                          child: Text(
                            package.description,
                            style: AppTextStyles.body.copyWith(
                              fontSize: 13,
                              height: 1.3,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          package.price,
                          style: AppTextStyles.price.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditPackageDialog(BuildContext context, PackageModel package) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => EnhancedPackageDialog(
        isEditing: true,
        package: package,
        onSave: (updatedPackage) {
          print('Updated package: ${updatedPackage.name}');
        },
      ),
    );
  }

  Color _getPackageColor(String type) {
    switch (type.toLowerCase()) {
      case 'catering':
        return AppColors.gold400;
      case 'photography':
        return AppColors.blue500;
      case 'decoration':
        return AppColors.accentPurple;
      case 'transportation':
        return AppColors.accentGreen;
      default:
        return AppColors.primaryGold;
    }
  }

  IconData _getPackageIcon(String type) {
    switch (type.toLowerCase()) {
      case 'catering':
        return Icons.restaurant_rounded;
      case 'photography':
        return Icons.camera_alt_rounded;
      case 'decoration':
        return Icons.palette_rounded;
      case 'transportation':
        return Icons.local_shipping_rounded;
      default:
        return Icons.card_giftcard_rounded;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.accentGreen;
      case 'pending':
        return AppColors.warning;
      case 'inactive':
        return AppColors.error;
      default:
        return AppColors.blue400;
    }
  }
}

class _AddPackageFloatingButton extends StatelessWidget {
  const _AddPackageFloatingButton();

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1000),
      delay: const Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGold.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            _showAddPackageDialog(context);
          },
          backgroundColor: AppColors.primaryGold,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.add_rounded, size: 28.0),
        ),
      ),
    );
  }

  void _showAddPackageDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const EnhancedPackageDialog(
        isEditing: false,
        onSave: _handleSavePackage,
      ),
    );
  }

  static void _handleSavePackage(PackageModel package) {
    print('Added package: ${package.name}');
  }
}

// Enhanced Dialog
class EnhancedPackageDialog extends StatelessWidget {
  final bool isEditing;
  final PackageModel? package;
  final Function(PackageModel) onSave;
  

  const EnhancedPackageDialog({
    super.key,
    required this.isEditing,
    this.package,
    required this.onSave,
    
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20.0),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          maxWidth: 450,
        ),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowDark,
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _EnhancedDialogHeader(isEditing: isEditing),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: EnhancedPackageForm(
                  isEditing: isEditing,
                  package: package,
                  onSave: onSave,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EnhancedDialogHeader extends StatelessWidget {
  final bool isEditing;

  const _EnhancedDialogHeader({required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.blue700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isEditing ? Icons.edit_rounded : Icons.add_box_rounded,
              color: AppColors.textLight,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Edit Package' : 'Add New Package',
                  style: AppTextStyles.title.copyWith(
                    color: AppColors.textLight,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isEditing
                      ? 'Update package information'
                      : 'Create a new service package',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textLight.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.textLight,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Enhanced Form (يمكن تطويره أكثر حسب الحاجة)
class EnhancedPackageForm extends StatefulWidget {
  final bool isEditing;
  final PackageModel? package;
  final Function(PackageModel) onSave;

  const EnhancedPackageForm({
    super.key,
    required this.isEditing,
    this.package,
    required this.onSave,
  });

  @override
  State<EnhancedPackageForm> createState() => _EnhancedPackageFormState();
}

class _EnhancedPackageFormState extends State<EnhancedPackageForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  String _selectedType = 'Catering';
  String _selectedStatus = 'Active';

  final List<String> _statusOptions = ['Active', 'Pending', 'Inactive'];
  final List<String> _typeOptions = [
    'Catering',
    'Photography',
    'Decoration',
    'Transportation',
    'Entertainment',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.package != null) {
      _nameController.text = widget.package!.name;
      _descriptionController.text = widget.package!.description;
      _priceController.text = widget.package!.price;
      _selectedType = widget.package!.type;
      _selectedStatus = widget.package!.status;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _savePackage() {
    if (_formKey.currentState!.validate()) {
      final package = PackageModel(
        packageId: widget.isEditing
            ? widget.package!.packageId
            : DateTime.now().toString(),
            
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: _priceController.text.trim(),
        type: _selectedType,
        status: _selectedStatus,
      );

      widget.onSave(package);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Package Name
          FadeInLeft(
            duration: const Duration(milliseconds: 500),
            child: _buildFormField(
              label: 'Package Name',
              child: AppTextField(
                hintText: 'Enter package name',
                controller: _nameController,
                prefixIcon: Icon(
                  Icons.inventory_2_outlined,
                  color: AppColors.blue400,
                  size: 22,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter package name';
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(height: 20.0),

          // Package Type
          FadeInLeft(
            duration: const Duration(milliseconds: 600),
            child: _buildEnhancedDropdown(
              label: 'Package Type',
              value: _selectedType,
              options: _typeOptions,
              onChanged: (value) => setState(() => _selectedType = value!),
              icon: Icons.category_outlined,
            ),
          ),
          const SizedBox(height: 20.0),

          // Description
          FadeInLeft(
            duration: const Duration(milliseconds: 700),
            child: _buildFormField(
              label: 'Description',
              child: AppTextField(
                hintText: 'Enter package description',
                controller: _descriptionController,
                maxLines: 3,
                prefixIcon: Icon(
                  Icons.description_outlined,
                  color: AppColors.blue400,
                  size: 22,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(height: 20.0),

          // Price
          FadeInLeft(
            duration: const Duration(milliseconds: 800),
            child: _buildFormField(
              label: 'Price',
              child: AppTextField(
                hintText: 'Enter price (e.g., \$500)',
                controller: _priceController,
                keyboardType: TextInputType.number,
                prefixIcon: Icon(
                  Icons.payments_outlined,
                  color: AppColors.blue400,
                  size: 22,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter price';
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(height: 20.0),

          // Status
          FadeInLeft(
            duration: const Duration(milliseconds: 900),
            child: _buildEnhancedDropdown(
              label: 'Status',
              value: _selectedStatus,
              options: _statusOptions,
              onChanged: (value) => setState(() => _selectedStatus = value!),
              icon: Icons.flag_outlined,
            ),
          ),
          const SizedBox(height: 32.0),

          // Action Buttons
          FadeInUp(
            duration: const Duration(milliseconds: 1000),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightGray,
                      foregroundColor: AppColors.textSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGold.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _savePackage,
                      icon: Icon(
                        widget.isEditing
                            ? Icons.update_rounded
                            : Icons.add_rounded,
                        size: 20,
                      ),
                      label: Text(
                        widget.isEditing ? 'Update Package' : 'Add Package',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGold,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
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

  Widget _buildFormField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildEnhancedDropdown({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    return _buildFormField(
      label: label,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.blue200),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.blue400, size: 22),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          style: AppTextStyles.body,
          dropdownColor: Colors.white,
          items: options.map((String option) {
            return DropdownMenuItem<String>(value: option, child: Text(option));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
