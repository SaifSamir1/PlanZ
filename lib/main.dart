import 'package:flutter/material.dart';
import 'package:plan_z/features/owner_features/owner_ui/screens/navigation_screen.dart';
import 'package:plan_z/notification_screen.dart';
import 'package:plan_z/vendor_home_screen.dart';

void main() {
  runApp(const PlanZ());
}

class PlanZ extends StatelessWidget {
  const PlanZ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plan Z',
      home: NavigationScreen()
    );
  }
}
