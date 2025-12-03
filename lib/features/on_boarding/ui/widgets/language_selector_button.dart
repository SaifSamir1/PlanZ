import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/main.dart';

class LanguageSelectorButton extends StatelessWidget {
  const LanguageSelectorButton({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLanguage = context.locale.languageCode;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showLanguageDialog(context),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: EdgeInsets.all(4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.language, color: AppColors.primaryGold, size: 20),
                const SizedBox(width: 6),
                Text(
                  currentLanguage == 'en' ? 'EN' : 'AR',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final currentLanguage = context.locale.languageCode;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.language, color: AppColors.primaryGold, size: 28),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                'settings.select_language'.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(
              context: context,
              languageCode: 'en',
              languageName: 'English',
              flag: '🇺🇸',
              isSelected: currentLanguage == 'en',
            ),
            const SizedBox(height: 12),
            _buildLanguageOption(
              context: context,
              languageCode: 'ar',
              languageName: 'العربية',
              flag: '🇪🇬',
              isSelected: currentLanguage == 'ar',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'admin_access.cancel'.tr(),
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String languageCode,
    required String languageName,
    required String flag,
    required bool isSelected,
  }) {
    return Material(
      color: isSelected
          ? AppColors.primaryGold.withOpacity(0.1)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _changeLanguage(context, languageCode),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppColors.primaryGold : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text(flag, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  languageName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? AppColors.primaryGold
                        : AppColors.primaryDark,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: AppColors.primaryGold,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changeLanguage(
    BuildContext rootContext,
    String languageCode,
  ) async {
    final currentLanguage = rootContext.locale.languageCode;

    if (languageCode == currentLanguage) {
      Navigator.pop(rootContext);
      return;
    }

    // Close selection dialog
    Navigator.pop(rootContext);

    // Show loading dialog
    showDialog(
      context: rootContext,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppColors.primaryGold),
              const SizedBox(height: 16),
              Text(
                languageCode == 'ar'
                    ? 'جاري تغيير اللغة...'
                    : 'Changing language...',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Wait a bit for UX
    await Future.delayed(const Duration(milliseconds: 1000));

    // Change locale
    await rootContext.setLocale(Locale(languageCode));

    // Restart App
    if (rootContext.mounted) {
      PlanZ.restartApp(rootContext);
    }
  }
}
