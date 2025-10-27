// lib/core/services/auth_hive_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plan_z/core/constants/constants.dart';

class AuthHiveService {
  static Box? _userBox;

  // تهيئة Hive
  static Future<void> init() async {
    try {
      _userBox = await Hive.openBox(HiveBoxes.userBox);
    } catch (e) {
      throw Exception('Failed to initialize Hive: ${e.toString()}');
    }
  }

  // حفظ بيانات المستخدم بعد تسجيل الدخول
  static Future<void> saveUserSession({
    required String userId,
    required String userType,
  }) async {
    try {
      await _userBox?.put(HiveBoxes.userIdKey, userId);
      await _userBox?.put(HiveBoxes.userTypeKey, userType);
      await _userBox?.put(HiveBoxes.isLoggedInKey, true);
    } catch (e) {
      throw Exception('Failed to save user session: ${e.toString()}');
    }
  }

  // جلب معرف المستخدم المحفوظ
  static String? getCachedUserId() {
    try {
      return _userBox?.get(HiveBoxes.userIdKey);
    } catch (e) {
      throw Exception('Failed to get cached user ID: ${e.toString()}');
    }
  }

  // جلب نوع المستخدم المحفوظ
  static String? getCachedUserType() {
    try {
      return _userBox?.get(HiveBoxes.userTypeKey);
    } catch (e) {
      throw Exception('Failed to get cached user type: ${e.toString()}');
    }
  }

  // التحقق من حالة تسجيل الدخول
  static bool isUserLoggedIn() {
    try {
      return _userBox?.get(HiveBoxes.isLoggedInKey, defaultValue: false) ?? false;
    } catch (e) {
      throw Exception('Failed to check login status: ${e.toString()}');
    }
  }

  // مسح جلسة المستخدم (تسجيل الخروج)
  static Future<void> clearUserSession() async {
    try {
      await _userBox?.delete(HiveBoxes.userIdKey);
      await _userBox?.delete(HiveBoxes.userTypeKey);
      await _userBox?.delete(HiveBoxes.isLoggedInKey);
    } catch (e) {
      throw Exception('Failed to clear user session: ${e.toString()}');
    }
  }

  // مسح جميع البيانات
  static Future<void> clearAllData() async {
    try {
      await _userBox?.clear();
    } catch (e) {
      throw Exception('Failed to clear all data: ${e.toString()}');
    }
  }
}
