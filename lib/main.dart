import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:plan_z/features/attandee_features/attendee_home/ui/attende_home_screen.dart';
import 'package:plan_z/features/attandee_features/invitations/ui/screens/invitation_template.dart';
import 'package:plan_z/features/new_owner_features/event_owner_home/ui/screens/navigation_screen.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/ui/screens/edit_package_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Intl.defaultLocale = 'ar';

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
        home: NavigationScreen(),
        // title: 'PlanZ Chat',
        debugShowCheckedModeBanner: false,
      
      ),
    );
  }
}
