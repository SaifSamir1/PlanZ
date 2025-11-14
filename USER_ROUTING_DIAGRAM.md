# 🗺️ PlanZ User Routing Diagram

## Complete User Journey Map

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         APP LAUNCH                                       │
│                      (main() function)                                   │
└────────────────────────────────┬────────────────────────────────────────┘
                                 │
                    ┌────────────┴────────────┐
                    │                         │
                    ▼                         ▼
        ┌──────────────────────┐  ┌──────────────────────┐
        │  Initialize Hive     │  │  Initialize Firebase │
        │  Initialize Intl     │  │  Initialize UserMgr  │
        └──────────────────────┘  └──────────────────────┘
                    │                         │
                    └────────────┬────────────┘
                                 │
                                 ▼
                    ┌────────────────────────┐
                    │  UserManager.init()    │
                    │  Load from Hive        │
                    └────────────┬───────────┘
                                 │
                    ┌────────────┴────────────┐
                    │                         │
                    ▼                         ▼
        ┌──────────────────────┐  ┌──────────────────────┐
        │  User in Hive?       │  │  No User in Hive     │
        │  YES ✅              │  │  NO ❌               │
        └──────────┬───────────┘  └──────────┬───────────┘
                   │                         │
                   ▼                         ▼
        ┌──────────────────────┐  ┌──────────────────────┐
        │ _getHomeScreen()     │  │ _getHomeScreen()     │
        │ isLoggedIn = true    │  │ isLoggedIn = false   │
        └──────────┬───────────┘  └──────────┬───────────┘
                   │                         │
        ┌──────────┴──────────┐              │
        │                     │              │
        ▼                     ▼              ▼
    ┌────────┐           ┌────────┐    ┌──────────────┐
    │ Vendor │           │ Others │    │ OnBoarding   │
    │ Event  │           │ Attendee   │ Screen       │
    │ Owner  │           │ Admin  │    └──────┬───────┘
    │ Attendee           │        │           │
    │ Admin  │           │        │           ▼
    └────────┘           └────────┘    ┌──────────────────┐
        │                              │ Select User Type │
        │                              │ (Vendor/Owner/   │
        │                              │  Attendee/Admin) │
        │                              └────────┬─────────┘
        │                                       │
        ▼                                       ▼
    ┌──────────────────────────────────────────────────────┐
    │           Route to Dashboard                         │
    │  Based on UserType                                   │
    └──────────────────────────────────────────────────────┘
        │
        ├─────────────────────────────────────────┐
        │                                         │
        ▼                                         ▼
    ┌──────────────────┐                ┌──────────────────┐
    │ Vendor Type?     │                │ Event Owner?     │
    │ YES              │                │ YES              │
    └────────┬─────────┘                └────────┬─────────┘
             │                                   │
             ▼                                   ▼
    ┌──────────────────┐                ┌──────────────────┐
    │ VendorHomeScreen │                │ NavigationScreen │
    │                  │                │ (Event Owner)    │
    │ • Requests       │                │                  │
    │ • Packages       │                │ • Create Event   │
    │ • Earnings       │                │ • Browse Packages│
    │ • Orders         │                │ • Track Events   │
    └──────────────────┘                └──────────────────┘
        │
        ▼
    ┌──────────────────┐
    │ Attendee Type?   │
    │ YES              │
    └────────┬─────────┘
             │
             ▼
    ┌──────────────────┐
    │ AttendeeScreen   │
    │                  │
    │ • Invitations    │
    │ • RSVP           │
    │ • Events         │
    └──────────────────┘
        │
        ▼
    ┌──────────────────┐
    │ Admin Type?      │
    │ YES              │
    └────────┬─────────┘
             │
             ▼
    ┌──────────────────┐
    │ AdminDashboard   │
    │                  │
    │ • Users          │
    │ • Packages       │
    │ • Analytics      │
    │ • System         │
    └──────────────────┘
```

---

## Session Persistence Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    LOGIN PROCESS                                │
└─────────────────────────────────────────────────────────────────┘

LoginScreen
    │
    ▼
┌──────────────────────┐
│ Enter Credentials    │
│ • Email              │
│ • Password           │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ AuthCubit.signIn()   │
│ Emit: Loading        │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ Firebase Auth        │
│ Verify credentials   │
└──────────┬───────────┘
           │
    ┌──────┴──────┐
    │             │
    ▼             ▼
Success       Failure
    │             │
    ▼             ▼
┌──────────┐  ┌──────────┐
│ Get User │  │ Emit     │
│ from DB  │  │ Error    │
└────┬─────┘  └──────────┘
     │
     ▼
┌──────────────────────┐
│ UserManager.setUser()│
│ Save to Hive         │
│ Save to Memory       │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ AuthCubit            │
│ Emit: Success        │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ LoginScreen          │
│ Navigate to          │
│ Dashboard            │
└──────────────────────┘
```

---

## Hive Storage Structure

```
┌─────────────────────────────────────────────────────┐
│              HIVE LOCAL STORAGE                     │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Box Name: userBox                                  │
│  ├─ Key: currentUser                               │
│  │  └─ Value: UserModel.toJson()                   │
│  │     {                                            │
│  │       "id": "user_123",                          │
│  │       "name": "Ahmed",                           │
│  │       "email": "ahmed@example.com",              │
│  │       "userType": "vendor",                      │
│  │       "phoneNumber": "+201234567890",            │
│  │       "fcmToken": "token_xyz",                   │
│  │       "isActive": true,                          │
│  │       "createdAt": "2025-11-13T...",             │
│  │       "updatedAt": "2025-11-13T..."              │
│  │     }                                            │
│  │                                                  │
│  └─ Persists across:                               │
│     ✅ App restart                                  │
│     ✅ Background kill                              │
│     ✅ Device restart                               │
│     ❌ Logout (cleared)                             │
│     ❌ App data clear (cleared)                     │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## UserManager Singleton Pattern

```
┌──────────────────────────────────────────────────┐
│          UserManager (Singleton)                 │
├──────────────────────────────────────────────────┤
│                                                  │
│  Private Constructor                             │
│  └─ UserManager._internal()                      │
│                                                  │
│  Static Instance                                 │
│  └─ _instance = UserManager._internal()          │
│                                                  │
│  Factory Constructor                             │
│  └─ factory UserManager() => _instance           │
│                                                  │
│  Usage:                                          │
│  ├─ UserManager() → returns _instance            │
│  ├─ UserManager() → returns same _instance       │
│  └─ UserManager() → returns same _instance       │
│                                                  │
│  All references point to SAME object ✅          │
│                                                  │
└──────────────────────────────────────────────────┘
```

---

## Dashboard Routing Decision Tree

```
                    ┌─────────────────────┐
                    │ _getHomeScreen()    │
                    └──────────┬──────────┘
                               │
                    ┌──────────┴──────────┐
                    │                     │
                    ▼                     ▼
            ┌──────────────┐      ┌──────────────┐
            │ isLoggedIn?  │      │ isLoggedIn?  │
            │ YES ✅       │      │ NO ❌        │
            └──────┬───────┘      └──────┬───────┘
                   │                     │
                   ▼                     ▼
            ┌──────────────┐      ┌──────────────┐
            │ Check        │      │ Return       │
            │ userType     │      │ OnBoarding   │
            └──────┬───────┘      │ Screen       │
                   │              └──────────────┘
        ┌──────────┼──────────┬──────────┐
        │          │          │          │
        ▼          ▼          ▼          ▼
    ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐
    │vendor│  │owner │  │attend│  │admin │
    └──┬───┘  └──┬───┘  └──┬───┘  └──┬───┘
       │         │         │         │
       ▼         ▼         ▼         ▼
    ┌──────────────────────────────────────┐
    │ Return Appropriate Dashboard         │
    ├──────────────────────────────────────┤
    │ Vendor    → VendorHomeScreen         │
    │ Owner     → NavigationScreen          │
    │ Attendee  → AttendeeHomeScreen       │
    │ Admin     → OwnerDashboardScreen     │
    └──────────────────────────────────────┘
```

---

## Logout Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    LOGOUT PROCESS                               │
└─────────────────────────────────────────────────────────────────┘

Dashboard
(Any screen)
    │
    ▼
┌──────────────────────┐
│ User clicks Logout   │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ AuthCubit.signOut()  │
│ Emit: Loading        │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ Firebase.signOut()   │
│ Clear auth tokens    │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ UserManager.         │
│ clearUser()          │
│ • Clear memory       │
│ • Clear Hive         │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ AuthCubit            │
│ Emit: Success        │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ Navigate to          │
│ OnBoardingScreen     │
└──────────────────────┘
```

---

## Multi-User Scenario

```
┌─────────────────────────────────────────────────────────────────┐
│              SWITCHING BETWEEN USERS                            │
└─────────────────────────────────────────────────────────────────┘

User A (Vendor)
Logged In
    │
    ▼
┌──────────────────────┐
│ Click Logout         │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ Clear Hive           │
│ Show OnBoarding      │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ Select: Event Owner  │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ Login as Event Owner │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ Save to Hive         │
│ (User B data)        │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ Navigate to          │
│ NavigationScreen     │
│ (Event Owner)        │
└──────────────────────┘

User B (Event Owner)
Logged In
```

---

## Debug Log Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    DEBUG LOG OUTPUT                             │
└─────────────────────────────────────────────────────────────────┘

App Launch:
  ✅ Hive initialized
  ✅ Intl locale set to Arabic
  ✅ Firebase initialized
  ✅ UserManager initialized
  📂 User loaded from local storage: Ahmed
  
Home Screen Selection:
  🔍 [PlanZ._getHomeScreen] Checking login status...
     isLoggedIn: true
     userId: user_123
     userType: vendor
  ✅ [PlanZ._getHomeScreen] User is logged in, routing to dashboard
  📍 [PlanZ._getHomeScreen] Routing to Vendor Dashboard
  
After Login:
  ✅ User logged in: Ahmed (vendor)
  💾 User saved to local storage
  
After Logout:
  🔴 User logged out
  🗑️ User removed from local storage
```

---

## File Organization

```
lib/
├── main.dart ✅ (MODIFIED)
│   └─ _getHomeScreen() - Smart routing
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── user_model.dart
│   │   │   │   └── user_manager.dart ✅ (Session management)
│   │   │   └── auth_repo/
│   │   │       └── auth_repo_impl.dart
│   │   ├── logic/
│   │   │   └── auth_cubit/
│   │   │       ├── auth_cubit.dart ✅ (Calls UserManager)
│   │   │       └── auth_state.dart
│   │   └── ui/
│   │       └── screens/
│   │           ├── login_screen.dart
│   │           └── sign_up_screen.dart
│   │
│   ├── on_boarding/
│   │   └── ui/
│   │       └── on_boarding_view.dart
│   │
│   ├── vendor_features/
│   │   └── vendor_home/
│   │       └── ui/screens/
│   │           └── vendor_home_screen.dart
│   │
│   ├── event_owners/
│   │   └── event_owner_home/
│   │       └── ui/screens/
│   │           └── navigation_screen.dart
│   │
│   ├── attandee/
│   │   └── ui/home/
│   │       └── ui/screens/
│   │           └── attendee_home_screen.dart
│   │
│   └── app_owner/
│       └── ui/screens/
│           └── owner_dashboard_screen.dart
│
└── core/
    ├── services/
    │   └── auth_hive_service.dart (Alternative approach)
    └── ...
```

---

**Last Updated**: November 13, 2025
**Status**: ✅ Complete - All routing diagrams documented
