// lib/core/constants/constants.dart
class FirebaseCollections {
  static const String vendors = 'vendors';
  static const String eventOwners = 'event_owners';
  static const String attendees = 'attendees';
    static const String admins = 'admins'; // ✅ Add this

}

class HiveBoxes {
  static const String userBox = 'user_box';
  static const String userIdKey = 'user_id';
  static const String userTypeKey = 'user_type';
  static const String isLoggedInKey = 'is_logged_in';
}

// Admin Access Code (Store this securely - Better in Firebase Remote Config)
class AppSecrets {
  static const String adminAccessCode = 'PLAN_Z_ADMIN_2025'; // Change this!
}