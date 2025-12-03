// lib/features/on_boarding/ui/screens/stakeholders_selection_screen.dart
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/auth/ui/screens/login_screen.dart';
import 'package:plan_z/features/auth/data/models/user_model.dart';
import 'package:plan_z/features/on_boarding/ui/widgets/stake_holders_widget/stakeholders_screen_content.dart';
import 'package:plan_z/core/constants/constants.dart';
import 'package:plan_z/features/on_boarding/ui/widgets/language_selector_button.dart';

class StakeholdersSelectionScreen extends StatefulWidget {
  const StakeholdersSelectionScreen({super.key});

  @override
  State<StakeholdersSelectionScreen> createState() =>
      _StakeholdersSelectionScreenState();
}

class _StakeholdersSelectionScreenState
    extends State<StakeholdersSelectionScreen> {
  int _secretTapCount = 0;
  DateTime? _lastTapTime;

  void _handleSecretAccess() {
    final now = DateTime.now();

    // Reset counter if more than 2 seconds passed
    if (_lastTapTime != null && now.difference(_lastTapTime!).inSeconds > 2) {
      _secretTapCount = 0;
    }

    _lastTapTime = now;
    _secretTapCount++;

    // Show admin access after 5 taps
    if (_secretTapCount >= 5) {
      _secretTapCount = 0;
      _showAdminAccessDialog();
    }
  }

  void _showAdminAccessDialog() {
    final TextEditingController accessCodeController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              Icons.admin_panel_settings,
              color: AppColors.primaryGold,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'admin_access.title'.tr(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'admin_access.subtitle'.tr(),
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: accessCodeController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'admin_access.hint'.tr(),
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.primaryGold,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('admin_access.cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              if (accessCodeController.text.trim() ==
                  AppSecrets.adminAccessCode) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const LoginScreen(userType: UserType.admin),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('onboarding.invalid_code'.tr()),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGold,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('admin_access.access'.tr()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        // Secret gesture - Tap 5 times in top-right corner
        onTap: _handleSecretAccess,
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          child: Stack(
            children: [
              // Original content
              const StakeholdersScreenContent(),

              // Language Selector
              const Positioned(
                top: 40, // Adjusted for SafeArea
                right: 16,
                child: LanguageSelectorButton(),
              ),

              // Secret indicator (optional - for debugging only)
              if (_secretTapCount > 0)
                Positioned(
                  top: 100, // Moved down to avoid overlap
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$_secretTapCount/5',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
