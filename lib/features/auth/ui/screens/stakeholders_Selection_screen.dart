import 'package:flutter/material.dart';
import 'package:plan_z/core/utils/app_colors.dart';
import 'package:plan_z/features/auth/ui/widgets/stakeholders_screen_content.dart';

class StakeholdersSelectionScreen extends StatelessWidget {
  const StakeholdersSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: StakeholdersScreenContent()),
      backgroundColor: AppColors.background,
    );
  }
}
