import 'package:flutter/material.dart';
import 'package:plan_z/core/theming/text_stayls.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
  final bool isLoading;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? padding;
  final BoxShadow? shadow;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
    this.borderSide,
    this.isLoading = false,
    this.prefixIcon,
    this.suffixIcon,
    this.padding,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    // القيم الافتراضية
    final defaultBackgroundColor = backgroundColor ?? AppColors.buttonPrimary;
    final defaultTextColor = textColor ?? AppColors.textLight;
    final defaultHeight = height ?? 50.0;
    final defaultBorderRadius = borderRadius ?? BorderRadius.circular(8.0);
    final defaultPadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0);

    return SizedBox(
      width: width,
      height: defaultHeight,
      child: MaterialButton(
        onPressed: isLoading ? null : onPressed,
        color: defaultBackgroundColor,
        disabledColor: AppColors.buttonDisabled,
        shape: RoundedRectangleBorder(
          borderRadius: defaultBorderRadius,
          side: borderSide ?? BorderSide.none,
        ),
        elevation: shadow != null ? 5.0 : 0.0,
        padding: defaultPadding,
        child: _buildButtonContent(defaultTextColor),
      ),
    );
  }

  Widget _buildButtonContent(Color textColor) {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefixIcon != null) ...[prefixIcon!, const SizedBox(width: 8.0)],
        Text(
          text,
          style: AppTextStyles.customSize(
            size: fontSize ?? 16.0,
            color: textColor,
            weight: fontWeight ?? FontWeight.w600,
          ),
        ),
        if (suffixIcon != null) ...[const SizedBox(width: 8.0), suffixIcon!],
      ],
    );
  }
}
