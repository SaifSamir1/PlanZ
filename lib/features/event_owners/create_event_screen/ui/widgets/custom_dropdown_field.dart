
// lib/features/events/presentation/widgets/custom_dropdown_field.dart

import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final IconData prefixIcon;
  final bool enabled;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.prefixIcon,
    this.enabled = true,
    required this.onChanged,
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

        // Dropdown Field
        DropdownButtonFormField<String>(
          value: value,
          validator: validator,
          onChanged: enabled ? onChanged : null,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
            );
          }).toList(),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withOpacity(0.6),
            ),
            prefixIcon: Icon(
              prefixIcon,
              color: enabled ? AppColors.primaryGold : AppColors.textSecondary,
              size: 22,
            ),
            filled: true,
            fillColor: enabled ? AppColors.background : AppColors.blue50,
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
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.textSecondary.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          dropdownColor: AppColors.background,
          icon: Icon(
            Icons.arrow_drop_down,
            color: enabled ? AppColors.primaryGold : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

