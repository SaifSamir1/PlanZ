// lib/features/events/presentation/screens/budget_setup_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/core/services/json_service.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/cubits/event_creation_cubit/event_creation_cubit.dart';
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

  // Suggested budget ranges from JSON
  Map<String, dynamic>? _suggestedBudget;
  bool _isLoading = true;
  String? _errorMessage;

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

  /// Load Suggested Budget from JSON
  Future<void> _loadSuggestedBudget() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final eventTypeId = widget.eventInfo['eventType']['eventTypeId'];
      final estimatedBudget = await JsonService.getEstimatedBudget(eventTypeId);

      setState(() {
        _suggestedBudget = estimatedBudget;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load budget suggestions: $e';
        _isLoading = false;
      });
    }
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
          'Budget Setup',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorView()
              : Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(20.0),
                    children: [
                      // Event Summary Card
                      _buildEventSummaryCard(),
                      const SizedBox(height: 24),

                      // Suggested Budget Section
                      if (_suggestedBudget != null) ...[
                        _buildSuggestedBudgetCard(),
                        const SizedBox(height: 24),
                      ],

                      // Budget Input Field
                      _buildBudgetInputField(),
                      const SizedBox(height: 16),

                      // Budget Tips
                      _buildBudgetTipsCard(),
                      const SizedBox(height: 32),

                      // Continue Button
                      _buildContinueButton(),
                    ],
                  ),
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
            onPressed: _loadSuggestedBudget,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// Event Summary Card
  Widget _buildEventSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryGold, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // ✅ Fixed Icon Display
              _buildIcon(widget.eventInfo['eventType']['icon']),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.eventInfo['eventName'] ?? 'Event',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      widget.eventInfo['eventType']['eventTypeName'] ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.calendar_today,
            'Date',
            '${widget.eventInfo['eventDate'].day}/${widget.eventInfo['eventDate'].month}/${widget.eventInfo['eventDate'].year}',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.people,
            'Guests',
            '${widget.eventInfo['guestCount']} people',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.location_on,
            'Location',
            '${widget.eventInfo['city']}, ${widget.eventInfo['area']}',
          ),
        ],
      ),
    );
  }

  /// ✅ Helper to build icon (emoji or asset)
  Widget _buildIcon(dynamic icon) {
    if (icon == null) {
      return const Icon(Icons.event, size: 32, color: Colors.grey);
    }

    final iconStr = icon.toString();

    // Check if it's an asset path
    if (iconStr.startsWith('assets/')) {
      return Image.asset(
        iconStr,
        width: 32,
        height: 32,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.event, size: 32, color: Colors.grey);
        },
      );
    }

    // Otherwise, it's an emoji
    return Text(
      iconStr,
      style: const TextStyle(fontSize: 32),
    );
  }

  /// Info Row Helper
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  /// ✅ Suggested Budget Card (with Horizontal Scroll)
  Widget _buildSuggestedBudgetCard() {
    final min = _suggestedBudget?['min'] ?? 0;
    final average = _suggestedBudget?['average'] ?? 0;
    final max = _suggestedBudget?['max'] ?? 0;
    final currency = _suggestedBudget?['currency'] ?? 'EGP';

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '💡 Suggested Budget Range',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          
          // ✅ Option 1: Horizontal Scroll (Recommended)
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildBudgetOption('Minimum', min, currency, Colors.orange),
                const SizedBox(width: 12),
                _buildBudgetOption('Average', average, currency, Colors.green),
                const SizedBox(width: 12),
                _buildBudgetOption('Maximum', max, currency, Colors.blue),
              ],
            ),
          ),
          
          // ✅ Option 2: 2 في صف (Alternative)
          // Wrap(
          //   spacing: 12,
          //   runSpacing: 12,
          //   children: [
          //     SizedBox(
          //       width: (MediaQuery.of(context).size.width - 72) / 2,
          //       child: _buildBudgetOption('Minimum', min, currency, Colors.orange),
          //     ),
          //     SizedBox(
          //       width: (MediaQuery.of(context).size.width - 72) / 2,
          //       child: _buildBudgetOption('Average', average, currency, Colors.green),
          //     ),
          //     SizedBox(
          //       width: (MediaQuery.of(context).size.width - 72) / 2,
          //       child: _buildBudgetOption('Maximum', max, currency, Colors.blue),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  /// ✅ Budget Option Widget (Fixed Width for Horizontal Scroll)
  Widget _buildBudgetOption(
    String label,
    dynamic amount,
    String currency,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        _budgetController.text = amount.toString();
      },
      child: Container(
        width: 120, // ✅ Fixed width for horizontal scroll
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              '$currency ${_formatNumber(amount)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Budget Input Field
  Widget _buildBudgetInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Total Budget',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _budgetController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
            hintText: 'Enter your budget',
            prefixIcon: const Icon(Icons.attach_money),
            suffixText: 'EGP',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: AppColors.cardBackground,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your budget';
            }

            final budget = double.tryParse(value);
            if (budget == null || budget <= 0) {
              return 'Please enter a valid budget';
            }

            return null;
          },
        ),
      ],
    );
  }

  /// Budget Tips Card
  Widget _buildBudgetTipsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
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
          _buildTipItem('Budget will be automatically distributed across services'),
          _buildTipItem('You can adjust allocations in the next step'),
          _buildTipItem('Consider a 10% buffer for unexpected costs'),
          _buildTipItem('Payment required only after vendor confirmation'),
        ],
      ),
    );
  }

  /// Tip Item
  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Continue Button
  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: _onContinue,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGold,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Continue to Services Selection',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Handle Continue
  void _onContinue() {
    if (_formKey.currentState!.validate()) {
      final totalBudget = double.parse(_budgetController.text.trim());

      // Save to EventCreationCubit
      context.read<EventCreationCubit>().setBudget(
            totalBudget: totalBudget,
            currency: 'EGP',
            suggestedBudgetRange: _suggestedBudget,
          );

      // Prepare budgetData for next screen
      final budgetData = {
        'totalBudget': totalBudget,
        'currency': 'EGP',
        'suggestedRange': _suggestedBudget,
      };

      // Navigate to ServicesSelectionScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ServicesSelectionScreen(
            eventInfo: widget.eventInfo,
            budgetData: budgetData,
          ),
        ),
      );
    }
  }

  /// Format Number Helper
  String _formatNumber(dynamic number) {
    if (number == null) return '0';
    final num = number is int ? number : (number as double).toInt();
    return num.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
