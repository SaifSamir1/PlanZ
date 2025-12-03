// lib/features/event_owners/event_owner_home/ui/screens/payment_history.dart

import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/core/widgets/custom_app_bar.dart';
import 'package:plan_z/features/auth/data/models/user_manager.dart';
import 'package:plan_z/features/event_owners/create_event_screen/cubits/create_event_cubit/create_event_cubit.dart';
import 'package:plan_z/features/event_owners/create_event_screen/cubits/create_event_cubit/create_event_state.dart';

import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_model_enum.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({super.key});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  @override
  void initState() {
    super.initState();
    _loadPaymentData();
  }

  void _loadPaymentData() {
    final ownerId = UserManager().userId;
    debugPrint('🔄 [PaymentHistory._loadPaymentData] Starting...');
    debugPrint('   Owner ID: $ownerId');
    if (ownerId != null) {
      debugPrint('   ✅ Calling getEventOwnerEvents($ownerId)');
      context.read<EventOwnerCubit>().getEventOwnerEvents(ownerId);
    } else {
      debugPrint('   ❌ Owner ID is null!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'event_owner.payment_history.title'.tr(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              child: Text(
                UserManager().getUserInitials(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<EventOwnerCubit, EventOwnerState>(
        builder: (context, state) {
          // Loading
          if (state is GetEventOwnerEventsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryGold,
                ),
              ),
            );
          }

          // Error
          if (state is GetEventOwnerEventsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('event_owner.payment_history.failed_load'.tr()),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _loadPaymentData,
                    child: Text('event_owner.payment_history.retry'.tr()),
                  ),
                ],
              ),
            );
          }

          // Success
          if (state is GetEventOwnerEventsSuccess) {
            // Filter paid events
            final paidEvents =
                state.events.where((e) => e.paidAmount > 0).toList()
                  ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

            final totalPaid = paidEvents.fold<double>(
              0,
              (sum, e) => sum + e.paidAmount,
            );
            final fullyPaidCount = paidEvents
                .where((e) => e.paymentStatus == PaymentStatus.paid)
                .length;
            final partiallyPaidCount = paidEvents
                .where((e) => e.paymentStatus == PaymentStatus.partiallyPaid)
                .length;
            final formattedAmount = totalPaid.toStringAsFixed(2);

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Balance Card
                    _buildBalanceCard(
                      formattedAmount,
                      fullyPaidCount,
                      partiallyPaidCount,
                    ),
                    const SizedBox(height: 24),
                    // Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'event_owner.payment_history.transactions'.tr(),
                            style: AppTextStyles.title.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${paidEvents.length} ${'event_owner.payment_history.events_suffix'.tr()}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Transactions List
                    if (paidEvents.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            children: [
                              Icon(
                                Icons.payment_outlined,
                                size: 64,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'event_owner.payment_history.no_transactions'
                                    .tr(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...paidEvents.map((event) {
                        final formattedDate = DateFormat(
                          'MMM d, yyyy',
                        ).format(event.updatedAt);
                        final formattedTime = DateFormat(
                          'hh:mm a',
                        ).format(event.updatedAt);
                        final statusKey =
                            event.paymentStatus == PaymentStatus.paid
                            ? 'event_owner.payment_history.completed'
                            : 'event_owner.payment_history.partial';
                        final statusLabel = statusKey.tr();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildTransactionCard(
                            date: formattedDate,
                            time: formattedTime,
                            title: 'event_owner.payment_history.event_payment'
                                .tr(),
                            subtitle: event.eventName,
                            amount:
                                'EGP ${event.paidAmount.toStringAsFixed(2)}',
                            status: statusLabel,
                            statusColor:
                                event.paymentStatus == PaymentStatus.paid
                                ? AppColors.success
                                : AppColors.warning,
                            icon: Icons.event_available,
                            iconBgColor:
                                (event.paymentStatus == PaymentStatus.paid
                                        ? AppColors.success
                                        : AppColors.warning)
                                    .withOpacity(0.1),
                          ),
                        );
                      }).toList(),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBalanceCard(
    String formattedAmount,
    int fullyPaidCount,
    int partiallyPaidCount,
  ) {
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
              Expanded(
                child: Text(
                  'event_owner.payment_history.total_received'.tr(),
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'EGP $formattedAmount',
            style: AppTextStyles.title.copyWith(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.check_circle,
                  label: 'event_owner.payment_history.fully_paid'.tr(),
                  value: '$fullyPaidCount events',
                  iconColor: AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.schedule,
                  label: 'Partial',
                  value: '$partiallyPaidCount events',
                  iconColor: AppColors.warning,
                ),
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
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
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
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: statusColor, size: 24),
                    ),
                    const SizedBox(width: 16),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          amount,
                          style: AppTextStyles.price.copyWith(
                            color: isPositive
                                ? AppColors.success
                                : AppColors.textPrimary,
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
