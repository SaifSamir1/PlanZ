// lib/features/attendee/presentation/widgets/invitation_details/response_message_input.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class ResponseMessageInput extends StatelessWidget {
  final TextEditingController controller;

  const ResponseMessageInput({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.message_rounded,
                  color: AppColors.buttonPrimary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "Add a message (Optional)",
                  style: AppTextStyles.subtitle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            Text(
              "Send a personal message to the event host",
              style: AppTextStyles.caption.copyWith(
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: controller,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: "Write your message here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.buttonPrimary, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                counterStyle: AppTextStyles.caption.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
