// lib/features/attendee/presentation/widgets/invitation_details/guest_count_input.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plan_z/core/theming/text_styles.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class GuestCountInput extends StatelessWidget {
  final TextEditingController controller;
  final int maxGuests;

  const GuestCountInput({
    super.key,
    required this.controller,
    required this.maxGuests,
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
                  Icons.people_rounded,
                  color: AppColors.buttonPrimary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  "How many guests will attend?",
                  style: AppTextStyles.subtitle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            Text(
              "Maximum allowed: $maxGuests ${maxGuests == 1 ? 'guest' : 'guests'}",
              style: AppTextStyles.caption.copyWith(
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                hintText: "Enter number of guests",
                prefixIcon: Icon(
                  Icons.person_add_rounded,
                  color: AppColors.buttonPrimary,
                ),
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
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter guest count";
                }
                final count = int.tryParse(value);
                if (count == null || count <= 0) {
                  return "Please enter a valid number";
                }
                if (count > maxGuests) {
                  return "Maximum $maxGuests guests allowed";
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
