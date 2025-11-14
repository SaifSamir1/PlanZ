import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:plan_z/features/app_owner/cubit/app_owner_cubit.dart';
import 'package:plan_z/features/app_owner/data/repo/app_owner_repo_impl.dart';
import 'package:plan_z/features/app_owner/ui/screens/owner_dashboard_screen.dart';
import 'package:plan_z/features/attandee/cubit/attendee_cubit.dart';
import 'package:plan_z/features/attandee/data/attandee_repo_impl.dart';
import 'package:plan_z/features/attandee/ui/home/ui/screens/attandee_notification.dart';
import 'package:plan_z/features/attandee/ui/home/ui/screens/attendee_home_screen.dart';
import 'package:plan_z/features/auth/data/auth_repo/auth_repo_impl.dart';
import 'package:plan_z/features/auth/data/models/user_manager.dart';
import 'package:plan_z/features/auth/data/models/user_model.dart';
import 'package:plan_z/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:plan_z/features/event_owners/create_event_screen/cubits/create_event_cubit/create_event_cubit.dart';
import 'package:plan_z/features/event_owners/create_event_screen/cubits/event_creation_cubit/event_creation_cubit.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/repo/event_owner_repo_impl.dart';
import 'package:plan_z/features/event_owners/event_owner_home/ui/screens/navigation_screen.dart';
import 'package:plan_z/features/on_boarding/ui/on_boarding_view.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/cubit/vendor_cubit.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/repos/vendor_repository_impl.dart';
import 'package:plan_z/features/vendor_features/vendor_home/ui/screens/vendor_home_screen.dart';

import 'package:plan_z/firebase_options.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("🔔 تم استلام إشعار في الخلفية: ${message.notification?.title}");
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ 1. Initialize Hive FIRST
  await Hive.initFlutter(); // هذا أهم خطوة

  // ✅ 2. Initialize Intl
  Intl.defaultLocale = 'ar';

  // ✅ 3. Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ إعداد FCM background handler
FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

// ✅ طلب الإذن بالإشعارات
NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
  alert: true,
  badge: true,
  sound: true,
);
print("🔔 FCM Permission: ${settings.authorizationStatus}");

// ✅ احضار الـ Token (تقدري تحفظيه في Firestore لاحقًا)
final fcmToken = await FirebaseMessaging.instance.getToken();
print("📱 FCM Token: $fcmToken");


  // ✅ 4. Initialize UserManager (after Hive init)
  await UserManager().init();

  // ✅ 5. Run App
  runApp(const PlanZ());
}

class PlanZ extends StatefulWidget {
  const PlanZ({super.key});

  /// 🔍 Determine home screen based on login status
  Widget getHomeScreen() {
    final userManager = UserManager();
    
    debugPrint('🔍 [PlanZ._getHomeScreen] Checking login status...');
    debugPrint('   isLoggedIn: ${userManager.isLoggedIn}');
    debugPrint('   userId: ${userManager.userId}');
    debugPrint('   userType: ${userManager.userType?.name}');
    
    // ✅ If user is logged in, route to appropriate dashboard
    if (userManager.isLoggedIn && userManager.userId != null) {
      debugPrint('✅ [PlanZ._getHomeScreen] User is logged in, routing to dashboard');
      
      switch (userManager.userType) {
        case UserType.vendor:
          debugPrint('📍 [PlanZ._getHomeScreen] Routing to Vendor Dashboard');
          return const VendorHomeScreen();
          
        case UserType.eventOwner:
          debugPrint('📍 [PlanZ._getHomeScreen] Routing to Event Owner Dashboard');
          return const NavigationScreen();
          
        case UserType.attendee:
          debugPrint('📍 [PlanZ._getHomeScreen] Routing to Attendee Dashboard');
          return const AttendeeHomeScreen();
          
        case UserType.admin:
          debugPrint('📍 [PlanZ._getHomeScreen] Routing to Admin Dashboard');
          return const OwnerDashboardScreen();
          
        default:
          debugPrint('⚠️ [PlanZ._getHomeScreen] Unknown user type, showing onboarding');
          return const OnBoardingScreen();
      }
    }
    
    // ❌ If user is not logged in, show onboarding
    debugPrint('❌ [PlanZ._getHomeScreen] User is not logged in, showing onboarding');
    return const OnBoardingScreen();
  }

  @override

  
  State<PlanZ> createState() => _PlanZState();
}

class _PlanZState extends State<PlanZ> {
  @override
void initState() {
  super.initState();

  // ✅ إشعارات أثناء تشغيل التطبيق
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      print("📨 إشعار أثناء التشغيل: ${message.notification!.title}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message.notification!.title ?? "إشعار جديد 🎉"),
          backgroundColor: Colors.deepPurple,
        ),
      );
    }
  });

  // ✅ عند الضغط على الإشعار (من الخلفية أو الإغلاق الكامل)
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("📬 تم فتح التطبيق من إشعار: ${message.notification?.title}");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
    );
  });
}
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthCubit(authRepository: AuthRepositoryImpl()),
          ),
          BlocProvider(create: (context) => EventCreationCubit()),
          BlocProvider(
            create: (context) => EventOwnerCubit(EventOwnerRepositoryImpl()),
          ),
          BlocProvider(create: (context) => VendorCubit(VendorRepositoryImpl())),
          BlocProvider(create: (context) => AppOwnerCubit(
            AppOwnerRepositoryImpl(),
            EventOwnerRepositoryImpl()
          )),
          BlocProvider(create: (context) => AttendeeCubit(
            AttendeeRepositoryImpl()
          )),
         ],
        child: MaterialApp(
          home: widget.getHomeScreen(),
          // title: 'PlanZ Chat',
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
