// lib/core/constants/constants.dart
class FirebaseCollections {
  static const String vendors = 'vendors';
  static const String eventOwners = 'event_owners';
  static const String attendees = 'attendees';
    static const String admins = 'admins'; // ✅ Add this

  // ✅ New Collections
  static const String packages = 'packages'; // All packages
  static const String packageRequests = 'package_requests'; // All requests
  
  static const String events = 'events';
  static const String services = 'services'; // From JSON
  static const String eventTypes = 'event_types'; // From JSON
  // Events & Invitations
  static const String eventInvitations = 'event_invitations'; 
  
  // Notifications
  static const String notifications = 'notifications';
  static const String notificationsRequests = 'notifications_requests';
  static const String transactions = 'transactions'; 
  static const String withdrawals = 'withdrawals'; 
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

// lib/core/constants/constants.dart


