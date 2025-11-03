// lib/core/services/fcm_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:plan_z/features/attandee/ui/home/ui/screens/attandee_notification.dart';

class FCMService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  static Future<void> initFCM(BuildContext context) async {
    // طلب إذن المستخدم لتلقي الإشعارات
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // لما التطبيق مفتوح ويجيله إشعار
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(notification.title ?? "إشعار جديد"),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });

    // لما المستخدم يضغط على الإشعار
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NotificationsScreen()),
      );
    });

    // لو التطبيق اتفتح أساسًا من إشعار
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NotificationsScreen()),
      );
    }
  }
}
