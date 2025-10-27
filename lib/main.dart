import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:plan_z/features/app_owner/ui/screens/owner_dashboard_screen.dart';
import 'package:plan_z/features/auth/data/auth_repo/auth_repo_impl.dart';
import 'package:plan_z/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/vendor_model.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/repos/vendor_repository_impl.dart';
import 'package:plan_z/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Intl.defaultLocale = 'ar';
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      child: BlocProvider(
        create: (context) => AuthCubit(authRepository: AuthRepositoryImpl()),
        child: MaterialApp(
          home: OwnerDashboardScreen(),
          // title: 'PlanZ Chat',
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
