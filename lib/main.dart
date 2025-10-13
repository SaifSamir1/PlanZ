import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/ui/screens/select_event_type_screen.dart';
import 'package:plan_z/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Intl.defaultLocale = 'ar';
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
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
      child: MaterialApp(
        home: SelectEventTypeScreen(),
        // title: 'PlanZ Chat',
        debugShowCheckedModeBanner: false,
      
      ),
    );
  }
}
