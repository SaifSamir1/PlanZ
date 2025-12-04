import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';

class WelcomeWidget extends StatelessWidget {
  const WelcomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "welcome.welcome_to".tr(),
            style: AppTextStyles.headline1.copyWith(color: Colors.black),
          ),
          Text(
            "welcome.app_name".tr(),
            style: AppTextStyles.headline1.copyWith(color: Color(0xFF21225b)),
          ),
          SizedBox(height: 10),
          Text(
            "welcome.desc_1".tr(),
            style: AppTextStyles.caption.copyWith(
              color: Color(0xFF565d6d),
              fontSize: 16,
            ),
          ),
          Text(
            "welcome.desc_2".tr(),
            style: AppTextStyles.caption.copyWith(
              color: Color(0xFF565d6d),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
