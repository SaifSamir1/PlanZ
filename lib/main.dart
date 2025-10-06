import 'package:flutter/material.dart';
import 'package:plan_z/features/auth/ui/screens/owner_dashboard_screen.dart';
import 'package:plan_z/features/auth/ui/screens/vendor_dashboard_screen.dart';

void main() {
  runApp(const PlanZ());
}

class PlanZ extends StatelessWidget {
  const PlanZ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plan Z',
      home: VendorDashboard(),
    );
  }
}
