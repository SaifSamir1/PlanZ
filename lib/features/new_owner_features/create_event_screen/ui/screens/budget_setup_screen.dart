// lib/features/events/presentation/screens/budget_setup_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/basic_event_info_screen.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/services_selection_screen.dart';

class BudgetSetupScreen extends StatefulWidget {
  final Map<String, dynamic> eventInfo;

  const BudgetSetupScreen({
    super.key,
    required this.eventInfo,
  });

  @override
  State<BudgetSetupScreen> createState() => _BudgetSetupScreenState();
}

class _BudgetSetupScreenState extends State<BudgetSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _budgetController = TextEditingController();

  // Mock suggested budget ranges based on event type
  late Map<String, dynamic> _suggestedBudget;

  @override
  void initState() {
    super.initState();
    _loadSuggestedBudget();
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  void _loadSuggestedBudget() {
    // Get suggested budget based on event type
    final eventTypeId = widget.eventInfo['eventType']['id'];
    _suggestedBudget = _mockBudgetRanges[eventTypeId] ?? _mockBudgetRanges['evt_wedding']!;
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

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      _buildSectionTitle(),

                      const SizedBox(height: 24),

                      // Suggested Budget Card
                      _buildSuggestedBudgetCard(),

                      const SizedBox(height: 24),

                      // Total Budget Input
                      _buildBudgetInput(),

                      const SizedBox(height: 24),

                      // Budget Tips
                      _buildBudgetTips(),

                      const SizedBox(height: 32),

                      // Next Button
                      _buildNextButton(),

                      const SizedBox(height: 20),
                    ],
                  ),
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
        'Setup Budget',
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
        currentStep: 3,
        totalSteps: 8,
      ),
    );
  }

  /// Section Title
  Widget _buildSectionTitle() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryGold.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.account_balance_wallet,
            color: AppColors.primaryGold,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Budget Planning',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  /// Suggested Budget Card
  Widget _buildSuggestedBudgetCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGold.withOpacity(0.1),
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
                Icons.info_outline,
                color: AppColors.primaryGold,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'Suggested Budget Range',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Budget Range
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Minimum
              Expanded(
                child: _buildBudgetRangeItem(
                  'Minimum',
                  _suggestedBudget['min'],
                  Icons.arrow_downward,
                  AppColors.info,
                ),
              ),

              // Divider
              Container(
                width: 1,
                height: 60,
                color: AppColors.primaryGold.withOpacity(0.3),
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),

              // Average
              Expanded(
                child: _buildBudgetRangeItem(
                  'Average',
                  _suggestedBudget['average'],
                  Icons.trending_flat,
                  AppColors.primaryGold,
                ),
              ),

              // Divider
              Container(
                width: 1,
                height: 60,
                color: AppColors.primaryGold.withOpacity(0.3),
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),

              // Maximum
              Expanded(
                child: _buildBudgetRangeItem(
                  'Maximum',
                  _suggestedBudget['max'],
                  Icons.arrow_upward,
                  AppColors.success,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Note
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.warning,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _suggestedBudget['note'],
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
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

  /// Budget Range Item
  Widget _buildBudgetRangeItem(String label, int amount, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${_formatCurrency(amount)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          'EGP',
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Budget Input Field
  Widget _buildBudgetInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        const Text(
          'Your Total Budget',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),

        // Input Field
        TextFormField(
          controller: _budgetController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your budget';
            }
            final budget = int.tryParse(value.trim());
            if (budget == null || budget <= 0) {
              return 'Please enter a valid amount';
            }
            if (budget < 1000) {
              return 'Budget should be at least 1,000 EGP';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Enter amount',
            hintStyle: TextStyle(
              fontSize: 20,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'EGP',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGold,
                ),
              ),
            ),
            suffixIcon: const Icon(
              Icons.monetization_on,
              color: AppColors.primaryGold,
              size: 28,
            ),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.blue100,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.blue100,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryGold,
                width: 2.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
          ),
          onChanged: (value) {
            setState(() {}); // Rebuild to show formatted value
          },
        ),

        // Budget comparison (if entered)
        if (_budgetController.text.isNotEmpty)
          _buildBudgetComparison(),
      ],
    );
  }

  /// Budget Comparison Widget
  Widget _buildBudgetComparison() {
    final enteredBudget = int.tryParse(_budgetController.text) ?? 0;
    if (enteredBudget <= 0) return const SizedBox.shrink();

    String message;
    Color color;
    IconData icon;

    if (enteredBudget < _suggestedBudget['min']) {
      message = 'Below suggested minimum';
      color = AppColors.error;
      icon = Icons.trending_down;
    } else if (enteredBudget >= _suggestedBudget['min'] && 
               enteredBudget <= _suggestedBudget['average']) {
      message = 'Good budget range';
      color = AppColors.info;
      icon = Icons.check_circle_outline;
    } else if (enteredBudget > _suggestedBudget['average'] && 
               enteredBudget <= _suggestedBudget['max']) {
      message = 'Great budget range';
      color = AppColors.success;
      icon = Icons.verified;
    } else {
      message = 'Premium budget - Excellent!';
      color = AppColors.primaryGold;
      icon = Icons.star;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// Budget Tips Section
  Widget _buildBudgetTips() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.blue50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.blue100,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.tips_and_updates,
                color: AppColors.info,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Budget Tips',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...(_suggestedBudget['tips'] as List<String>).map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.check,
                      size: 16,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tip,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
              'Next: Select Services',
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

  /// Handle Next Button
  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      final budget = int.parse(_budgetController.text.trim());

      // Prepare budget data
      final budgetData = {
        'totalBudget': budget,
        'currency': 'EGP',
        'suggestedRange': _suggestedBudget,
      };

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Budget saved successfully!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to next screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ServicesSelectionScreen(
            budgetData:budgetData ,
            eventInfo: widget.eventInfo,
          ),
        ),
      );
      
    }
  }

  /// Format currency
  String _formatCurrency(int amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toString();
  }

  /// Mock Budget Ranges
  static final Map<String, Map<String, dynamic>> _mockBudgetRanges = {
    'evt_wedding': {
      'min': 50000,
      'average': 150000,
      'max': 500000,
      'note': 'Prices vary based on guest count and service quality',
      'tips': [
        'Venue typically takes 25-35% of budget',
        'Consider off-season dates for better prices',
        'Quality photography is worth the investment',
        'Allocate 20-30% for catering per person',
      ],
    },
    'evt_birthday': {
      'min': 5000,
      'average': 25000,
      'max': 100000,
      'note': 'Prices vary based on age group and party size',
      'tips': [
        'Entertainment is key for kids parties',
        'Venue + Food = ~60% of budget',
        'DIY decorations can save money',
        'Book 4-6 weeks in advance',
      ],
    },
    'evt_corporate': {
      'min': 30000,
      'average': 200000,
      'max': 1000000,
      'note': 'Prices vary based on attendee count and event duration',
      'tips': [
        'AV equipment is essential (15-20% of budget)',
        'Catering quality reflects your brand',
        'Professional photography recommended',
        'Plan 2-3 months ahead',
      ],
    },
    'evt_engagement': {
      'min': 30000,
      'average': 80000,
      'max': 200000,
      'note': 'Prices vary based on guest count and venue',
      'tips': [
        'Simpler than weddings, budget accordingly',
        'Focus on venue + catering (60%)',
        'Good photography is a must',
        'Consider intimate gatherings to save',
      ],
    },
    'evt_baby_shower': {
      'min': 8000,
      'average': 25000,
      'max': 80000,
      'note': 'Prices vary based on guest count and decoration complexity',
      'tips': [
        'Decoration sets the theme (30%)',
        'Keep food light and simple',
        'Consider gender reveal add-ons',
        'Photography captures memories',
      ],
    },
    'evt_graduation': {
      'min': 15000,
      'average': 50000,
      'max': 150000,
      'note': 'Prices vary based on guest count and venue choice',
      'tips': [
        'Venue + Food = ~55% of budget',
        'Professional photos recommended',
        'Consider outdoor venues for savings',
        'Plan 2-3 months ahead',
      ],
    },
  };
}
