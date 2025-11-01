// lib/core/services/user_manager.dart

// ignore_for_file: avoid_print

import 'package:hive/hive.dart';
import 'package:plan_z/features/auth/data/models/user_model.dart';

/// Singleton class لإدارة بيانات المستخدم الحالي في كل التطبيق مع التخزين المحلي
class UserManager {
  // ✅ Private constructor (Singleton Pattern)
  UserManager._internal();

  // ✅ Single instance
  static final UserManager _instance = UserManager._internal();

  // ✅ Factory constructor للحصول على الـ Instance
  factory UserManager() => _instance;

  // ============================================
  // Hive Box Configuration
  // ============================================
  static const String _boxName = 'userBox';
  static const String _userKey = 'currentUser';
  Box? _userBox;

  /// Initialize Hive Box (يجب استدعاؤه في main قبل runApp)
  Future<void> init() async {
    try {
      _userBox = await Hive.openBox(_boxName);
      
      // ✅ Load user from Hive if exists
      await _loadUserFromStorage();
      
      print('✅ UserManager initialized successfully');
    } catch (e) {
      print('❌ Error initializing UserManager: $e');
    }
  }

  /// Close Hive Box (عند إغلاق التطبيق)
  Future<void> dispose() async {
    await _userBox?.close();
  }

  // ============================================
  // User Data Storage
  // ============================================
  UserModel? _currentUser;

  /// Get current user data
  UserModel? get currentUser => _currentUser;

  /// Check if user is logged in
  bool get isLoggedIn => _currentUser != null;

  /// Get user ID
  String? get userId => _currentUser?.id;

  /// Get user name
  String? get userName => _currentUser?.name;

  /// Get user email
  String? get userEmail => _currentUser?.email;

  /// Get user type
  UserType? get userType => _currentUser?.userType;

  /// Get user phone
  String? get userPhone => _currentUser?.phoneNumber;

  /// Check if user is Vendor
  bool get isVendor => _currentUser?.userType == UserType.vendor;

  /// Check if user is Event Owner
  bool get isEventOwner => _currentUser?.userType == UserType.eventOwner;

  /// Check if user is Attendee
  bool get isAttendee => _currentUser?.userType == UserType.attendee;

  /// Check if user is Admin
  bool get isAdmin => _currentUser?.userType == UserType.admin;

  // ============================================
  // User Management Methods
  // ============================================

  /// Set current user (Login/SignUp) with Hive storage
  Future<void> setUser(UserModel user) async {
    _currentUser = user;
    await _saveUserToStorage(user);
    print('✅ User logged in: ${user.name} (${user.userType.name})');
  }

  /// Clear current user (Logout) and remove from Hive
  Future<void> clearUser() async {
    _currentUser = null;
    await _removeUserFromStorage();
    print('🔴 User logged out');
  }

  /// Update current user data with Hive storage
  Future<void> updateUser(UserModel updatedUser) async {
    if (_currentUser?.id == updatedUser.id) {
      _currentUser = updatedUser;
      await _saveUserToStorage(updatedUser);
      print('✅ User data updated: ${updatedUser.name}');
    }
  }

  /// Update specific user fields with Hive storage
  Future<void> updateUserFields({
    String? name,
    String? phoneNumber,
    Map<String, dynamic>? additionalInfo,
  }) async {
    if (_currentUser != null) {
      _currentUser = UserModel(
        id: _currentUser!.id,
        name: name ?? _currentUser!.name,
        email: _currentUser!.email,
        userType: _currentUser!.userType,
        phoneNumber: phoneNumber ?? _currentUser!.phoneNumber,
        isActive: _currentUser!.isActive,
        additionalInfo: additionalInfo ?? _currentUser!.additionalInfo,
        createdAt: _currentUser!.createdAt,
        updatedAt: DateTime.now(),
      );
      await _saveUserToStorage(_currentUser!);
      print('✅ User fields updated');
    }
  }

  // ============================================
  // Hive Storage Methods
  // ============================================

  /// Save user to Hive storage
  Future<void> _saveUserToStorage(UserModel user) async {
    try {
      if (_userBox != null) {
        await _userBox!.put(_userKey, user.toJson());
        print('💾 User saved to local storage');
      }
    } catch (e) {
      print('❌ Error saving user to storage: $e');
    }
  }

  /// Load user from Hive storage
  Future<void> _loadUserFromStorage() async {
    try {
      if (_userBox != null && _userBox!.containsKey(_userKey)) {
        final userJson = _userBox!.get(_userKey) as Map<dynamic, dynamic>;
        final userMap = Map<String, dynamic>.from(userJson);
        _currentUser = UserModel.fromJson(userMap);
        print('📂 User loaded from local storage: ${_currentUser!.name}');
      } else {
        print('📂 No user found in local storage');
      }
    } catch (e) {
      print('❌ Error loading user from storage: $e');
      _currentUser = null;
    }
  }

  /// Remove user from Hive storage
  Future<void> _removeUserFromStorage() async {
    try {
      if (_userBox != null) {
        await _userBox!.delete(_userKey);
        print('🗑️ User removed from local storage');
      }
    } catch (e) {
      print('❌ Error removing user from storage: $e');
    }
  }

  /// Check if user exists in storage (without loading)
  bool hasStoredUser() {
    return _userBox?.containsKey(_userKey) ?? false;
  }

  // ============================================
  // Helper Methods
  // ============================================

  /// Print current user info (for debugging)
  void printUserInfo() {
    if (_currentUser != null) {
      print('👤 Current User:');
      print('   ID: ${_currentUser!.id}');
      print('   Name: ${_currentUser!.name}');
      print('   Email: ${_currentUser!.email}');
      print('   Type: ${_currentUser!.userType.name}');
      print('   Phone: ${_currentUser!.phoneNumber ?? "N/A"}');
      print('   Active: ${_currentUser!.isActive}');
    } else {
      print('❌ No user logged in');
    }
  }

  /// Get user display name (with fallback)
  String getDisplayName() {
    return _currentUser?.name ?? 'Guest';
  }

  /// Get user initials (for avatar)
  String getUserInitials() {
    if (_currentUser?.name == null) return 'G';
    final parts = _currentUser!.name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return _currentUser!.name[0].toUpperCase();
  }

  /// Force reload user from storage (useful after app restart)
  Future<void> reloadFromStorage() async {
    await _loadUserFromStorage();
  }
}
