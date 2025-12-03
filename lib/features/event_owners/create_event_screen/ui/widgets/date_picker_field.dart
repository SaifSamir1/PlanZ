
// lib/features/events/presentation/widgets/date_picker_field.dart
// lib/features/events/presentation/widgets/date_picker_field.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final String hint;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final String? Function(String?)? validator;

  const DatePickerField({
    super.key,
    required this.label,
    required this.hint,
    required this.selectedDate,
    required this.onDateSelected,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),

        // Date Picker Field
        TextFormField(
          readOnly: true,
          validator: validator,
          onTap: () => _selectDate(context),
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: selectedDate != null
                ? _formatDate(selectedDate!)
                : hint,
            hintStyle: TextStyle(
              fontSize: 14,
              color: selectedDate != null
                  ? AppColors.textPrimary
                  : AppColors.textSecondary.withOpacity(0.6),
            ),
            prefixIcon: const Icon(
              Icons.calendar_today,
              color: AppColors.primaryGold,
              size: 22,
            ),
            suffixIcon: selectedDate != null
                ? IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () {
                      // Clear selection by calling with a null-equivalent date
                      // Or you can add a callback for clearing
                    },
                  )
                : null,
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.blue100,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.blue100,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryGold,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  /// Format date without intl package
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)), // 2 years
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGold,
              onPrimary: AppColors.textPrimary,
              surface: AppColors.background,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }
}

