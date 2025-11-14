// lib/features/events/presentation/screens/services_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/event_owners/create_event_screen/cubits/event_creation_cubit/event_creation_cubit.dart';
import 'package:plan_z/features/event_owners/create_event_screen/ui/screens/browse_packages_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/core/services/json_service.dart';

class ServicesSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> eventInfo;
  final Map<String, dynamic> budgetData;

  const ServicesSelectionScreen({
    super.key,
    required this.eventInfo,
    required this.budgetData,
  });

  @override
  State<ServicesSelectionScreen> createState() =>
      _ServicesSelectionScreenState();
}

class _ServicesSelectionScreenState extends State<ServicesSelectionScreen> {
  // Services Lists
  List<Map<String, dynamic>> _requiredServices = [];
  List<Map<String, dynamic>> _optionalServices = [];

  // Selected Optional Services IDs
  final Set<String> _selectedOptionalServicesIds = {};

  // Budget tracking
  late double _totalBudget;
  double _allocatedBudget = 0;
  double _remainingBudget = 0;

  // Loading state
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _totalBudget = widget.budgetData['totalBudget'];
    _remainingBudget = _totalBudget;
    _loadServices();
  }

  /// Load Services from JSON
  Future<void> _loadServices() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final eventTypeId = widget.eventInfo['eventType']['eventTypeId'];

      // Load Required Services
      final requiredServices = await JsonService.getRequiredServices(eventTypeId);

      // Load Optional Services
      final optionalServices = await JsonService.getOptionalServices(eventTypeId);

      setState(() {
        _requiredServices = requiredServices;
        _optionalServices = optionalServices;
        _isLoading = false;
      });

      // Calculate initial budget allocation for required services
      _calculateBudgetAllocation();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load services: $e';
        _isLoading = false;
      });
    }
  }

  /// Calculate Budget Allocation
  void _calculateBudgetAllocation() {
    double allocated = 0;

    // Calculate for required services
    for (var service in _requiredServices) {
      final percentage = service['suggestedBudgetPercentage'] ?? 0;
      allocated += (_totalBudget * percentage / 100);
    }

    // Calculate for selected optional services
    for (var service in _optionalServices) {
      if (_selectedOptionalServicesIds.contains(service['serviceId'])) {
        final percentage = service['suggestedBudgetPercentage'] ?? 0;
        allocated += (_totalBudget * percentage / 100);
      }
    }

    setState(() {
      _allocatedBudget = allocated;
      _remainingBudget = _totalBudget - allocated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Select Services',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorView()
              : Column(
                  children: [
                    // Budget Summary Card
                    _buildBudgetSummaryCard(),

                    // Services List
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          // Required Services Section
                          _buildSectionHeader('Required Services', Icons.check_circle),
                          const SizedBox(height: 12),
                          ..._requiredServices.map((service) =>
                              _buildServiceCard(service, isRequired: true)),
                          const SizedBox(height: 24),

                          // Optional Services Section
                          _buildSectionHeader('Optional Services', Icons.add_circle_outline),
                          const SizedBox(height: 12),
                          ..._optionalServices.map((service) =>
                              _buildServiceCard(service, isRequired: false)),
                        ],
                      ),
                    ),

                    // Continue Button
                    _buildContinueButton(),
                  ],
                ),
    );
  }

  /// Error View
  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? 'An error occurred',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadServices,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// Budget Summary Card
  Widget _buildBudgetSummaryCard() {
    return Container(
      margin: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBudgetItem('Total Budget', _totalBudget),
              _buildBudgetItem('Allocated', _allocatedBudget),
              _buildBudgetItem('Remaining', _remainingBudget),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: _allocatedBudget / _totalBudget,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation<Color>(
              _remainingBudget >= 0 ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  /// Budget Item
  Widget _buildBudgetItem(String label, double amount) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'EGP ${_formatNumber(amount.toInt())}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  /// Section Header
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryGold),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  /// Service Card
  Widget _buildServiceCard(
    Map<String, dynamic> service, {
    required bool isRequired,
  }) {
    final serviceId = service['serviceId'];
    final isSelected = isRequired || _selectedOptionalServicesIds.contains(serviceId);
    final budgetPercentage = service['suggestedBudgetPercentage'] ?? 0;
    final allocatedAmount = (_totalBudget * budgetPercentage / 100);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primaryGold : Colors.transparent,
          width: 2,
        ),
      ),
      child: CheckboxListTile(
        value: isSelected,
        onChanged: isRequired
            ? null
            : (value) {
                setState(() {
                  if (value == true) {
                    _selectedOptionalServicesIds.add(serviceId);
                  } else {
                    _selectedOptionalServicesIds.remove(serviceId);
                  }
                  _calculateBudgetAllocation();
                });
              },
        title: Text(
          service['serviceName'] ?? 'Service',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              service['description'] ?? '',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isRequired ? Colors.red.withOpacity(0.2) : Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isRequired ? 'Required' : 'Optional',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isRequired ? Colors.red : Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$budgetPercentage% • EGP ${_formatNumber(allocatedAmount.toInt())}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGold,
                  ),
                ),
              ],
            ),
          ],
        ),
        activeColor: AppColors.primaryGold,
        checkColor: Colors.white,
      ),
    );
  }

  /// Continue Button
  Widget _buildContinueButton() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: ElevatedButton(
        onPressed: _onContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGold,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Continue to Browse Packages',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Handle Continue
  void _onContinue() {
    if (_remainingBudget < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Budget exceeded! Please adjust your selections.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Combine required and selected optional services
    final selectedServices = [
      ..._requiredServices,
      ..._optionalServices.where(
        (s) => _selectedOptionalServicesIds.contains(s['serviceId']),
      ),
    ];

    // Save to EventCreationCubit
    context.read<EventCreationCubit>().setSelectedServices(
          selectedServices: selectedServices,
          allocatedBudget: _allocatedBudget,
          remainingBudget: _remainingBudget,
        );

    // Prepare servicesData for next screen
    final servicesData = {
      'selectedServices': selectedServices,
      'totalBudget': _totalBudget,
      'allocatedBudget': _allocatedBudget,
      'remainingBudget': _remainingBudget,
    };

    // Navigate to BrowsePackagesScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BrowsePackagesScreen(
          eventInfo: widget.eventInfo,
          budgetData: widget.budgetData,
          servicesData: servicesData,
        ),
      ),
    );
  }

  /// Format Number Helper
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}

class ServiceCard extends StatelessWidget {
  final Map<String, dynamic> service;
  final double allocatedAmount;
  final bool isRequired;
  final bool isSelected;
  final VoidCallback? onToggle;

  const ServiceCard({
    super.key,
    required this.service,
    required this.allocatedAmount,
    required this.isRequired,
    required this.isSelected,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected 
            ? AppColors.background 
            : AppColors.background.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected 
              ? (isRequired ? AppColors.success : AppColors.info)
              : AppColors.blue100,
          width: isSelected ? 2 : 1.5,
        ),
        boxShadow: isSelected ? [
          BoxShadow(
            color: (isRequired ? AppColors.success : AppColors.info)
                .withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: !isRequired ? onToggle : null,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Checkbox/Checkmark
                  _buildCheckbox(),

                  const SizedBox(width: 12),

                  // Service Icon
                  _buildServiceIcon(),

                  const SizedBox(width: 12),

                  // Service Info
                  Expanded(
                    child: _buildServiceInfo(),
                  ),

                  // Action Button (if optional)
                  if (!isRequired) _buildActionButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Checkbox Widget
  Widget _buildCheckbox() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: isSelected 
            ? (isRequired ? AppColors.success : AppColors.info)
            : Colors.transparent,
        border: Border.all(
          color: isSelected 
              ? (isRequired ? AppColors.success : AppColors.info)
              : AppColors.blue200,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: isSelected
          ? const Icon(
              Icons.check,
              size: 16,
              color: AppColors.textLight,
            )
          : null,
    );
  }

  /// Service Icon
  Widget _buildServiceIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: (isRequired ? AppColors.success : AppColors.info)
            .withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          service['icon'],
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }

 /// Service Info
Widget _buildServiceInfo() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Service Name
      Row(
        children: [
          Expanded(
            child: Text(
              service['serviceName'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ),
          if (isRequired)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Required',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                ),
              ),
            ),
        ],
      ),

      const SizedBox(height: 4),

      // Description
      Text(
        service['description'],
        style: TextStyle(
          fontSize: 10,
          color: AppColors.textSecondary.withOpacity(0.8),
          height: 1.3,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),

      const SizedBox(height: 8),

      // Budget Info - FIX: Wrap Row with Flexible/Expanded
      if (isSelected)
        Row(
          children: [
            Icon(
              Icons.account_balance_wallet,
              size: 14,
              color: AppColors.primaryGold,
            ),
            const SizedBox(width: 4),
            Expanded(  // ✅ ADD THIS
              child: Text(
                'Allocated: ${_formatCurrency(allocatedAmount)} EGP',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),  // ✅ REDUCE WIDTH
            Text(
              '(${service['suggestedBudgetPercentage']}%)',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
    ],
  );
}

  /// Action Button (for optional services)
  Widget _buildActionButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected 
            ? AppColors.error.withOpacity(0.1)
            : AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isSelected ? 'Remove' : 'Add',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isSelected ? AppColors.error : AppColors.info,
        ),
      ),
    );
  }

  /// Format Currency
  String _formatCurrency(double amount) {
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}

// lib/features/events/presentation/widgets/budget_summary_card.dart

class BudgetSummaryCard extends StatelessWidget {
  final double totalBudget;
  final double allocatedBudget;
  final double remainingBudget;

  const BudgetSummaryCard({
    super.key,
    required this.totalBudget,
    required this.allocatedBudget,
    required this.remainingBudget,
  });

  @override
  Widget build(BuildContext context) {
    final percentageAllocated = (allocatedBudget / totalBudget) * 100;
    final isOverBudget = allocatedBudget > totalBudget;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryDark.withOpacity(0.05),
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
              const Icon(
                Icons.analytics_outlined,
                color: AppColors.primaryGold,
                size: 22,
              ),
              const SizedBox(width: 8),
              const Text(
                'Budget Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Budget Items
          _buildBudgetItem(
            'Total Budget',
            totalBudget,
            Icons.wallet,
            AppColors.info,
          ),
          const SizedBox(height: 12),
          _buildBudgetItem(
            'Allocated',
            allocatedBudget,
            Icons.assignment_turned_in,
            isOverBudget ? AppColors.error : AppColors.success,
          ),
          const SizedBox(height: 12),
          _buildBudgetItem(
            'Remaining',
            remainingBudget,
            Icons.savings,
            remainingBudget >= 0 ? AppColors.primaryGold : AppColors.error,
          ),

          const SizedBox(height: 16),

          // Progress Bar
          _buildProgressBar(percentageAllocated, isOverBudget),

          // Warning Message
          if (isOverBudget) _buildWarningMessage(),
        ],
      ),
    );
  }

  Widget _buildBudgetItem(String label, double amount, IconData icon, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Text(
          '${_formatCurrency(amount)} EGP',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(double percentage, bool isOverBudget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Budget Usage',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isOverBudget ? AppColors.error : AppColors.primaryGold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 10,
            backgroundColor: AppColors.blue100,
            valueColor: AlwaysStoppedAnimation<Color>(
              isOverBudget ? AppColors.error : AppColors.primaryGold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWarningMessage() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.error.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.error,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Budget exceeded! Consider removing optional services.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(2)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}
