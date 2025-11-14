import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class TableRowWidget extends StatelessWidget {
  const TableRowWidget({
    super.key,
    required this.data1,
    required this.data2,
    required this.data3,
    required this.data4,
    required this.status,
  });

  final String data1;
  final String data2;
  final String data3;
  final String data4;

  final Color status;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              data1,
              style: AppTextStyles.body.copyWith(
                fontSize: 13,
                color: AppColors.primaryGold,
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              data2,
              style: AppTextStyles.body.copyWith(
                color: AppColors.primaryGold,
                fontSize: 13,
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              data3,
              style: AppTextStyles.body.copyWith(fontSize: 13),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              decoration: BoxDecoration(
                color: status,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Center(
                  child: Text(
                    data4,
                    style: AppTextStyles.body.copyWith(fontSize: 13),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
