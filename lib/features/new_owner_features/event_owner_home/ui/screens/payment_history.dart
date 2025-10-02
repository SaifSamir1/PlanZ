import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/new_owner_features/event_owner_home/ui/screens/table_row.dart';

class PaymentHistory extends StatelessWidget {
  const PaymentHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment History', style: AppTextStyles.title),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage(
                'assets/images/undraw_female-avatar_7t6k.png',
              ),
              radius: 20,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      'Total History Balance :',
                      style: AppTextStyles.title,
                    ),
                    subtitle: Text('\$2500', style: AppTextStyles.price),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Recent Transactions',
                style: AppTextStyles.title.copyWith(
                  color: AppColors.primaryGold,
                ),
              ),
              SizedBox(height: 10),
              Table(
                border: TableBorder(borderRadius: BorderRadius.circular(20)),
                children: [
                  TableRow(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                'Date',
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                'Description',
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                'Amount',
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                'Status',
                                style: AppTextStyles.body.copyWith(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableRowWidget(
                        data1: '2024-07-28',
                        data2: 'Event payment received (Wedding)',
                        data3: '2500 \$',
                        data4: 'Completed',
                        status: AppColors.success,
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableRowWidget(
                        data1: '2024-07-27',
                        data2: 'Withdrawal to bank account',
                        data3: '-\$150.00',
                        data4: 'Pending',
                        status: AppColors.warning,
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableRowWidget(
                        data1: '2024-07-25',
                        data2: 'Top-up from credit card',
                        data3: '1500 \$',
                        data4: 'Completed',
                        status: AppColors.success,
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      TableRowWidget(
                        data1: '2024-07-24',
                        data2: 'Event expense (Decorations)',
                        data3: '-\$75.20',
                        data4: 'Failed',
                        status: AppColors.error,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
