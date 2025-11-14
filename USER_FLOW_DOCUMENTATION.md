# 🔄 PlanZ - User Flow & Session Management Documentation

## Overview

This document explains how users flow through the PlanZ application, from first launch through authentication and to their respective dashboards.

---

## 🎯 User Flow Architecture

### Complete User Journey

```
App Launch
    ↓
[main.dart] Initialize:
  1. Hive (local storage)
  2. Intl (localization)
  3. Firebase
  4. UserManager (load cached user)
    ↓
[PlanZ._getHomeScreen()] Check Login Status
    ↓
    ├─ User Logged In? ✅
    │   ├─ Vendor → VendorHomeScreen
    │   ├─ Event Owner → NavigationScreen (Event Owner Dashboard)
    │   ├─ Attendee → AttendeeHomeScreen
    │   └─ Admin → OwnerDashboardScreen
    │
    └─ User NOT Logged In? ❌
        └─ OnBoardingScreen
            ↓
        [OnBoardingScreen] Select User Type
            ├─ Vendor
            ├─ Event Owner
            ├─ Attendee
            └─ Admin
            ↓
        [LoginScreen] or [SignUpScreen]
            ↓
        [AuthCubit.signIn/signUp()]
            ↓
        [UserManager.setUser()] Save to Hive
            ↓
        Route to Dashboard
```

---

## 📱 Detailed User Flows by Type

### 1. First-Time User (New Installation)

```
App Starts
    ↓
UserManager.init() → No cached user found
    ↓
PlanZ._getHomeScreen() → isLoggedIn = false
    ↓
Show OnBoardingScreen
    ↓
User selects user type (Vendor/Event Owner/Attendee/Admin)
    ↓
Navigate to LoginScreen or SignUpScreen
    ↓
User enters credentials
    ↓
AuthCubit.signUp() or AuthCubit.signIn()
    ↓
Firebase authenticates user
    ↓
UserModel created/retrieved
    ↓
UserManager.setUser(user) → Saves to Hive
    ↓
AuthCubit emits AuthSignInSuccess
    ↓
LoginScreen._navigateBasedOnUserType()
    ↓
Route to appropriate dashboard
```

### 2. Returning User (App Restart)

```
App Starts
    ↓
UserManager.init() → Loads user from Hive
    ↓
_currentUser = UserModel (from cache)
    ↓
PlanZ._getHomeScreen() → isLoggedIn = true
    ↓
Check userType:
    ├─ Vendor → VendorHomeScreen
    ├─ Event Owner → NavigationScreen
    ├─ Attendee → AttendeeHomeScreen
    └─ Admin → OwnerDashboardScreen
    ↓
User sees their dashboard immediately ✅
```

### 3. User Logout

```
User clicks Logout button
    ↓
AuthCubit.signOut()
    ↓
Firebase signs out
    ↓
UserManager.clearUser()
    ↓
Hive clears user data
    ↓
_currentUser = null
    ↓
Navigate to OnBoardingScreen
```

---

## 🔐 Session Management

### UserManager (Singleton Pattern)

**File**: `lib/features/auth/data/models/user_manager.dart`

**Purpose**: Centralized user state management with Hive persistence

**Key Methods**:

```dart
// Initialize (called in main.dart)
await UserManager().init()
  → Opens Hive box
  → Loads cached user from storage
  → Sets _currentUser

// Save user (called after login/signup)
await UserManager().setUser(user)
  → Stores user in memory (_currentUser)
  → Saves to Hive storage
  → Prints: "✅ User logged in: {name}"

// Clear user (called on logout)
await UserManager().clearUser()
  → Clears _currentUser
  → Removes from Hive storage
  → Prints: "🔴 User logged out"

// Check login status
UserManager().isLoggedIn → bool
UserManager().userId → String?
UserManager().userType → UserType?
```

### Hive Storage Structure

**Box Name**: `userBox`
**Key**: `currentUser`
**Value**: UserModel.toJson()

```dart
// Stored in Hive as:
{
  "id": "user_123",
  "name": "Ahmed",
  "email": "ahmed@example.com",
  "userType": "vendor",
  "phoneNumber": "+201234567890",
  "fcmToken": "token_xyz",
  "isActive": true,
  "createdAt": "2025-11-13T...",
  "updatedAt": "2025-11-13T..."
}
```

---

## 🔄 Authentication Flow

### Sign Up Flow

```
SignUpScreen
    ↓
User enters: name, email, password, userType
    ↓
AuthCubit.signUp()
    ├─ Emit: AuthSignUpLoading
    ├─ Call: AuthRepository.signUp()
    │   ├─ Firebase Auth: createUserWithEmailAndPassword()
    │   ├─ Firestore: Save UserModel to users/{userId}
    │   └─ Return: UserModel
    ├─ UserManager.setUser(user)
    │   ├─ Store in memory
    │   └─ Save to Hive
    └─ Emit: AuthSignUpSuccess(user)
    ↓
LoginScreen._navigateBasedOnUserType()
    ↓
Route to Dashboard
```

### Sign In Flow

```
LoginScreen
    ↓
User enters: email, password
    ↓
AuthCubit.signIn()
    ├─ Emit: AuthSignInLoading
    ├─ Call: AuthRepository.signIn()
    │   ├─ Firebase Auth: signInWithEmailAndPassword()
    │   ├─ Firestore: Fetch UserModel from users/{userId}
    │   └─ Return: UserModel
    ├─ UserManager.setUser(user)
    │   ├─ Store in memory
    │   └─ Save to Hive
    └─ Emit: AuthSignInSuccess(user)
    ↓
LoginScreen._navigateBasedOnUserType()
    ↓
Route to Dashboard
```

---

## 📍 Dashboard Routes by User Type

### Vendor
- **Screen**: `VendorHomeScreen`
- **Path**: `lib/features/vendor_features/vendor_home/ui/screens/vendor_home_screen.dart`
- **Features**:
  - View package requests
  - Manage packages
  - Track earnings
  - Accept/reject requests

### Event Owner
- **Screen**: `NavigationScreen`
- **Path**: `lib/features/event_owners/event_owner_home/ui/screens/navigation_screen.dart`
- **Features**:
  - Create events
  - Browse packages
  - Track event status
  - Manage invitations

### Attendee
- **Screen**: `AttendeeHomeScreen`
- **Path**: `lib/features/attandee/ui/home/ui/screens/attendee_home_screen.dart`
- **Features**:
  - View invitations
  - RSVP to events
  - View event details

### Admin
- **Screen**: `OwnerDashboardScreen`
- **Path**: `lib/features/app_owner/ui/screens/owner_dashboard_screen.dart`
- **Features**:
  - View all users
  - Manage packages
  - View analytics
  - System administration

---

## 🔍 App Startup Process (main.dart)

### Step-by-Step Initialization

```dart
void main() async {
  // Step 1: Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Step 2: Initialize Hive (MUST be first)
  await Hive.initFlutter();
  debugPrint('✅ Hive initialized');
  
  // Step 3: Set locale to Arabic
  Intl.defaultLocale = 'ar';
  debugPrint('✅ Intl locale set to Arabic');
  
  // Step 4: Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  debugPrint('✅ Firebase initialized');
  
  // Step 5: Initialize UserManager (loads cached user)
  await UserManager().init();
  // This loads user from Hive if exists
  debugPrint('✅ UserManager initialized');
  
  // Step 6: Run app
  runApp(const PlanZ());
}
```

### Why This Order Matters

1. **Hive First**: Local storage must be ready before loading cached data
2. **Intl Second**: Locale must be set before any UI rendering
3. **Firebase Third**: Backend must be ready for auth checks
4. **UserManager Fourth**: Can now load user from Hive
5. **App Last**: All systems ready, safe to render UI

---

## 🏠 Home Screen Selection (PlanZ._getHomeScreen)

### Logic Flow

```dart
Widget _getHomeScreen() {
  final userManager = UserManager();
  
  // Check if user is logged in
  if (userManager.isLoggedIn && userManager.userId != null) {
    // Route based on user type
    switch (userManager.userType) {
      case UserType.vendor:
        return const VendorHomeScreen();
      case UserType.eventOwner:
        return const NavigationScreen();
      case UserType.attendee:
        return const AttendeeHomeScreen();
      case UserType.admin:
        return const OwnerDashboardScreen();
      default:
        return const OnBoardingScreen();
    }
  }
  
  // Not logged in
  return const OnBoardingScreen();
}
```

### Debug Output

When app starts, you'll see logs like:

```
✅ Hive initialized
✅ Intl locale set to Arabic
✅ Firebase initialized
✅ UserManager initialized
📂 User loaded from local storage: Ahmed
🔍 [PlanZ._getHomeScreen] Checking login status...
   isLoggedIn: true
   userId: user_123
   userType: vendor
✅ [PlanZ._getHomeScreen] User is logged in, routing to dashboard
📍 [PlanZ._getHomeScreen] Routing to Vendor Dashboard
```

---

## 🔑 Key Implementation Details

### UserManager Singleton Pattern

```dart
class UserManager {
  // Private constructor
  UserManager._internal();
  
  // Single instance
  static final UserManager _instance = UserManager._internal();
  
  // Factory constructor
  factory UserManager() => _instance;
}

// Usage (always returns same instance)
final userManager1 = UserManager();
final userManager2 = UserManager();
// userManager1 == userManager2 ✅
```

### AuthCubit Integration

```dart
class AuthCubit extends Cubit<AuthState> {
  final UserManager _userManager = UserManager();
  
  Future<void> signIn({...}) async {
    // After successful auth
    await _userManager.setUser(user); // ✅ Save to Hive
    emit(AuthSignInSuccess(user: user));
  }
  
  Future<void> signOut() async {
    // On logout
    await _userManager.clearUser(); // ✅ Clear from Hive
    emit(const AuthSignOutSuccess());
  }
}
```

---

## 📊 Session Persistence

### What Gets Saved

When user logs in:
```dart
UserManager().setUser(user)
  ↓
Saves to Hive:
  - userId
  - name
  - email
  - userType
  - phoneNumber
  - fcmToken
  - isActive
  - timestamps
```

### What Gets Cleared

When user logs out:
```dart
UserManager().clearUser()
  ↓
Clears from Hive:
  - All user data
  - Session info
  - Cached preferences
```

### Persistence Duration

- **Saved**: Until user explicitly logs out
- **Survives**: App restart, background kill, device restart
- **Lost**: Only when user logs out or clears app data

---

## 🧪 Testing the Flow

### Test 1: First Launch (No Cached User)

1. Uninstall app
2. Install fresh
3. Launch app
4. Should see: **OnBoardingScreen**
5. Check logs: `❌ [PlanZ._getHomeScreen] User is not logged in`

### Test 2: Login and Restart

1. Complete login as Vendor
2. Should see: **VendorHomeScreen**
3. Kill app completely
4. Relaunch app
5. Should see: **VendorHomeScreen** immediately (no onboarding)
6. Check logs: `✅ [PlanZ._getHomeScreen] User is logged in, routing to dashboard`

### Test 3: Logout

1. Click logout button
2. Should see: **OnBoardingScreen**
3. Check logs: `🔴 User logged out`

### Test 4: Different User Types

1. Login as Event Owner
2. Should see: **NavigationScreen**
3. Logout, login as Attendee
4. Should see: **AttendeeHomeScreen**
5. Logout, login as Admin
6. Should see: **OwnerDashboardScreen**

---

## 🐛 Debugging

### Enable Debug Logs

All session management logs use `debugPrint()`:

```dart
// In UserManager
debugPrint('✅ User logged in: ${user.name}');
debugPrint('📂 User loaded from local storage: ${_currentUser!.name}');
debugPrint('🔴 User logged out');

// In PlanZ
debugPrint('🔍 [PlanZ._getHomeScreen] Checking login status...');
debugPrint('✅ [PlanZ._getHomeScreen] User is logged in, routing to dashboard');
debugPrint('❌ [PlanZ._getHomeScreen] User is not logged in, showing onboarding');
```

### Check Hive Data

```dart
// In UserManager
bool hasStoredUser() {
  return _userBox?.containsKey(_userKey) ?? false;
}

// Use in debugging
if (UserManager().hasStoredUser()) {
  print('✅ User data exists in Hive');
} else {
  print('❌ No user data in Hive');
}
```

### Print User Info

```dart
UserManager().printUserInfo();
// Output:
// 👤 Current User:
//    ID: user_123
//    Name: Ahmed
//    Email: ahmed@example.com
//    Type: vendor
//    Phone: +201234567890
//    Active: true
```

---

## 📋 Summary

| Scenario | Flow |
|----------|------|
| **First Launch** | App → Check Hive → No user → OnBoardingScreen |
| **After Login** | Auth → Save to Hive → Route to Dashboard |
| **App Restart** | App → Load from Hive → Route to Dashboard |
| **Logout** | User action → Clear Hive → OnBoardingScreen |
| **User Switch** | Logout → Login as different user → New Dashboard |

---

**Last Updated**: November 13, 2025
**Status**: ✅ Complete - Session persistence implemented
