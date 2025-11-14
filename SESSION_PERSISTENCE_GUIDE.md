# 🔐 Session Persistence & User Flow - Quick Reference

## ✅ What Was Fixed

**Problem**: Users had to login every time they opened the app (no session persistence)

**Solution**: 
1. Check if user is logged in at app startup
2. Route directly to dashboard if logged in
3. Show onboarding only if not logged in

**Files Modified**:
- `lib/main.dart` - Added login check and smart routing

---

## 🎯 User Flow (After Fix)

### First Time User
```
App Launch
  ↓
Check: Is user logged in? NO
  ↓
Show OnBoardingScreen
  ↓
Select user type → Login/SignUp
  ↓
Save to Hive (UserManager.setUser)
  ↓
Route to Dashboard
```

### Returning User
```
App Launch
  ↓
Check: Is user logged in? YES
  ↓
Load user from Hive
  ↓
Route directly to Dashboard ✅
(No onboarding, no login screen)
```

---

## 📍 Dashboard Routes

| User Type | Screen | Path |
|-----------|--------|------|
| **Vendor** | VendorHomeScreen | `vendor_features/vendor_home/...` |
| **Event Owner** | NavigationScreen | `event_owners/event_owner_home/...` |
| **Attendee** | AttendeeHomeScreen | `attandee/ui/home/...` |
| **Admin** | OwnerDashboardScreen | `app_owner/ui/screens/...` |

---

## 🔄 Session Management (UserManager)

### Save User (After Login)
```dart
await UserManager().setUser(user);
// Saves to Hive + memory
// Prints: ✅ User logged in: {name}
```

### Load User (On App Start)
```dart
await UserManager().init();
// Loads from Hive automatically
// Prints: 📂 User loaded from local storage: {name}
```

### Clear User (On Logout)
```dart
await UserManager().clearUser();
// Removes from Hive + memory
// Prints: 🔴 User logged out
```

### Check Login Status
```dart
UserManager().isLoggedIn        // bool
UserManager().userId            // String?
UserManager().userType          // UserType?
UserManager().userName          // String?
UserManager().userEmail         // String?
```

---

## 🏠 Home Screen Selection Logic

```dart
// In PlanZ._getHomeScreen()

if (UserManager().isLoggedIn) {
  // Route based on user type
  switch (UserManager().userType) {
    case UserType.vendor:
      return VendorHomeScreen();
    case UserType.eventOwner:
      return NavigationScreen();
    case UserType.attendee:
      return AttendeeHomeScreen();
    case UserType.admin:
      return OwnerDashboardScreen();
  }
}

// Not logged in
return OnBoardingScreen();
```

---

## 🔧 How It Works

### 1. App Initialization (main.dart)
```dart
void main() async {
  // 1. Initialize Hive (local storage)
  await Hive.initFlutter();
  
  // 2. Set locale
  Intl.defaultLocale = 'ar';
  
  // 3. Initialize Firebase
  await Firebase.initializeApp(...);
  
  // 4. Load user from Hive
  await UserManager().init();
  
  // 5. Run app
  runApp(const PlanZ());
}
```

### 2. Check Login Status (PlanZ._getHomeScreen)
```dart
Widget _getHomeScreen() {
  final userManager = UserManager();
  
  if (userManager.isLoggedIn) {
    // Route to dashboard
    return _getDashboardScreen(userManager.userType);
  }
  
  // Show onboarding
  return OnBoardingScreen();
}
```

### 3. After Login (AuthCubit)
```dart
Future<void> signIn(...) async {
  final result = await _authRepository.signIn(...);
  
  result.fold(
    (failure) => emit(AuthSignInError(...)),
    (user) async {
      await _userManager.setUser(user); // ✅ Save
      emit(AuthSignInSuccess(user: user));
    },
  );
}
```

---

## 📊 Data Persistence

### What Gets Saved (Hive)
```
Box: userBox
Key: currentUser
Value: UserModel.toJson()
  {
    "id": "user_123",
    "name": "Ahmed",
    "email": "ahmed@example.com",
    "userType": "vendor",
    "phoneNumber": "+201234567890",
    "fcmToken": "token_xyz",
    "isActive": true,
    "createdAt": "...",
    "updatedAt": "..."
  }
```

### Persistence Duration
- ✅ Survives app restart
- ✅ Survives background kill
- ✅ Survives device restart
- ❌ Lost only on logout or app data clear

---

## 🧪 Testing

### Test 1: Fresh Install
```
1. Uninstall app
2. Install fresh
3. Launch
4. Expected: OnBoardingScreen
5. Check logs: "User is not logged in"
```

### Test 2: Login & Restart
```
1. Login as Vendor
2. See: VendorHomeScreen
3. Kill app
4. Relaunch
5. Expected: VendorHomeScreen (immediate, no onboarding)
6. Check logs: "User is logged in, routing to dashboard"
```

### Test 3: Logout
```
1. Click logout
2. Expected: OnBoardingScreen
3. Check logs: "User logged out"
```

### Test 4: Different User Types
```
1. Login as Event Owner → NavigationScreen
2. Logout
3. Login as Attendee → AttendeeHomeScreen
4. Logout
5. Login as Admin → OwnerDashboardScreen
```

---

## 🐛 Debug Logs

### App Startup
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

### After Login
```
✅ User logged in: Ahmed (vendor)
💾 User saved to local storage
🔍 [PlanZ._getHomeScreen] Checking login status...
   isLoggedIn: true
✅ [PlanZ._getHomeScreen] User is logged in, routing to dashboard
📍 [PlanZ._getHomeScreen] Routing to Vendor Dashboard
```

### After Logout
```
🔴 User logged out
🗑️ User removed from local storage
🔍 [PlanZ._getHomeScreen] Checking login status...
   isLoggedIn: false
❌ [PlanZ._getHomeScreen] User is not logged in, showing onboarding
```

---

## 📝 Key Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | App initialization + home screen selection |
| `lib/features/auth/data/models/user_manager.dart` | Session management + Hive persistence |
| `lib/features/auth/logic/auth_cubit/auth_cubit.dart` | Authentication logic |
| `lib/features/on_boarding/ui/on_boarding_view.dart` | Onboarding screen |
| `lib/features/auth/ui/screens/login_screen.dart` | Login screen |

---

## 🎓 How to Use

### For Users
- ✅ Login once
- ✅ App remembers you
- ✅ Next time you open app, you go straight to dashboard
- ✅ Only see onboarding on first install or after logout

### For Developers
- Check `UserManager().isLoggedIn` to see if user is logged in
- Call `UserManager().setUser(user)` after login
- Call `UserManager().clearUser()` on logout
- Use `UserManager().userType` to determine user type
- All data automatically saved to Hive

---

## ✨ Benefits

| Benefit | Impact |
|---------|--------|
| **Better UX** | Users don't have to login every time |
| **Faster Startup** | App loads dashboard directly |
| **Offline Support** | Can load user data without internet |
| **Session Persistence** | Works across app restarts |
| **Type Safety** | UserType determines correct dashboard |

---

**Status**: ✅ Complete - Session persistence fully implemented
**Last Updated**: November 13, 2025
