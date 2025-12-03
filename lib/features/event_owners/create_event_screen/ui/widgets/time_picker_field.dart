
// lib/features/events/presentation/widgets/time_picker_field.dart


import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class TimePickerField extends StatelessWidget {
  final String label;
  final String hint;
  final TimeOfDay? selectedTime;
  final Function(TimeOfDay) onTimeSelected;
  final String? Function(String?)? validator;

  const TimePickerField({
    super.key,
    required this.label,
    required this.hint,
    required this.selectedTime,
    required this.onTimeSelected,
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

        // Time Picker Field
        TextFormField(
          readOnly: true,
          validator: validator,
          onTap: () => _selectTime(context),
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: selectedTime != null
                ? selectedTime!.format(context)
                : hint,
            hintStyle: TextStyle(
              fontSize: 14,
              color: selectedTime != null
                  ? AppColors.textPrimary
                  : AppColors.textSecondary.withOpacity(0.6),
            ),
            prefixIcon: const Icon(
              Icons.access_time,
              color: AppColors.primaryGold,
              size: 22,
            ),
            suffixIcon: selectedTime != null
                ? IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () => onTimeSelected(const TimeOfDay(hour: 18, minute: 0)),
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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? const TimeOfDay(hour: 18, minute: 0),
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
      onTimeSelected(picked);
    }
  }
}

