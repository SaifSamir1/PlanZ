import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plan_z/features/new_owner_features/chat_bot/cubits/chat_cubit.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/create_event_screen.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/vendor_model.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/repos/vendor_repository_impl.dart';
import 'package:plan_z/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Intl.defaultLocale = 'ar';
  testFirestore();

  runApp(const PlanZ());
}

void testFirestore() async {
  final repo = VendorRepositoryImpl();

  final vendor = VendorModel(
    vendorId: 'v1',
    name: 'Hoor Mahmoud',
    serviceType: 'Decorations',
    packages: [],
    verified: false,
    walletBalance: 0.0,
    notifications: [],
  );

  await repo.addVendor(vendor);
  print("✅ Vendor added successfully!");
}

class PlanZ extends StatelessWidget {
  const PlanZ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlanZ Chat',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => ChatCubit(),
        child: const CreateEventScreen(),
      ),
    );
  }
}
