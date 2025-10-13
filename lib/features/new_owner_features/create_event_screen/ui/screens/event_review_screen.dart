// lib/features/events/presentation/screens/event_review_screen.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/basic_event_info_screen.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/payment_screen.dart';

class EventReviewScreen extends StatefulWidget {
  final Map<String, dynamic> eventInfo;
  final Map<String, dynamic> budgetData;
  final Map<String, dynamic> servicesData;
  final Map<String, String> selectedPackages; // serviceId: packageId
  final List<Map<String, dynamic>> allPackages;

  const EventReviewScreen({
    super.key,
    required this.eventInfo,
    required this.budgetData,
    required this.servicesData,
    required this.selectedPackages,
    required this.allPackages,
  });

  @override
  State<EventReviewScreen> createState() => _EventReviewScreenState();
}

class _EventReviewScreenState extends State<EventReviewScreen> {
  final _notesController = TextEditingController();
  final _expandedPackages = <String>{};

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  double _calculateTotalSpent() {
    double total = 0;
    for (var entry in widget.selectedPackages.entries) {
      final package = widget.allPackages.firstWhere(
        (pkg) => pkg['packageId'] == entry.value,
        orElse: () => {'price': 0},
      );
      total += package['price'].toDouble();
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final totalBudget = widget.budgetData['totalBudget'].toDouble();
    final totalSpent = _calculateTotalSpent();
    final remaining = totalBudget - totalSpent;
    final percentageSpent = (totalSpent / totalBudget * 100).clamp(0.0, 100.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Progress Indicator
          _buildProgressIndicator(),

          // Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Success Header
                  _buildSuccessHeader(),

                  const SizedBox(height: 24),

                  // Event Summary Card
                  _buildEventSummaryCard(),

                  const SizedBox(height: 20),

                  // Budget Summary
                  _buildBudgetSummary(totalBudget, totalSpent, remaining, percentageSpent),

                  const SizedBox(height: 20),

                  // Selected Packages Section
                  _buildSelectedPackagesSection(),

                  const SizedBox(height: 20),

                  // Additional Notes
                  _buildAdditionalNotes(),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryDark,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: AppColors.textLight),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Review Event',
        style: TextStyle(
          color: AppColors.textLight,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

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
      child: const StepProgressIndicator(currentStep: 6, totalSteps: 8),
    );
  }

  Widget _buildSuccessHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success.withOpacity(0.15),
            AppColors.success.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.success.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.check_circle,
              color: AppColors.textLight,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Almost Done!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Review your event details before confirming',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventSummaryCard() {
    final eventType = widget.eventInfo['eventType'];
    final date = widget.eventInfo['date'];
    final time = widget.eventInfo['time'];
    final location = widget.eventInfo['location'];
    final guestCount = widget.eventInfo['guestCount'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.blue100,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.event,
                  color: AppColors.primaryGold,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Event Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Event Type
          _buildSummaryRow(
            Icons.celebration,
            'Event Type',
            eventType['name'] ?? eventType['eventTypeName'],
            AppColors.primaryGold,
          ),

          const SizedBox(height: 12),

          // Date
          _buildSummaryRow(
            Icons.calendar_today,
            'Date',
            date ?? 'Not specified',
            AppColors.info,
          ),

          const SizedBox(height: 12),

          // Time
          _buildSummaryRow(
            Icons.access_time,
            'Time',
            time ?? 'Not specified',
            AppColors.info,
          ),

          const SizedBox(height: 12),

          // Location
          _buildSummaryRow(
            Icons.location_on,
            'Location',
            location ?? 'Not specified',
            AppColors.error,
          ),

          const SizedBox(height: 12),

          // Guest Count
          _buildSummaryRow(
            Icons.people,
            'Guest Count',
            '$guestCount guests',
            AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              Flexible(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetSummary(double total, double spent, double remaining, double percentage) {
    final isOverBudget = spent > total;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGold.withOpacity(0.12),
            AppColors.primaryGold.withOpacity(0.05),
          ],
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold.withOpacity(0.2),
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
                'Budget Breakdown',
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
          Row(
            children: [
              Expanded(
                child: _buildBudgetItem('Total Budget', total, Icons.wallet, AppColors.info),
              ),
              Container(
                width: 1,
                height: 50,
                color: AppColors.primaryGold.withOpacity(0.3),
              ),
              Expanded(
                child: _buildBudgetItem('Total Spent', spent, Icons.shopping_cart, 
                  isOverBudget ? AppColors.error : AppColors.success),
              ),
              Container(
                width: 1,
                height: 50,
                color: AppColors.primaryGold.withOpacity(0.3),
              ),
              Expanded(
                child: _buildBudgetItem('Remaining', remaining, Icons.savings, 
                  remaining >= 0 ? AppColors.primaryGold : AppColors.error),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress Bar
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

          const SizedBox(height: 8),

          // Percentage Text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${percentage.toStringAsFixed(1)}% of budget used',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              if (isOverBudget)
                Text(
                  'Over budget!',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                )
              else if (remaining > 0)
                Text(
                  'Within budget ✓',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetItem(String label, double amount, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          _formatCurrency(amount),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          'EGP',
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedPackagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.shopping_bag,
                color: AppColors.info,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Selected Packages',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${widget.selectedPackages.length} services',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.success,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Package Cards
        ...widget.selectedPackages.entries.map((entry) {
          final serviceId = entry.key;
          final packageId = entry.value;
          
          final service = (widget.servicesData['selectedServices'] as List).firstWhere(
            (s) => s['serviceId'] == serviceId,
            orElse: () => {'serviceName': 'Unknown Service'},
          );
          
          final package = widget.allPackages.firstWhere(
            (pkg) => pkg['packageId'] == packageId,
            orElse: () => {
              'packageName': 'Unknown Package',
              'vendorName': 'Unknown Vendor',
              'price': 0,
              'includes': [],
            },
          );

          final isExpanded = _expandedPackages.contains(packageId);

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildPackageCard(service, package, isExpanded, packageId),
          );
        }),
      ],
    );
  }

  Widget _buildPackageCard(Map<String, dynamic> service, Map<String, dynamic> package, 
      bool isExpanded, String packageId) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.blue100,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (isExpanded) {
                  _expandedPackages.remove(packageId);
                } else {
                  _expandedPackages.add(packageId);
                }
              });
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Service Icon
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGold.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: AppColors.primaryGold,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Package Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service['serviceName'] ?? 'Service',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              package['packageName'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'by ${package['vendorName']}',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${package['price']} EGP',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Icon(
                            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Expanded Details
                  if (isExpanded) ...[
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Includes:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    ...(package['includes'] as List<dynamic>).map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check,
                              size: 16,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalNotes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.notes,
                color: AppColors.warning,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Additional Notes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        TextField(
          controller: _notesController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Add any special requirements or notes for vendors...',
            hintStyle: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary.withOpacity(0.6),
            ),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.blue100),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.blue100),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryGold, width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Back to Edit Button
          Expanded(
            child: SizedBox(
              height: 54,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.edit, size: 20),
                label: const Text(
                  'Back to Edit',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.info,
                  side: const BorderSide(color: AppColors.info, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Confirm Button
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _confirmEvent,
                icon: const Icon(Icons.check_circle, size: 22),
                label: const Text(
                  'Confirm Event',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGold,
                  foregroundColor: AppColors.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmEvent() {
  // Calculate total spent
  double totalSpent = 0;
  for (var entry in widget.selectedPackages.entries) {
    final package = widget.allPackages.firstWhere(
      (pkg) => pkg['packageId'] == entry.value,
      orElse: () => {'price': 0},
    );
    totalSpent += package['price'].toDouble();
  }

  // Navigate to Payment Screen
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PaymentScreen(
        totalAmount: totalSpent,
        eventInfo: widget.eventInfo,
        budgetData: widget.budgetData,
        servicesData: widget.servicesData,
        selectedPackages: widget.selectedPackages,
      ),
    ),
  );
}


  Widget _buildConfirmationDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.check_circle, color: AppColors.success, size: 28),
          ),
          const SizedBox(width: 12),
          const Text(
            'Confirm Event?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: const Text(
        'Are you sure you want to confirm this event? You can still edit details later.',
        style: TextStyle(fontSize: 14),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(fontSize: 15)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            _showSuccessScreen();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGold,
            foregroundColor: AppColors.textPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Confirm', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  void _showSuccessScreen() {
    // TODO: Save event to database/backend
    
    // Navigate to success screen
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildSuccessDialog(),
    );
  }

  Widget _buildSuccessDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.celebration,
                color: AppColors.success,
                size: 60,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Event Created Successfully!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Your event has been created and vendors will be notified.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGold,
                  foregroundColor: AppColors.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}
