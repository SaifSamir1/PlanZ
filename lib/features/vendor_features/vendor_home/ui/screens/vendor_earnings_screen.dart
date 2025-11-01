// lib/features/vendor_features/earnings/ui/screens/vendor_earnings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/auth/data/models/user_manager.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/cubit/vendor_cubit.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/cubit/vendor_state.dart';

class VendorEarningsScreen extends StatefulWidget {
  const VendorEarningsScreen({super.key});

  @override
  State<VendorEarningsScreen> createState() => _VendorEarningsScreenState();
}

class _VendorEarningsScreenState extends State<VendorEarningsScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _walletController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  String _selectedWalletType = 'vodafone_cash';
  double _availableBalance = 0.0;
  
  // ✅ Track field validation WITHOUT calling validate()
  bool _amountValid = false;
  bool _walletValid = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    
    // ✅ استمع للتغييرات وتحقق من الـ validation بدون ما تنادي validate()
    _amountController.addListener(_updateAmountValidity);
    _walletController.addListener(_updateWalletValidity);
  }

  void _updateAmountValidity() {
    setState(() {
      _amountValid = _validateAmountLogic(_amountController.text) == null;
    });
  }

  void _updateWalletValidity() {
    setState(() {
      _walletValid = _validateWalletLogic(_walletController.text) == null;
    });
  }

  void _loadData() {
    final userManager = UserManager();
    final vendorId = userManager.userId!;
    
    context.read<VendorCubit>().getVendorBalance(vendorId);
    context.read<VendorCubit>().getTransactionHistory(vendorId);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _walletController.dispose();
    super.dispose();
  }

  void _showWithdrawalBottomSheet() {
    _resetForm();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildWithdrawalSheet(),
    );
  }

  void _resetForm() {
    _amountController.clear();
    _walletController.clear();
    _selectedWalletType = 'vodafone_cash';
    _amountValid = false;
    _walletValid = false;
  }

  // ✅ ONLY for TextFormField validator (NOT called in build)
  String? _validateAmount(String? value) {
    return _validateAmountLogic(value);
  }

  // ✅ Actual validation logic (safe to call anytime)
  String? _validateAmountLogic(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter an amount';
    }

    final amount = double.tryParse(value!);
    if (amount == null) {
      return 'Please enter a valid amount';
    }

    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }

    if (amount > _availableBalance) {
      return 'Insufficient balance. Available: EGP ${_availableBalance.toStringAsFixed(2)}';
    }

    return null;
  }

  String? _validateWalletNumber(String? value) {
    return _validateWalletLogic(value);
  }

  String? _validateWalletLogic(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Wallet number is required';
    }

    if (value!.length < 10) {
      return 'Wallet number must be at least 10 characters';
    }

    return null;
  }

  // ✅ Check overall form validity WITHOUT calling validate()
  bool _isFormCompletelyValid() {
    return _amountValid && _walletValid && _selectedWalletType.isNotEmpty;
  }

  Widget _buildWithdrawalSheet() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  Text(
                    'Request Withdrawal',
                    style: AppTextStyles.title.copyWith(
                      fontSize: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Available Balance
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryGold.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Available Balance:',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          'EGP ${_availableBalance.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Amount Field
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    validator: _validateAmount,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (_) => setState(() {
                      _updateAmountValidity();
                    }),
                    decoration: InputDecoration(
                      labelText: 'Amount (EGP)*',
                      hintText: 'Enter amount',
                      prefixIcon: const Icon(Icons.attach_money),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
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
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Wallet Type
                  DropdownButtonFormField<String>(
                    value: _selectedWalletType,
                    decoration: InputDecoration(
                      labelText: 'Wallet Type*',
                      prefixIcon: const Icon(Icons.account_balance_wallet),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
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
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'vodafone_cash',
                        child: Text('Vodafone Cash'),
                      ),
                      DropdownMenuItem(
                        value: 'etisalat',
                        child: Text('Etisalat'),
                      ),
                      DropdownMenuItem(
                        value: 'orange',
                        child: Text('Orange'),
                      ),
                      DropdownMenuItem(
                        value: 'we',
                        child: Text('WE'),
                      ),
                      DropdownMenuItem(
                        value: 'bank_account',
                        child: Text('Bank Account'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedWalletType = value ?? 'vodafone_cash');
                    },
                  ),
                  const SizedBox(height: 16),

                  // Wallet Number
                  TextFormField(
                    controller: _walletController,
                    keyboardType: TextInputType.phone,
                    validator: _validateWalletNumber,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (_) => setState(() {
                      _updateWalletValidity();
                    }),
                    decoration: InputDecoration(
                      labelText: _selectedWalletType == 'bank_account'
                          ? 'Account Number*'
                          : 'Wallet Number*',
                      hintText: 'Enter number',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
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
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Submit Button - SAFE NOW!
                  BlocBuilder<VendorCubit, VendorState>(
                    builder: (context, state) {
                      final isLoading = state is RequestWithdrawalLoading;
                      final isValid = _isFormCompletelyValid();

                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (isValid && !isLoading)
                              ? _submitWithdrawal
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (isValid && !isLoading)
                                ? AppColors.primaryGold
                                : Colors.grey[400],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            disabledBackgroundColor: Colors.grey[400],
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(Colors.white),
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  isValid
                                      ? 'Request Withdrawal'
                                      : 'Fill all fields correctly',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _submitWithdrawal() {
    // ✅ NOW we can call validate() safely after button press
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Please fix all errors first'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final userManager = UserManager();
    context.read<VendorCubit>().requestWithdrawal(
      vendorId: userManager.userId!,
      amount: double.parse(_amountController.text),
      walletNumber: _walletController.text.trim(),
      walletType: _selectedWalletType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Earnings & Wallet',
        showBackButton: true,
      ),
      body: BlocListener<VendorCubit, VendorState>(
        listener: (context, state) {
          if (state is GetVendorBalanceSuccess) {
            setState(() {
              _availableBalance = state.balance;
            });
          } else if (state is RequestWithdrawalSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Withdrawal request sent successfully!'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            _resetForm();
            _loadData();
          } else if (state is RequestWithdrawalError) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ ${state.message}'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<VendorCubit, VendorState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state is GetVendorBalanceSuccess)
                    _buildBalanceCard(state.balance)
                  else if (state is GetVendorBalanceLoading)
                    _buildLoadingCard()
                  else if (state is GetVendorBalanceError)
                    _buildErrorCard(state.message)
                  else
                    _buildEmptyCard(),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _showWithdrawalBottomSheet,
                      icon: const Icon(Icons.send),
                      label: const Text('Request Withdrawal'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGold,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Transaction History',
                    style: AppTextStyles.headline3,
                  ),
                  const SizedBox(height: 12),

                  if (state is GetTransactionHistorySuccess)
                    _buildTransactionList(state.transactions)
                  else if (state is GetTransactionHistoryLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(
                          color: AppColors.primaryGold,
                        ),
                      ),
                    )
                  else if (state is GetTransactionHistoryError)
                    _buildTransactionError(state.message)
                  else
                    _buildEmptyTransactions(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildBalanceCard(double balance) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGold,
            AppColors.primaryGold.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGold.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Balance',
            style: AppTextStyles.body.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'EGP ${balance.toStringAsFixed(2)}',
            style: AppTextStyles.title.copyWith(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryGold,
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 32),
          const SizedBox(height: 8),
          Text(
            'Error: $message',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGold.withOpacity(0.15),
            AppColors.primaryGold.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryGold.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Balance',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'EGP 0.00',
            style: AppTextStyles.title.copyWith(
              color: AppColors.textPrimary,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTransactions() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            Icon(Icons.history, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'No transactions yet',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              'Failed to load transactions',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(List<Map<String, dynamic>> transactions) {
    if (transactions.isEmpty) {
      return _buildEmptyTransactions();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final isEarning = transaction['type'] == 'earning';
        final amount = transaction['amount'] as double;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isEarning
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isEarning ? Icons.arrow_downward : Icons.arrow_upward,
                color: isEarning ? Colors.green : Colors.red,
                size: 20,
              ),
            ),
            title: Text(transaction['title'] as String),
            subtitle: Text(
              'EGP ${amount.abs().toStringAsFixed(2)}',
              style: TextStyle(
                color: isEarning ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Chip(
              label: Text(
                transaction['status'] as String,
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor:
                  _getStatusColor(transaction['status'] as String),
              labelStyle: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    if (status.contains('Completed') || status.contains('COMPLETED')) {
      return Colors.green;
    } else if (status.contains('PENDING')) {
      return Colors.orange;
    } else if (status.contains('REJECTED')) {
      return Colors.red;
    }
    return Colors.grey;
  }
}
