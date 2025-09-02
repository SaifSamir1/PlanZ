import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_stayls.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class AppTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;
  final AutovalidateMode? autovalidateMode;
  final Color? fillColor;
  final bool filled;

  const AppTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding,
    this.focusNode,
    this.autovalidateMode,
    this.fillColor,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      validator: validator,
      focusNode: focusNode,
      autovalidateMode: autovalidateMode,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.withColor(
          AppTextStyles.caption,
          AppColors.textHint,
        ),
        labelText: labelText,
        labelStyle: AppTextStyles.caption,
        errorText: errorText,
        errorStyle: AppTextStyles.withColor(
          AppTextStyles.caption,
          AppColors.error,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        filled: filled,
        fillColor: fillColor ?? AppColors.cardBackground,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.blue200, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.primaryGold, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.error, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.blue100, width: 1.0),
        ),
      ),
    );
  }
}
