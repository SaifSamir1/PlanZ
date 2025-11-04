import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

// Your imports
import 'package:plan_z/features/app_owner/cubit/app_owner_cubit.dart';
import 'package:plan_z/features/app_owner/data/repo/app_owner_repo_impl.dart';
import 'package:plan_z/features/attandee/cubit/attendee_cubit.dart';
import 'package:plan_z/features/attandee/data/attandee_repo_impl.dart';
import 'package:plan_z/features/attandee/ui/home/ui/screens/attandee_notification.dart';
import 'package:plan_z/features/auth/data/auth_repo/auth_repo_impl.dart';
import 'package:plan_z/features/auth/data/models/user_manager.dart';
import 'package:plan_z/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/cubits/create_event_cubit/create_event_cubit.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/cubits/event_creation_cubit/event_creation_cubit.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/repo/event_owner_repo_impl.dart';
import 'package:plan_z/features/on_boarding/ui/on_boarding_view.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/cubit/vendor_cubit.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/repos/vendor_repository_impl.dart';
import 'package:plan_z/firebase_options.dart';

// ✅ Local Notifications plugin instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// ✅ Background FCM handler (must be top-level or static)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("🔔 تم استلام إشعار في الخلفية: ${message.notification?.title}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ 1. Initialize Hive
  await Hive.initFlutter();

  // ✅ 2. Initialize Intl
  Intl.defaultLocale = 'ar';

  // ✅ 3. Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ 4. Background messages handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ✅ 5. Local notifications initialization
  const AndroidInitializationSettings androidInitSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings = InitializationSettings(
    android: androidInitSettings,
  );
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'plan_z_channel',
    'PlanZ Notifications',
    description: 'This channel is used for important PlanZ notifications.',
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  // ✅ 6. Request notification permission
  NotificationSettings settings = await FirebaseMessaging.instance
      .requestPermission(alert: true, badge: true, sound: true);
  print("🔔 FCM Permission: ${settings.authorizationStatus}");

  // ✅ 7. Get and print FCM Token
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("📱 FCM Token: $fcmToken");

  // ✅ 8. Initialize UserManager (after Hive)
  await UserManager().init();

  runApp(const PlanZ());
}

class PlanZ extends StatefulWidget {
  const PlanZ({super.key});

  @override
  State<PlanZ> createState() => _PlanZState();
}

class _PlanZState extends State<PlanZ> {
  @override
  void initState() {
    super.initState();

    // ✅ Foreground messages (show local notifications)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📨 إشعار أثناء التشغيل: ${message.notification?.title}");

      if (message.notification != null) {
        // Local notification details
        const AndroidNotificationDetails androidDetails =
            AndroidNotificationDetails(
              'plan_z_channel', // Channel ID
              'PlanZ Notifications', // Channel name
              importance: Importance.max,
              priority: Priority.high,
              showWhen: true,
            );
        const NotificationDetails platformDetails = NotificationDetails(
          android: androidDetails,
        );

        // Show local notification
        flutterLocalNotificationsPlugin.show(
          message.hashCode,
          message.notification?.title,
          message.notification?.body,
          platformDetails,
        );
      }
    });

    // ✅ When app is opened via notification (background or terminated)
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
            create: (_) => AuthCubit(authRepository: AuthRepositoryImpl()),
          ),
          BlocProvider(create: (_) => EventCreationCubit()),
          BlocProvider(
            create: (_) => EventOwnerCubit(EventOwnerRepositoryImpl()),
          ),
          BlocProvider(create: (_) => VendorCubit(VendorRepositoryImpl())),
          BlocProvider(create: (_) => AppOwnerCubit(AppOwnerRepositoryImpl())),
          BlocProvider(create: (_) => AttendeeCubit(AttendeeRepositoryImpl())),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: OnBoardingScreen(),
        ),
      ),
    );
  }
}
