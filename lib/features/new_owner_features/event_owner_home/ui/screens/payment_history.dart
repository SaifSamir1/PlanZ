// lib/features/new_owner_features/event_owner_home/ui/screens/payment_history.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';

class PaymentHistory extends StatelessWidget {
  const PaymentHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Payment History',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundImage: const AssetImage(
                'assets/images/undraw_female-avatar_7t6k.png',
              ),
              radius: 18,
              backgroundColor: AppColors.primaryGold.withOpacity(0.2),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Balance Card
              _buildBalanceCard(),
              
              const SizedBox(height: 24),
              
              // Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: AppTextStyles.title.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // Filter functionality
                    },
                    icon: const Icon(
                      Icons.filter_list,
                      size: 18,
                      color: AppColors.primaryGold,
                    ),
                    label: const Text(
                      'Filter',
                      style: TextStyle(color: AppColors.primaryGold),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Transactions List
              _buildTransactionCard(
                date: '28 Jul 2024',
                time: '03:45 PM',
                title: 'Event Payment Received',
                subtitle: 'Wedding Event',
                amount: '+\$2,500.00',
                status: 'Completed',
                statusColor: AppColors.success,
                icon: Icons.event_available,
                iconBgColor: AppColors.success.withOpacity(0.1),
              ),
              
              const SizedBox(height: 12),
              
              _buildTransactionCard(
                date: '27 Jul 2024',
                time: '11:20 AM',
                title: 'Withdrawal to Bank',
                subtitle: 'Bank Account •••• 4532',
                amount: '-\$150.00',
                status: 'Pending',
                statusColor: AppColors.warning,
                icon: Icons.account_balance,
                iconBgColor: AppColors.warning.withOpacity(0.1),
              ),
              
              const SizedBox(height: 12),
              
              _buildTransactionCard(
                date: '25 Jul 2024',
                time: '09:15 AM',
                title: 'Top-up from Credit Card',
                subtitle: 'Visa •••• 1234',
                amount: '+\$1,500.00',
                status: 'Completed',
                statusColor: AppColors.success,
                icon: Icons.credit_card,
                iconBgColor: AppColors.success.withOpacity(0.1),
              ),
              
              const SizedBox(height: 12),
              
              _buildTransactionCard(
                date: '24 Jul 2024',
                time: '02:30 PM',
                title: 'Event Expense',
                subtitle: 'Decorations Package',
                amount: '-\$75.20',
                status: 'Failed',
                statusColor: AppColors.error,
                icon: Icons.error_outline,
                iconBgColor: AppColors.error.withOpacity(0.1),
              ),
              
              const SizedBox(height: 12),
              
              _buildTransactionCard(
                date: '22 Jul 2024',
                time: '05:00 PM',
                title: 'Vendor Payment',
                subtitle: 'Catering Service',
                amount: '-\$850.00',
                status: 'Completed',
                statusColor: AppColors.success,
                icon: Icons.restaurant,
                iconBgColor: AppColors.success.withOpacity(0.1),
              ),
              
              const SizedBox(height: 12),
              
              _buildTransactionCard(
                date: '20 Jul 2024',
                time: '12:45 PM',
                title: 'Refund Received',
                subtitle: 'Photography Service',
                amount: '+\$320.00',
                status: 'Completed',
                statusColor: AppColors.success,
                icon: Icons.refresh,
                iconBgColor: AppColors.success.withOpacity(0.1),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            AppColors.primaryDark.withOpacity(0.8),
            const Color(0xff2d2f70),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: AppColors.primaryGold,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Total Balance',
                style: AppTextStyles.body.copyWith(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Balance Amount
          Text(
            '\$2,500.00',
            style: AppTextStyles.title.copyWith(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Stats Row
          Row(
            children: [
              _buildStatItem(
                icon: Icons.arrow_upward,
                label: 'Income',
                value: '\$4,320',
                iconColor: AppColors.success,
              ),
              const SizedBox(width: 24),
              _buildStatItem(
                icon: Icons.arrow_downward,
                label: 'Expense',
                value: '\$1,820',
                iconColor: AppColors.error,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: Colors.white.withOpacity(0.7),
                fontSize: 11,
              ),
            ),
            Text(
              value,
              style: AppTextStyles.body.copyWith(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionCard({
    required String date,
    required String time,
    required String title,
    required String subtitle,
    required String amount,
    required String status,
    required Color statusColor,
    required IconData icon,
    required Color iconBgColor,
  }) {
    final bool isPositive = amount.startsWith('+');
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textSecondary.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to transaction details
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        color: statusColor,
                        size: 24,
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Title & Subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Amount
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          amount,
                          style: AppTextStyles.price.copyWith(
                            color: isPositive ? AppColors.success : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            status,
                            style: AppTextStyles.body.copyWith(
                              color: statusColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Date & Time
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textSecondary.withOpacity(0.6),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$date • $time',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
