import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:plan_z/core/services/notification_service.dart';

// Your imports
import 'package:plan_z/features/app_owner/cubit/app_owner_cubit.dart';
import 'package:plan_z/features/app_owner/data/repo/app_owner_repo_impl.dart';
import 'package:plan_z/features/app_owner/ui/screens/financial_overview_screen.dart';
import 'package:plan_z/features/app_owner/ui/screens/owner_dashboard_screen.dart';
import 'package:plan_z/features/attandee/cubit/attendee_cubit.dart';
import 'package:plan_z/features/attandee/data/attandee_repo_impl.dart';
import 'package:plan_z/features/attandee/ui/home/ui/screens/attandee_notification.dart';
import 'package:plan_z/features/attandee/ui/home/ui/screens/attendee_home_screen.dart';
import 'package:plan_z/features/attandee/ui/home/ui/screens/my_invitations_screen.dart';
import 'package:plan_z/features/auth/data/auth_repo/auth_repo_impl.dart';
import 'package:plan_z/features/auth/data/models/user_manager.dart';
import 'package:plan_z/features/auth/data/models/user_model.dart';
import 'package:plan_z/features/auth/logic/auth_cubit/auth_cubit.dart';
import 'package:plan_z/features/event_owners/chat_bot/cubits/chat_cubit.dart';
import 'package:plan_z/features/event_owners/chat_bot/ui/chat_bot_screen.dart';
import 'package:plan_z/features/event_owners/create_event_screen/cubits/create_event_cubit/create_event_cubit.dart';
import 'package:plan_z/features/event_owners/create_event_screen/cubits/event_creation_cubit/event_creation_cubit.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/repo/event_owner_repo_impl.dart';
import 'package:plan_z/features/event_owners/create_event_screen/ui/screens/select_event_type_screen.dart';
import 'package:plan_z/features/event_owners/event_owner_home/ui/screens/navigation_screen.dart';
import 'package:plan_z/features/on_boarding/ui/on_boarding_view.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/cubit/vendor_cubit.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/repos/vendor_repository_impl.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/ui/screens/create_package_screen.dart';
import 'package:plan_z/features/vendor_features/vendor_home/ui/screens/vendor_earnings_screen.dart';
import 'package:plan_z/features/vendor_features/vendor_home/ui/screens/vendor_home_screen.dart';

import 'package:plan_z/firebase_options.dart';
import 'package:workmanager/workmanager.dart';

const String eventReminderTask = "eventReminderTask";

// ✅ Local Notifications plugin instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// ✅ Background FCM handler (must be top-level or static)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("🔔 تم استلام إشعار في الخلفية: ${message.notification?.title}");
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    switch (task) {
      case eventReminderTask:
        await NotificationService.sendEventRemindersFromBackground();
        break;
    }

    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ 1. Initialize Hive
  await Hive.initFlutter();

  // ✅ 2. Initialize Intl
  Intl.defaultLocale = 'ar';

  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true, // set false for release
  );

  // Schedule periodic task (every 15 minutes minimum on Android)
  Workmanager().registerPeriodicTask(
    "1", // unique ID
    eventReminderTask,
    frequency: const Duration(hours: 1), // minimum 15 min on Android
  );

  // ✅ 3. Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ✅ 4. Background messages handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ✅ 5. Local notifications initialization
  const AndroidInitializationSettings androidInitSettings =
      AndroidInitializationSettings('@drawable/ic_notification');

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

  // ✅ 9. Setup FCM token refresh listener
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    print("🔄 FCM Token refreshed: $newToken");
    await _updateUserFCMToken(newToken);
  });

  runApp(const PlanZ());
}

/// ✅ Update user's FCM token in Firestore when token refreshes
Future<void> _updateUserFCMToken(String newToken) async {
  final userManager = UserManager();
  final userId = userManager.userId;
  final userType = userManager.userType;

  if (userId == null || userType == null) {
    debugPrint('⚠️ Cannot update FCM token: User not logged in');
    return;
  }

  try {
    String collectionName;
    switch (userType) {
      case UserType.vendor:
        collectionName = 'vendors';
        break;
      case UserType.eventOwner:
        collectionName = 'event_owners';
        break;
      case UserType.attendee:
        collectionName = 'attendees';
        break;
      case UserType.admin:
        collectionName = 'admins';
        break;
    }

    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(userId)
        .update({'fcmToken': newToken, 'fcmTokenUpdatedAt': Timestamp.now()});

    debugPrint('✅ FCM token updated in Firestore for user: $userId');
  } catch (e) {
    debugPrint('❌ Failed to update FCM token: $e');
  }
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
      debugPrint(
        '✅ [PlanZ._getHomeScreen] User is logged in, routing to dashboard',
      );

      switch (userManager.userType) {
        case UserType.vendor:
          debugPrint('📍 [PlanZ._getHomeScreen] Routing to Vendor Dashboard');
          return const VendorHomeScreen();

        case UserType.eventOwner:
          debugPrint(
            '📍 [PlanZ._getHomeScreen] Routing to Event Owner Dashboard',
          );
          return const NavigationScreen();

        case UserType.attendee:
          debugPrint('📍 [PlanZ._getHomeScreen] Routing to Attendee Dashboard');
          return const AttendeeHomeScreen();

        case UserType.admin:
          debugPrint('📍 [PlanZ._getHomeScreen] Routing to Admin Dashboard');
          return const OwnerDashboardScreen();

        default:
          debugPrint(
            '⚠️ [PlanZ._getHomeScreen] Unknown user type, showing onboarding',
          );
          return const OnBoardingScreen();
      }
    }

    // ❌ If user is not logged in, show onboarding
    debugPrint(
      '❌ [PlanZ._getHomeScreen] User is not logged in, showing onboarding',
    );
    return const OnBoardingScreen();
  }

  @override
  State<PlanZ> createState() => _PlanZState();
}

class _PlanZState extends State<PlanZ> {
  // Track shown notification IDs to prevent duplicates
  final Set<String> _shownNotificationIds = {};

  @override
  void initState() {
    super.initState();

    // ✅ Listen to Firestore notifications collection for real-time updates
    _listenToFirestoreNotifications();

    // ❌ REMOVED: Event reminders should be triggered by scheduled tasks, not on app open
    // This was causing notifications to be sent to all users every time ANY user opened the app

    // ✅ Foreground messages (show local notifications when app is open)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("📨 [onMessage] Notification received while app is open");
      debugPrint("   Title: ${message.notification?.title}");
      debugPrint("   Body: ${message.notification?.body}");

      if (message.notification != null) {
        // Local notification details
        const AndroidNotificationDetails androidDetails =
            AndroidNotificationDetails(
              'plan_z_channel', // Channel ID
              'PlanZ Notifications', // Channel name
              importance: Importance.max,
              priority: Priority.high,
              showWhen: true,
              icon: '@drawable/ic_notification', // small white icon
              largeIcon: DrawableResourceAndroidBitmap(
                'planz_logo',
              ), // colorful large icon
            );

        const NotificationDetails platformDetails = NotificationDetails(
          android: androidDetails,
        );

        // Show local notification
        flutterLocalNotificationsPlugin.show(
          message.hashCode,
          message.notification?.title ?? 'Notification',
          message.notification?.body ?? '',
          platformDetails,
        );

        debugPrint("✅ [onMessage] Local notification displayed");
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

  /// ✅ Listen to Firestore notifications collection for real-time updates
  void _listenToFirestoreNotifications() {
    final userManager = UserManager();
    final userId = userManager.userId;
    final userRole = userManager.userType?.name ?? 'unknown';

    if (userId == null) {
      debugPrint('⚠️ [_listenToFirestoreNotifications] User ID not available');
      return;
    }

    debugPrint(
      '📡 [_listenToFirestoreNotifications] Listening for notifications...',
    );
    debugPrint('   User ID: $userId');
    debugPrint('   User Role: $userRole');

    // Only show notifications from the last 5 minutes to avoid old notifications on app restart
    final fiveMinutesAgo = Timestamp.fromDate(
      DateTime.now().subtract(const Duration(minutes: 5)),
    );

    // Listen to notifications collection for current user
    FirebaseFirestore.instance
        .collection('notifications')
        .where('receiverId', isEqualTo: userId)
        .where('receiverRole', isEqualTo: userRole)
        .where('createdAt', isGreaterThan: fiveMinutesAgo)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            for (var change in snapshot.docChanges) {
              // Only process new documents that were just added
              if (change.type == DocumentChangeType.added) {
                final notifData = change.doc.data();
                if (notifData == null) continue;

                final notificationId = notifData['notificationId'] as String?;
                final title = notifData['title'] as String?;
                final body = notifData['body'] as String?;

                // Skip if we've already shown this notification
                if (notificationId != null &&
                    _shownNotificationIds.contains(notificationId)) {
                  debugPrint(
                    '⏭️ [_listenToFirestoreNotifications] Skipping already shown notification: $notificationId',
                  );
                  continue;
                }

                debugPrint(
                  '🔔 [_listenToFirestoreNotifications] New notification from Firestore',
                );
                debugPrint('   Notification ID: $notificationId');
                debugPrint('   Title: $title');
                debugPrint('   Body: $body');

                // Show local notification
                if (title != null && body != null) {
                  _showLocalNotification(title, body);

                  // Mark as shown
                  if (notificationId != null) {
                    _shownNotificationIds.add(notificationId);
                  }
                }
              }
            }
          },
          onError: (error) {
            debugPrint('❌ [_listenToFirestoreNotifications] Error: $error');
          },
        );
  }

  /// ✅ Show local notification
  Future<void> _showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'plan_z_channel',
          'PlanZ Notifications',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          icon: '@drawable/ic_notification',
          largeIcon: DrawableResourceAndroidBitmap('planz_logo'),
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      body,
      platformDetails,
    );

    debugPrint('✅ [_showLocalNotification] Local notification displayed');
  }

  // ❌ REMOVED: This method was causing notifications to be sent every time the app opened
  // Event reminders should be triggered by a scheduled background task or Cloud Functions,
  // not on app initialization. Keeping this method commented for reference.
  //
  // /// ✅ Check for upcoming events and send reminders
  // Future<void> _checkEventReminders() async {
  //   debugPrint('🔔 [_checkEventReminders] Checking for upcoming events...');
  //   try {
  //     await EventReminderService.checkAndSendReminders();
  //   } catch (e) {
  //     debugPrint('❌ [_checkEventReminders] Error: $e');
  //   }
  // }

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
          BlocProvider(
            create: (context) => VendorCubit(VendorRepositoryImpl()),
          ),
          BlocProvider(
            create: (context) => AppOwnerCubit(
              AppOwnerRepositoryImpl(),
              EventOwnerRepositoryImpl(),
            ),
          ),
          BlocProvider(
            create: (context) => AttendeeCubit(AttendeeRepositoryImpl()),
          ),
          BlocProvider(create: (context) => ChatCubit()),
        ],
        child: MaterialApp(
          home: widget.getHomeScreen(),
          // title: 'PlanZ Chat',
          debugShowCheckedModeBanner: false,
          routes: {
            '/create_event': (_) => SelectEventTypeScreen(),
            '/notifications': (_) => NotificationsScreen(),
            '/vendor_dashboard': (_) => VendorHomeScreen(),
            '/attendee_dashboard': (_) => AttendeeHomeScreen(),
            '/owner_overview': (_) => FinancialOverviewScreen(),
            '/chat_bot': (_) => ChatScreen(),
            '/vendor_financial': (_) => VendorEarningsScreen(),
            '/vendor_requests': (_) => VendorHomeScreen(),
            '/add_paackage': (_) => CreatePackageScreen(),
            '/invitation': (_) => MyInvitationsScreen(),
          },
        ),
      ),
    );
  }
}
