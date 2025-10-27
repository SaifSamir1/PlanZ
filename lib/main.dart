import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:plan_z/features/app_owner/ui/screens/owner_dashboard_screen.dart';
import 'package:plan_z/features/auth/data/auth_repo/auth_repo.dart';
import 'package:plan_z/features/auth/data/auth_repo/auth_repo_impl.dart';
import 'package:plan_z/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:plan_z/features/on_boarding/ui/stakeholders_selection_screen.dart';
import 'package:plan_z/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Intl.defaultLocale = 'ar';
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const PlanZ());
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
