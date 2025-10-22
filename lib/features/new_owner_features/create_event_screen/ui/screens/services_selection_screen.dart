// lib/features/events/presentation/screens/services_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';

import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/basic_event_info_screen.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/browse_packages_screen.dart';

class ServicesSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> eventInfo;
  final Map<String, dynamic> budgetData;

  const ServicesSelectionScreen({
    super.key,
    required this.eventInfo,
    required this.budgetData,
  });

  @override
  State<ServicesSelectionScreen> createState() => _ServicesSelectionScreenState();
}

class _ServicesSelectionScreenState extends State<ServicesSelectionScreen> {
  // Services Lists
  late List<Map<String, dynamic>> _requiredServices;
  late List<Map<String, dynamic>> _optionalServices;
  
  // Selected Optional Services IDs
  final Set<String> _selectedOptionalServicesIds = {};

  // Budget tracking
  late double _totalBudget;
  late double _allocatedBudget;
  late double _remainingBudget;

  @override
  void initState() {
    super.initState();
    _loadServices();
    _calculateBudget();
  }

  void _loadServices() {
    final eventTypeId = widget.eventInfo['eventType']['id'];
    
    // Get services based on event type
    final allServices = _getServicesForEventType(eventTypeId);
    
    // Split into required and optional
    _requiredServices = allServices.where((s) => s['required'] == true).toList();
    _optionalServices = allServices.where((s) => s['required'] == false).toList();
    
    // Pre-select first 2 optional services (for demo)
    if (_optionalServices.length >= 2) {
      _selectedOptionalServicesIds.add(_optionalServices[0]['serviceId']);
      _selectedOptionalServicesIds.add(_optionalServices[1]['serviceId']);
    }
  }

  void _calculateBudget() {
    _totalBudget = widget.budgetData['totalBudget'].toDouble();
    _allocatedBudget = 0;

    // Calculate allocated budget from required services
    for (var service in _requiredServices) {
      final percentage = service['suggestedBudgetPercentage'].toDouble();
      _allocatedBudget += (_totalBudget * percentage / 100);
    }

    // Calculate allocated budget from selected optional services
    for (var service in _optionalServices) {
      if (_selectedOptionalServicesIds.contains(service['serviceId'])) {
        final percentage = service['suggestedBudgetPercentage'].toDouble();
        _allocatedBudget += (_totalBudget * percentage / 100);
      }
    }

    _remainingBudget = _totalBudget - _allocatedBudget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            _buildProgressIndicator(),

            // Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Required Services Section
                    _buildRequiredServicesSection(),

                    const SizedBox(height: 24),

                    // Divider
                    _buildDivider(),

                    const SizedBox(height: 24),

                    // Optional Services Section
                    _buildOptionalServicesSection(),

                    const SizedBox(height: 24),

                    // Divider
                    _buildDivider(),

                    const SizedBox(height: 24),

                    // Budget Summary
                    BudgetSummaryCard(
                      totalBudget: _totalBudget,
                      allocatedBudget: _allocatedBudget,
                      remainingBudget: _remainingBudget,
                    ),

                    const SizedBox(height: 32),

                    // Next Button
                    _buildNextButton(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryDark,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: AppColors.textLight,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Select Services',
        style: TextStyle(
          color: AppColors.textLight,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  /// Progress Indicator
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
      child: const StepProgressIndicator(
        currentStep: 4,
        totalSteps: 8,
      ),
    );
  }

  /// Required Services Section
  Widget _buildRequiredServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        _buildSectionHeader(
          icon: Icons.check_circle,
          title: 'Required Services',
          color: AppColors.success,
          subtitle: 'These services are essential for your event',
        ),

        const SizedBox(height: 16),

        // Required Services List
        ..._requiredServices.map((service) {
          final allocatedAmount = _totalBudget * 
              (service['suggestedBudgetPercentage'] / 100);
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ServiceCard(
              service: service,
              allocatedAmount: allocatedAmount,
              isRequired: true,
              isSelected: true,
              onToggle: null, // Required services cannot be toggled
            ),
          );
        }),
      ],
    );
  }

  /// Optional Services Section
  Widget _buildOptionalServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        _buildSectionHeader(
          icon: Icons.library_add_check,
          title: 'Optional Services',
          color: AppColors.info,
          subtitle: 'Add these services to enhance your event',
        ),

        const SizedBox(height: 16),

        // Optional Services List
        ..._optionalServices.map((service) {
          final isSelected = _selectedOptionalServicesIds.contains(
            service['serviceId'],
          );
          final allocatedAmount = _totalBudget * 
              (service['suggestedBudgetPercentage'] / 100);
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ServiceCard(
              service: service,
              allocatedAmount: allocatedAmount,
              isRequired: false,
              isSelected: isSelected,
              onToggle: () => _toggleOptionalService(service['serviceId']),
            ),
          );
        }),
      ],
    );
  }

  /// Section Header Widget
  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  /// Divider
  Widget _buildDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.blue100,
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  /// Next Button
  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _handleNext,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGold,
          foregroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Start Browsing Packages',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded),
          ],
        ),
      ),
    );
  }

  /// Toggle Optional Service
  void _toggleOptionalService(String serviceId) {
    setState(() {
      if (_selectedOptionalServicesIds.contains(serviceId)) {
        _selectedOptionalServicesIds.remove(serviceId);
      } else {
        _selectedOptionalServicesIds.add(serviceId);
      }
      _calculateBudget();
    });
  }

  /// Handle Next Button
  void _handleNext() {
    // Gather selected services
    final selectedServices = [
      ..._requiredServices,
      ..._optionalServices.where((s) => 
        _selectedOptionalServicesIds.contains(s['serviceId'])
      ),
    ];

    // Prepare data for next screen
    final servicesData = {
      'selectedServices': selectedServices,
      'totalBudget': _totalBudget,
      'allocatedBudget': _allocatedBudget,
      'remainingBudget': _remainingBudget,
    };

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Selected ${selectedServices.length} services',
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );

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

  /// Get Services for Event Type (Mock Data)
  List<Map<String, dynamic>> _getServicesForEventType(String eventTypeId) {
    // This will be replaced with actual data from JSON later
    return _mockServicesData[eventTypeId] ?? _mockServicesData['evt_wedding']!;
  }

  /// Mock Services Data
  static final Map<String, List<Map<String, dynamic>>> _mockServicesData = {
    'evt_wedding': [
      {
        'serviceId': 'srv_venue',
        'serviceName': 'Venue & Spaces',
        'icon': '🏛️',
        'required': true,
        'priority': 1,
        'suggestedBudgetPercentage': 30,
        'description': 'Wedding venue, banquet hall, or outdoor space',
      },
      {
        'serviceId': 'srv_catering',
        'serviceName': 'Catering & Food',
        'icon': '🍽️',
        'required': true,
        'priority': 2,
        'suggestedBudgetPercentage': 25,
        'description': 'Food and beverage services for your wedding',
      },
      {
        'serviceId': 'srv_photography',
        'serviceName': 'Photography & Videography',
        'icon': '📷',
        'required': true,
        'priority': 3,
        'suggestedBudgetPercentage': 15,
        'description': 'Professional photography and video coverage',
      },
      {
        'serviceId': 'srv_decoration',
        'serviceName': 'Decoration & Flowers',
        'icon': '🎨',
        'required': true,
        'priority': 4,
        'suggestedBudgetPercentage': 15,
        'description': 'Wedding decoration, floral arrangements',
      },
      {
        'serviceId': 'srv_entertainment',
        'serviceName': 'Music & Entertainment',
        'icon': '🎵',
        'required': false,
        'priority': 5,
        'suggestedBudgetPercentage': 8,
        'description': 'DJ, live band, or entertainment services',
      },
      {
        'serviceId': 'srv_cake',
        'serviceName': 'Wedding Cake',
        'icon': '🎂',
        'required': false,
        'priority': 6,
        'suggestedBudgetPercentage': 3,
        'description': 'Wedding cake and dessert services',
      },
      {
        'serviceId': 'srv_invitations',
        'serviceName': 'Invitations',
        'icon': '💌',
        'required': false,
        'priority': 7,
        'suggestedBudgetPercentage': 2,
        'description': 'Wedding invitations and printing',
      },
      {
        'serviceId': 'srv_makeup',
        'serviceName': 'Hair & Makeup',
        'icon': '💄',
        'required': false,
        'priority': 8,
        'suggestedBudgetPercentage': 4,
        'description': 'Bridal hair styling and makeup',
      },
    ],
    'evt_birthday': [
      {
        'serviceId': 'srv_venue',
        'serviceName': 'Venue & Spaces',
        'icon': '🏛️',
        'required': true,
        'priority': 1,
        'suggestedBudgetPercentage': 25,
        'description': 'Party venue or entertainment center',
      },
      {
        'serviceId': 'srv_catering',
        'serviceName': 'Catering & Food',
        'icon': '🍽️',
        'required': true,
        'priority': 2,
        'suggestedBudgetPercentage': 30,
        'description': 'Food, snacks, and beverages',
      },
      {
        'serviceId': 'srv_cake',
        'serviceName': 'Birthday Cake',
        'icon': '🎂',
        'required': true,
        'priority': 3,
        'suggestedBudgetPercentage': 10,
        'description': 'Birthday cake and desserts',
      },
      {
        'serviceId': 'srv_entertainment',
        'serviceName': 'Entertainment',
        'icon': '🎪',
        'required': false,
        'priority': 4,
        'suggestedBudgetPercentage': 20,
        'description': 'Entertainers, animators, or DJ',
      },
      {
        'serviceId': 'srv_decoration',
        'serviceName': 'Decoration',
        'icon': '🎨',
        'required': false,
        'priority': 5,
        'suggestedBudgetPercentage': 12,
        'description': 'Party decoration and themed styling',
      },
      {
        'serviceId': 'srv_photography',
        'serviceName': 'Photography',
        'icon': '📷',
        'required': false,
        'priority': 6,
        'suggestedBudgetPercentage': 8,
        'description': 'Photo coverage of the party',
      },
    ],
    // Add more event types as needed
  };
}

// lib/features/events/presentation/widgets/service_card.dart

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
