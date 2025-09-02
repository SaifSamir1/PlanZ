// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        color: AppColors.primaryGold,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10.0,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.2),
            blurRadius: 20.0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Image.asset('assets/images/app_logo.jpg', fit: BoxFit.contain),
    );
  }
}
