import 'package:flutter/material.dart';
import 'package:plan_z/features/auth/ui/widgets/welcome_widget.dart';

class StakeholdersScreenContent extends StatelessWidget {
  const StakeholdersScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [Image.asset("assets/images/logo.jpg"), WelcomeWidget()],
    );
  }
}
