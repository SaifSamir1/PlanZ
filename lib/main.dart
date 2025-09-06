import 'package:flutter/material.dart';
import 'package:plan_z/features/auth/data/models/user_model.dart';
import 'package:plan_z/features/auth/ui/screens/login_screen.dart';
import 'package:plan_z/features/packages_mangment/data/models/package_model.dart';
import 'package:plan_z/features/packages_mangment/ui/screens/all_packages_screen.dart';

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
      home: PackagesScreen(
        packages: [
          PackageModel(
            id: '1',
            name: 'Wedding Photography',
            description:
                'Full-day wedding photography with album and digital copies.',
            price: '\$1500',
            type: 'Photography',
            status: 'Active',
          ),
          PackageModel(
            id: '2',
            name: 'Luxury Catering',
            description:
                'Gourmet meal service for 100 guests, including appetizers and desserts.',
            price: '\$3000',
            type: 'Catering',
            status: 'Active',
          ),
          PackageModel(
            id: '3',
            name: 'Event Decoration',
            description:
                'Elegant floral arrangements and lighting for large events.',
            price: '\$1200',
            type: 'Decoration',
            status: 'Pending',
          ),
        ],
      ),
    );
  }
}
