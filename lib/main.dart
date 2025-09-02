import 'package:flutter/material.dart';
import 'package:plan_z/features/auth/ui/screens/stakeholders_Selection_screen.dart';

void main() {
  runApp(const PlanZ());
}

class PlanZ extends StatelessWidget {
  const PlanZ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: StakeholdersSelectionScreen()),
    );
  }
}
