// lib/features/new_owner_features/create_event_screen/ui/screens/payment_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:intl/intl.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/cubits/create_event_cubit/create_event_cubit.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/cubits/create_event_cubit/create_event_state.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_model.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_model_enum.dart';

class PaymentScreen extends StatefulWidget {
  final String eventId;
  final double totalAmount;

  const PaymentScreen({
    super.key,
    required this.eventId,
    required this.totalAmount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  /// ============================================
  /// Variables
  /// ============================================
  
  // Payment Method
  String _selectedPaymentMethod = 'card'; // card, wallet, cash
  
  // Deposit Options
  String _selectedDepositOption = 'full'; // full, partial
  late double _depositAmount;

  // Card Form Variables
  String _cardNumber = '';
  String _expiryDate = '';
  String _cardHolderName = '';
  String _cvvCode = '';
  bool _isCvvFocused = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Wallet Number
  String _walletNumber = '';

  // Processing
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _depositAmount = widget.totalAmount;
    _loadEventData();
  }

  /// ✅ Load Event Data
  void _loadEventData() {
    debugPrint('💳 Loading event data for payment: ${widget.eventId}');
    context.read<EventOwnerCubit>().getEventById(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Payment'),
      body: BlocBuilder<EventOwnerCubit, EventOwnerState>(
        builder: (context, state) {
          debugPrint('💳 Payment State: ${state.runtimeType}');

          // ============================================
          // Loading State
          // ============================================
          if (state is GetEventByIdLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryGold,
                ),
              ),
            );
          }

          // ============================================
          // Error State
          // ============================================
          if (state is GetEventByIdError) {
            return _buildErrorWidget(state.message);
          }

          // ============================================
          // Success State ✅
          // ============================================
          if (state is GetEventByIdSuccess) {
            final event = state.event;
            return _buildPaymentContent(event);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// ============================================
  /// Payment Content
  /// ============================================
  Widget _buildPaymentContent(EventModel event) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ✅ Progress Bar
          _buildProgressBar(),
          
          // ✅ Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Payment Summary
                _buildPaymentSummary(event),
                const SizedBox(height: 24),

                // ✅ Payment Method Selection
                _buildPaymentMethodSelection(),
                const SizedBox(height: 24),

                // ✅ Deposit Options
                _buildDepositOptions(),
                const SizedBox(height: 24),

                // ✅ Payment Form (based on method)
                if (_selectedPaymentMethod == 'card')
                  _buildCreditCardForm()
                else if (_selectedPaymentMethod == 'wallet')
                  _buildWalletForm()
                else
                  _buildCashPaymentInfo(),

                const SizedBox(height: 30),

                // ✅ Payment Button
                _buildPaymentButton(event),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Progress Bar
  /// ============================================
  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildProgressStep('1', 'Packages', true),
              _buildProgressLine(true),
              _buildProgressStep('2', 'Payment', true),
              _buildProgressLine(false),
              _buildProgressStep('3', 'Done', false),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Step 2 of 3: Payment',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Progress Step
  /// ============================================
  Widget _buildProgressStep(String number, String label, bool isCompleted) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : Text(
                      number,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Progress Line
  /// ============================================
  Widget _buildProgressLine(bool isCompleted) {
    return Expanded(
      child: Container(
        height: 2,
        color: isCompleted ? Colors.green : Colors.grey[300],
      ),
    );
  }

  /// ============================================
  /// Payment Summary Card
  /// ============================================
  Widget _buildPaymentSummary(EventModel event) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGold.withOpacity(0.15),
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryGold.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.receipt_long,
                  color: AppColors.primaryGold,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.eventName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM d, yyyy').format(event.eventDate),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          _buildSummaryRow('Subtotal', widget.totalAmount),
          const SizedBox(height: 12),
          _buildSummaryRow('Fees (0%)', 0),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _buildSummaryRow(
              'Total Amount',
              widget.totalAmount,
              isBold: true,
            ),
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Summary Row
  /// ============================================
  Widget _buildSummaryRow(String label, double amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 14 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isBold ? AppColors.primaryGold : Colors.grey[600],
          ),
        ),
        Text(
          'EGP ${_formatNumber(amount.toInt())}',
          style: TextStyle(
            fontSize: isBold ? 14 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isBold ? AppColors.primaryGold : AppColors.primaryDark,
          ),
        ),
      ],
    );
  }

  /// ============================================
  /// Payment Method Selection
  /// ============================================
  Widget _buildPaymentMethodSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildPaymentMethodCard('Credit Card', 'card', Icons.credit_card),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPaymentMethodCard('Mobile Wallet', 'wallet', Icons.phone_android),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPaymentMethodCard('Cash', 'cash', Icons.money),
            ),
          ],
        ),
      ],
    );
  }

  /// ============================================
  /// Payment Method Card
  /// ============================================
  Widget _buildPaymentMethodCard(String title, String value, IconData icon) {
    final isSelected = _selectedPaymentMethod == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGold.withOpacity(0.15)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryGold : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryGold : Colors.grey[600],
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primaryGold : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// ============================================
  /// Deposit Options
  /// ============================================
  Widget _buildDepositOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Option',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDepositOption(
                'Full Payment',
                'full',
                widget.totalAmount,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildDepositOption(
                '30% Deposit',
                'partial',
                widget.totalAmount * 0.3,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// ============================================
  /// Deposit Option
  /// ============================================
  Widget _buildDepositOption(String title, String value, double amount) {
    final isSelected = _selectedDepositOption == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDepositOption = value;
          _depositAmount = amount;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryGold.withOpacity(0.15)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryGold : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primaryGold : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'EGP ${_formatNumber(amount.toInt())}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primaryGold : AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ============================================
  /// Credit Card Form
  /// ============================================
  Widget _buildCreditCardForm() {
    return Column(
      children: [
        // Card Display
        CreditCardWidget(
          cardNumber: _cardNumber,
          expiryDate: _expiryDate,
          cardHolderName: _cardHolderName,
          cvvCode: _cvvCode,
          showBackView: _isCvvFocused,
          obscureCardNumber: true,
          obscureCardCvv: true,
          isHolderNameVisible: true,
          cardBgColor: AppColors.primaryDark,
          isSwipeGestureEnabled: true,
          onCreditCardWidgetChange: (CreditCardBrand brand) {},
        ),
        const SizedBox(height: 20),

        // Card Form
        CreditCardForm(
          formKey: _formKey,
          obscureCvv: true,
          obscureNumber: true,
          cardNumber: _cardNumber,
          cvvCode: _cvvCode,
          isHolderNameVisible: true,
          isCardNumberVisible: true,
          isExpiryDateVisible: true,
          cardHolderName: _cardHolderName,
          expiryDate: _expiryDate,
          inputConfiguration: InputConfiguration(
            cardNumberDecoration: InputDecoration(
              labelText: 'Card Number',
              hintText: 'XXXX XXXX XXXX XXXX',
              labelStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[50],
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
                borderSide: const BorderSide(
                  color: AppColors.primaryGold,
                  width: 2,
                ),
              ),
            ),
            expiryDateDecoration: InputDecoration(
              labelText: 'Expiry Date',
              hintText: 'MM/YY',
              labelStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[50],
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
                borderSide: const BorderSide(
                  color: AppColors.primaryGold,
                  width: 2,
                ),
              ),
            ),
            cvvCodeDecoration: InputDecoration(
              labelText: 'CVV',
              hintText: 'XXX',
              labelStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[50],
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
                borderSide: const BorderSide(
                  color: AppColors.primaryGold,
                  width: 2,
                ),
              ),
            ),
            cardHolderDecoration: InputDecoration(
              labelText: 'Card Holder Name',
              hintText: 'John Doe',
              labelStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[50],
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
                borderSide: const BorderSide(
                  color: AppColors.primaryGold,
                  width: 2,
                ),
              ),
            ),
          ),
          onCreditCardModelChange: (CreditCardModel creditCardModel) {
            setState(() {
              _cardNumber = creditCardModel.cardNumber;
              _expiryDate = creditCardModel.expiryDate;
              _cardHolderName = creditCardModel.cardHolderName;
              _cvvCode = creditCardModel.cvvCode;
              _isCvvFocused = creditCardModel.isCvvFocused;
            });
          },
        ),
      ],
    );
  }

  /// ============================================
  /// Wallet Form
  /// ============================================
  Widget _buildWalletForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!, width: 1),
      ),
      child: Column(
        children: [
          Icon(Icons.phone_android, size: 64, color: Colors.blue[400]),
          const SizedBox(height: 16),
          const Text(
            'Mobile Wallet Payment',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pay using Vodafone Cash, Fawry, or other wallets',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            onChanged: (value) => setState(() => _walletNumber = value),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Mobile Number',
              hintText: '01XXXXXXXXX',
              prefixIcon: const Icon(Icons.phone),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primaryGold,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Cash Payment Info
  /// ============================================
  Widget _buildCashPaymentInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange[200]!, width: 1),
      ),
      child: Column(
        children: [
          Icon(Icons.money, size: 64, color: Colors.orange[400]),
          const SizedBox(height: 16),
          const Text(
            'Cash Payment',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Pay cash directly to vendors or on event day',
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Vendors will collect payment directly from you',
                    style: TextStyle(fontSize: 12, color: Colors.orange[900]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Payment Button
  /// ============================================
  Widget _buildPaymentButton(EventModel event) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _isProcessing ? null : () => _processPayment(event),
        icon: const Icon(Icons.lock, size: 20),
        label: Text(
          _isProcessing
              ? 'Processing...'
              : _selectedPaymentMethod == 'cash'
                  ? 'Confirm Booking'
                  : 'Pay EGP ${_formatNumber(_depositAmount.toInt())}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGold,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[400],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
    );
  }

  /// ============================================
  /// Error Widget
  /// ============================================
  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          const Text(
            'Failed to load event',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadEventData,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// ============================================
  /// Process Payment
  /// ============================================
  void _processPayment(EventModel event) {
    debugPrint('💳 Processing payment...');

    // Validation
    if (_selectedPaymentMethod == 'card') {
      if (!_formKey.currentState!.validate()) {
        _showError('Please fill all card details');
        return;
      }
    } else if (_selectedPaymentMethod == 'wallet') {
      if (_walletNumber.isEmpty) {
        _showError('Please enter your wallet number');
        return;
      }
    }

    setState(() => _isProcessing = true);

    // Show Processing Dialog
    _showProcessingDialog(event);
  }

  /// ============================================
  /// Processing Dialog
  /// ============================================
  void _showProcessingDialog(EventModel event) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.primaryGold),
              ),
              const SizedBox(height: 24),
              const Text(
                'Processing Payment...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please wait while we process your payment',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
      _showSuccessDialog(event);
    });
  }

  /// ============================================
  /// Success Dialog
  /// ============================================
  void _showSuccessDialog(EventModel event) {
    // ✅ Update Payment Status
    context.read<EventOwnerCubit>().updatePaymentStatus(
      eventId: event.eventId,
      paymentStatus: _selectedDepositOption == 'full'
          ? PaymentStatus.paid
          : PaymentStatus.partiallyPaid,
      paidAmount: _depositAmount,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Payment Successful! ✅',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your event has been booked successfully',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _isProcessing = false);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGold,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Go to Dashboard',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ============================================
  /// Helper Methods
  /// ============================================
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
    setState(() => _isProcessing = false);
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
