import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';

class AppTextStyles {
  // أحجام نصوص قياسية (ثوابت)
  static const double _sizeHeadline1 = 32.0;
  static const double _sizeHeadline2 = 24.0;
  static const double _sizeHeadline3 = 20.0;
  static const double _sizeTitle = 18.0;
  static const double _sizeSubtitle = 16.0;
  static const double _sizeBody = 14.0;
  static const double _sizeCaption = 12.0;
  static const double _sizeOverline = 10.0;

  // أوزان الخطوط القياسية
  static const FontWeight _bold = FontWeight.bold;
  static const FontWeight _semiBold = FontWeight.w600;
  static const FontWeight _medium = FontWeight.w500;
  static const FontWeight _regular = FontWeight.w400;

  // === أنماط النصوص الأساسية (بدون تخصيص) ===

  // عناوين رئيسية (Headlines)
  static TextStyle get headline1 => TextStyle(
    fontSize: _sizeHeadline1,
    fontWeight: _bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle get headline2 => TextStyle(
    fontSize: _sizeHeadline2,
    fontWeight: _bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle get headline3 => TextStyle(
    fontSize: _sizeHeadline3,
    fontWeight: _semiBold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // عناوين فرعية (Titles)
  static TextStyle get title => TextStyle(
    fontSize: _sizeTitle,
    fontWeight: _semiBold,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle get subtitle => TextStyle(
    fontSize: _sizeSubtitle,
    fontWeight: _medium,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // نصوص الجسم (Body)
  static TextStyle get body => TextStyle(
    fontSize: _sizeBody,
    fontWeight: _regular,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static TextStyle get bodyBold => TextStyle(
    fontSize: _sizeBody,
    fontWeight: _medium,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // نصوص صغيرة (Captions)
  static TextStyle get caption => TextStyle(
    fontSize: _sizeCaption,
    fontWeight: _regular,
    color: AppColors.textHint,
    height: 1.4,
  );

  static TextStyle get overline => TextStyle(
    fontSize: _sizeOverline,
    fontWeight: _medium,
    color: AppColors.textHint,
    letterSpacing: 1.5,
    height: 1.4,
  );

  // === أنماط نصوص قابلة للتخصيص (Methods) ===

  // method لتخصيص حجم النص مع الحفاظ على الخصائص الأخرى
  static TextStyle customSize({
    required double size,
    Color? color,
    FontWeight? weight,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontSize: size,
      color: color ?? AppColors.textSecondary,
      fontWeight: weight ?? _regular,
      height: height ?? 1.4,
      letterSpacing: letterSpacing,
    );
  }

  // method لتخصيص لون النص مع الحفاظ على الحجم الافتراضي
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  // method لتخصيص وزن النص
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  // method للحصول على نص بحجم مخصص مع لون مخصص
  static TextStyle sizeAndColor(
    double size,
    Color color, {
    FontWeight? weight,
  }) {
    return TextStyle(
      fontSize: size,
      color: color,
      fontWeight: weight ?? _regular,
      height: 1.4,
    );
  }

  // === أنماط خاصة بالحالات (Success/Error/Warning) ===

  static TextStyle get success => withColor(bodyBold, AppColors.success);
  static TextStyle get error => withColor(bodyBold, AppColors.error);
  static TextStyle get warning => withColor(bodyBold, AppColors.warning);
  static TextStyle get info => withColor(bodyBold, AppColors.info);

  // === أنماط خاصة بالأزرار والروابط ===

  static TextStyle get button => TextStyle(
    fontSize: _sizeSubtitle,
    fontWeight: _semiBold,
    color: AppColors.textLight,
    height: 1.2,
  );

  static TextStyle get link => TextStyle(
    fontSize: _sizeBody,
    fontWeight: _medium,
    color: AppColors.link,
    height: 1.4,
    decoration: TextDecoration.underline,
  );

  // === أنماط خاصة بالأسعار والأرقام ===

  static TextStyle get price => TextStyle(
    fontSize: _sizeTitle,
    fontWeight: _bold,
    color: AppColors.primaryGold,
    height: 1.2,
  );

  static TextStyle get discount => TextStyle(
    fontSize: _sizeCaption,
    fontWeight: _bold,
    color: AppColors.error,
    decoration: TextDecoration.lineThrough,
  );

  // === دعم الـ RTL (للغة العربية) ===

  static TextStyle get arabicHeadline => headline1.copyWith(
    fontFamily: 'Cairo', // استخدم خط عربي مناسب
  );

  static TextStyle get arabicBody => body.copyWith(fontFamily: 'Cairo');
}
