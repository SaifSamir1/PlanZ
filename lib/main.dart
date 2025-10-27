import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:plan_z/features/new_owner_features/event_owner_home/ui/screens/navigation_screen.dart';
import 'package:plan_z/features/vendor_features/vendor_home/ui/screens/vendor_home_screen.dart';
import 'package:plan_z/firebase_options.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Intl.defaultLocale = 'ar';
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
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
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        home: NavigationScreen(),
        // title: 'PlanZ Chat',
        debugShowCheckedModeBanner: false,
      
      ),
    );
  }
}
