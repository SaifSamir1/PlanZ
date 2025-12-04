// lib/features/on_boarding/ui/screens/stakeholders_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/on_boarding/ui/widgets/stake_holders_widget/stakeholders_screen_content.dart';
import 'package:plan_z/features/on_boarding/ui/widgets/language_selector_button.dart';

class StakeholdersSelectionScreen extends StatelessWidget {
  const StakeholdersSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Original content
            const StakeholdersScreenContent(),

            // Language Selector
            const Positioned(
              top: 40,
              right: 16,
              child: LanguageSelectorButton(),
            ),
          ],
        ),
      ),
    );
  }
}
