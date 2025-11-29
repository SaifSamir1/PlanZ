// lib/features/event_owners/chat_bot/ui/widgets/chat_loading_widget.dart

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class ChatLoadingWidget extends StatelessWidget {
  const ChatLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeIn(
        duration: const Duration(milliseconds: 600),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.blue500, AppColors.blue600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(45),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blue600.withOpacity(0.3),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: const Icon(
                Icons.support_agent_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'جاري تحضير المحادثة...',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'سأكون معك خلال ثوانٍ',
              style: TextStyle(
                color: AppColors.blue400,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGold),
                strokeWidth: 4,
                backgroundColor: AppColors.gold100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
