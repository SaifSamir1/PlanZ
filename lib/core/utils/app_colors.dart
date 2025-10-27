import 'package:flutter/material.dart';

class AppColors {
  // الألوان الأساسية
  //static const Color primaryDark = Color(0xFF21225B); // الأزرق الداكن
  static const Color primaryDark = Color(0xff21225b);
  static const Color primaryGold = Color(0xffcba13b); // الأصفر الذهبي

  // درجات متدرجة من الأزرق الداكن (من الفاتح إلى الداكن)
  static const Color blue50 = Color(0xFFF0F1FF);
  static const Color blue100 = Color(0xFFD9DAF5);
  static const Color blue200 = Color(0xFFB3B5EC);
  static const Color blue300 = Color(0xFF8C8FE2);
  static const Color blue400 = Color(0xFF666AD9);
  static const Color blue500 = Color(0xFF4045CF);
  static const Color blue600 = Color(0xFF21225B); // = primaryDark
  static const Color blue700 = Color(0xFF191A4F);
  static const Color blue800 = Color(0xFF111242);
  static const Color blue900 = Color(0xFF090A36);

  // درجات متدرجة من الأصفر الذهبي (من الفاتح إلى الداكن)
  static const Color gold50 = Color(0xFFFEFBEB);
  static const Color gold100 = Color(0xFFFDF4C4);
  static const Color gold200 = Color(0xFFFCE99D);
  static const Color gold300 = Color(0xFFFADD75);
  static const Color gold400 = Color(0xFFF9D14E);
  static const Color gold500 = Color(0xFFF8C726);
  static const Color gold600 = Color(0xFFE3C100); // = primaryGold
  static const Color gold700 = Color(0xFFCCAD00);
  static const Color gold800 = Color(0xFFB49800);
  static const Color gold900 = Color(0xFF9C8300);

  // ألوان ثانوية مكملة
  static const Color accentRed = Color(0xFFE63946); // للأخطاء والإلغاء
  static const Color accentGreen = Color(0xFF2A9D8F); // للنجاح والتأكيد
  static const Color accentPurple = Color(0xFF9D4EDD); // للتميز
  static const Color neutralGray = Color(0xFF6C757D); // للنصوص الثانوية
  static const Color lightGray = Color(0xFFF8F9FA); // للخلفيات
  static const Color darkGray = Color(0xFF343A40); // للنصوص الداكنة

  // ألوان للنصوص
  //static const Color textPrimary = blue900; // للعناوين الرئيسية
  static const Color textPrimary = Color(0xff21225b);
  static const Color textSecondary = darkGray; // للنصوص العادية
  static const Color textLight = Color(0xFFFFFFFF); // للنصوص على خلفيات داكنة
  static const Color textHint = blue200; // للنصوص التوضيحية

  // ألوان للخلفيات
  static const Color background = Color(0xFFFFFFFF);
  static const Color cardBackground = lightGray;
  static const Color surface = Color(0xFFF5F5F5);

  // ألوان للتفاعلات
  static const Color buttonPrimary = primaryGold;
  static const Color buttonSecondary = blue600;
  static const Color buttonDisabled = blue100;
  static const Color link = blue500;
  static const Color icon = blue700;

  // ألوان للحالات
  static const Color success = accentGreen;
  static const Color error = accentRed;
  static const Color warning = gold500;
  static const Color info = blue400;

  // ألوان للظلال (للتأثيرات البصرية)
  static const Color shadow = Color(0x1A000000); // 10% شفافية
  static const Color shadowDark = Color(0x33000000); // 20% شفافية

  // دالة للحصول على درجة متدرجة من الأزرق
  static Color getBlueShade(int shade) {
    switch (shade) {
      case 50:
        return blue50;
      case 100:
        return blue100;
      case 200:
        return blue200;
      case 300:
        return blue300;
      case 400:
        return blue400;
      case 500:
        return blue500;
      case 600:
        return blue600;
      case 700:
        return blue700;
      case 800:
        return blue800;
      case 900:
        return blue900;
      default:
        return blue600;
    }
  }

  // دالة للحصول على درجة متدرجة من الأصفر
  static Color getGoldShade(int shade) {
    switch (shade) {
      case 50:
        return gold50;
      case 100:
        return gold100;
      case 200:
        return gold200;
      case 300:
        return gold300;
      case 400:
        return gold400;
      case 500:
        return gold500;
      case 600:
        return gold600;
      case 700:
        return gold700;
      case 800:
        return gold800;
      case 900:
        return gold900;
      default:
        return gold600;
    }
  }
}
