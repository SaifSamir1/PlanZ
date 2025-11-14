// ignore_for_file: deprecated_member_use

// lib/widgets/message_bubble.dart
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import '../../data/models/chat_models.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool showOptions;
  final VoidCallback? onOptionsVisible;

  const MessageBubble({
    super.key,
    required this.message,
    this.showOptions = false,
    this.onOptionsVisible,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      child: message.isBot ? _buildBotMessage() : _buildUserMessage(),
    );
  }

  Widget _buildBotMessage() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 80, top: 4, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBotAvatar(),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.blue50,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    border: Border.all(color: AppColors.blue100, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.text,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatRealTime(message.timestamp),
                        style: TextStyle(
                          color: AppColors.blue400,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserMessage() {
    return Container(
      margin: const EdgeInsets.only(left: 80, right: 16, top: 4, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryGold, AppColors.gold500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(4),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGold.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.text,
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatRealTime(message.timestamp),
                    style: TextStyle(
                      color: AppColors.textLight.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          _buildUserAvatar(),
        ],
      ),
    );
  }

  Widget _buildBotAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blue500, AppColors.blue600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue600.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.support_agent_rounded,
        color: AppColors.textLight,
        size: 20,
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryGold, AppColors.gold500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGold.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.person_rounded,
        color: AppColors.textLight,
        size: 20,
      ),
    );
  }

  // دالة تنسيق الوقت النهائية مع توقيت مصر و AM/PM
  String _formatRealTime(DateTime dateTime) {
    final localTime = dateTime.toLocal();
    
    final now = DateTime.now();
    final messageDate = DateTime(localTime.year, localTime.month, localTime.day);
    final todayDate = DateTime(now.year, now.month, now.day);
    
    // تنسيق الوقت مع AM/PM بالعربي
    String formatTimeWithAmPm(DateTime time) {
      final hour = time.hour;
      final minute = time.minute.toString().padLeft(2, '0');
      
      if (hour == 0) {
        return '12:$minute ص'; // منتصف الليل
      } else if (hour < 12) {
        return '$hour:$minute ص'; // صباحاً
      } else if (hour == 12) {
        return '12:$minute م'; // الظهر
      } else {
        return '${hour - 12}:$minute م'; // مساءً
      }
    }
    
    // إذا كان نفس اليوم
    if (messageDate == todayDate) {
      return formatTimeWithAmPm(localTime);
    }
    // إذا كان بالأمس
    else if (todayDate.difference(messageDate).inDays == 1) {
      return 'أمس ${formatTimeWithAmPm(localTime)}';
    }
    // إذا كان خلال الأسبوع الماضي
    else if (todayDate.difference(messageDate).inDays <= 7) {
      final weekDays = [
        'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 
        'الجمعة', 'السبت', 'الأحد'
      ];
      final dayName = weekDays[localTime.weekday - 1];
      return '$dayName ${formatTimeWithAmPm(localTime)}';
    }
    // إذا كان أكثر من أسبوع
    else {
      final dateStr = '${localTime.day}/${localTime.month}';
      return '$dateStr ${formatTimeWithAmPm(localTime)}';
    }
  }
}
