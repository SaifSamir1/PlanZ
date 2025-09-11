import 'package:flutter/material.dart';
import 'package:plan_z/features/new_owner_features/screens/services_screen.dart';
import 'package:plan_z/features/onboarding/ui/screens/on_boarding_screen.dart';

void main() {
  runApp(const PlanZ());
}

class PlanZ extends StatelessWidget {
  const PlanZ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plan Z',
      home: ServicesScreen(),
    );
  }
}
