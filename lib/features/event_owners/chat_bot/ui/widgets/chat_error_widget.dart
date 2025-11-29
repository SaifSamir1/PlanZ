// lib/features/event_owners/chat_bot/ui/widgets/chat_error_widget.dart

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class ChatErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ChatErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeIn(
        duration: const Duration(milliseconds: 600),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(45),
                  border: Border.all(color: AppColors.error.withOpacity(0.2), width: 2),
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.error,
                  size: 40,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'حدث خطأ غير متوقع',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: TextStyle(
                  color: AppColors.blue400,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryGold, AppColors.gold600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGold.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onRetry,
                    borderRadius: BorderRadius.circular(26),
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            'إعادة المحاولة',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
