# ✅ Session Persistence - Testing Checklist

## 🧪 Test Cases

### Test 1: Fresh Install (First Time User)

**Setup**:
- Uninstall app completely
- Clear all app data
- Fresh install

**Steps**:
1. [ ] Launch app
2. [ ] Observe console logs
3. [ ] Check screen displayed

**Expected Results**:
- [ ] OnBoardingScreen appears
- [ ] Console shows: `❌ [PlanZ._getHomeScreen] User is not logged in`
- [ ] Console shows: `📂 No user found in local storage`
- [ ] User can select user type

**Logs to Check**:
```
✅ Hive initialized
✅ Intl locale set to Arabic
✅ Firebase initialized
✅ UserManager initialized
📂 No user found in local storage
🔍 [PlanZ._getHomeScreen] Checking login status...
   isLoggedIn: false
   userId: null
   userType: null
❌ [PlanZ._getHomeScreen] User is not logged in, showing onboarding
```

---

### Test 2: Login as Vendor

**Setup**:
- Fresh app (from Test 1)
- Have vendor credentials ready

**Steps**:
1. [ ] Select "Vendor" from onboarding
2. [ ] Enter vendor email and password
3. [ ] Click login
4. [ ] Observe screen and logs

**Expected Results**:
- [ ] Login succeeds
- [ ] VendorHomeScreen appears
- [ ] Console shows: `✅ User logged in: {vendor_name}`
- [ ] Console shows: `💾 User saved to local storage`

**Logs to Check**:
```
✅ User logged in: Ahmed (vendor)
💾 User saved to local storage
🔍 [PlanZ._getHomeScreen] Checking login status...
   isLoggedIn: true
   userId: user_123
   userType: vendor
✅ [PlanZ._getHomeScreen] User is logged in, routing to dashboard
📍 [PlanZ._getHomeScreen] Routing to Vendor Dashboard
```

---

### Test 3: App Restart (Session Persistence)

**Setup**:
- From Test 2 (vendor logged in)

**Steps**:
1. [ ] Kill app completely (background kill)
2. [ ] Wait 2-3 seconds
3. [ ] Relaunch app
4. [ ] Observe screen and logs

**Expected Results**:
- [ ] VendorHomeScreen appears IMMEDIATELY ✅
- [ ] NO onboarding screen
- [ ] NO login screen
- [ ] Console shows: `📂 User loaded from local storage: {vendor_name}`
- [ ] Console shows: `✅ [PlanZ._getHomeScreen] User is logged in, routing to dashboard`

**Logs to Check**:
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

### Test 4: Logout

**Setup**:
- From Test 3 (vendor logged in and app restarted)

**Steps**:
1. [ ] Find logout button in VendorHomeScreen
2. [ ] Click logout
3. [ ] Observe screen and logs

**Expected Results**:
- [ ] OnBoardingScreen appears
- [ ] Console shows: `🔴 User logged out`
- [ ] Console shows: `🗑️ User removed from local storage`

**Logs to Check**:
```
🔴 User logged out
🗑️ User removed from local storage
🔍 [PlanZ._getHomeScreen] Checking login status...
   isLoggedIn: false
   userId: null
   userType: null
❌ [PlanZ._getHomeScreen] User is not logged in, showing onboarding
```

---

### Test 5: Login as Event Owner

**Setup**:
- From Test 4 (logged out)
- Have event owner credentials ready

**Steps**:
1. [ ] Select "Event Owner" from onboarding
2. [ ] Enter event owner email and password
3. [ ] Click login
4. [ ] Observe screen

**Expected Results**:
- [ ] Login succeeds
- [ ] NavigationScreen appears (Event Owner Dashboard)
- [ ] Console shows: `✅ User logged in: {owner_name}`
- [ ] Console shows: `📍 [PlanZ._getHomeScreen] Routing to Event Owner Dashboard`

**Logs to Check**:
```
✅ User logged in: Sarah (eventOwner)
💾 User saved to local storage
📍 [PlanZ._getHomeScreen] Routing to Event Owner Dashboard
```

---

### Test 6: App Restart as Event Owner

**Setup**:
- From Test 5 (event owner logged in)

**Steps**:
1. [ ] Kill app
2. [ ] Relaunch app
3. [ ] Observe screen

**Expected Results**:
- [ ] NavigationScreen appears IMMEDIATELY ✅
- [ ] NO onboarding or login
- [ ] Console shows: `📂 User loaded from local storage: {owner_name}`

---

### Test 7: Login as Attendee

**Setup**:
- From Test 6 (event owner logged in)
- Logout first
- Have attendee credentials ready

**Steps**:
1. [ ] Logout
2. [ ] Select "Attendee" from onboarding
3. [ ] Enter attendee email and password
4. [ ] Click login

**Expected Results**:
- [ ] Login succeeds
- [ ] AttendeeHomeScreen appears
- [ ] Console shows: `📍 [PlanZ._getHomeScreen] Routing to Attendee Dashboard`

---

### Test 8: Login as Admin

**Setup**:
- From Test 7 (attendee logged in)
- Logout first
- Have admin credentials ready

**Steps**:
1. [ ] Logout
2. [ ] Select "Admin" from onboarding
3. [ ] Enter admin email and password
4. [ ] Click login

**Expected Results**:
- [ ] Login succeeds
- [ ] OwnerDashboardScreen appears
- [ ] Console shows: `📍 [PlanZ._getHomeScreen] Routing to Admin Dashboard`

---

### Test 9: Multiple User Switches

**Setup**:
- From Test 8 (admin logged in)

**Steps**:
1. [ ] Logout
2. [ ] Login as Vendor
3. [ ] Verify VendorHomeScreen
4. [ ] Logout
5. [ ] Login as Event Owner
6. [ ] Verify NavigationScreen
7. [ ] Logout
8. [ ] Login as Attendee
9. [ ] Verify AttendeeHomeScreen

**Expected Results**:
- [ ] Each login shows correct dashboard
- [ ] Each logout shows onboarding
- [ ] No errors in console
- [ ] Hive data updates correctly

---

### Test 10: Device Restart

**Setup**:
- From Test 9 (attendee logged in)

**Steps**:
1. [ ] Leave app running
2. [ ] Restart device
3. [ ] Relaunch app

**Expected Results**:
- [ ] AttendeeHomeScreen appears ✅
- [ ] Session persists across device restart
- [ ] Console shows: `📂 User loaded from local storage`

---

### Test 11: Clear App Data

**Setup**:
- From Test 10 (attendee logged in)

**Steps**:
1. [ ] Go to Settings → Apps → PlanZ
2. [ ] Click "Clear Data"
3. [ ] Relaunch app

**Expected Results**:
- [ ] OnBoardingScreen appears
- [ ] Console shows: `📂 No user found in local storage`
- [ ] Session cleared as expected

---

### Test 12: Network Offline

**Setup**:
- From Test 11 (fresh app)
- Turn off network/WiFi

**Steps**:
1. [ ] Try to login offline
2. [ ] Observe error handling

**Expected Results**:
- [ ] Error message displayed
- [ ] User not logged in
- [ ] OnBoardingScreen remains

**Then**:
1. [ ] Turn network back on
2. [ ] Login successfully
3. [ ] Verify session saved

---

## 📋 Verification Checklist

### Console Logs
- [ ] App startup logs appear
- [ ] Login logs appear
- [ ] Logout logs appear
- [ ] Routing logs appear
- [ ] No error messages
- [ ] All emoji prefixes present

### Hive Storage
- [ ] User data saved after login
- [ ] User data loaded on restart
- [ ] User data cleared after logout
- [ ] No duplicate entries

### Navigation
- [ ] Correct dashboard for each user type
- [ ] Smooth transitions
- [ ] No stuck screens
- [ ] Back button works correctly

### User Experience
- [ ] No onboarding after login
- [ ] Fast app startup (< 3 seconds)
- [ ] Smooth dashboard loading
- [ ] Clear logout confirmation

---

## 🐛 Bug Checklist

### Critical Issues
- [ ] App crashes on startup
- [ ] User data not saving
- [ ] User data not loading
- [ ] Wrong dashboard displayed
- [ ] Session not persisting

### Minor Issues
- [ ] Slow app startup
- [ ] Delayed dashboard loading
- [ ] Missing console logs
- [ ] Incorrect log messages

---

## ✅ Sign-Off Checklist

### Before Deployment
- [ ] All 12 tests passed
- [ ] No critical bugs
- [ ] Console logs clean
- [ ] User experience smooth
- [ ] Documentation complete

### Code Quality
- [ ] No unused imports
- [ ] No console errors
- [ ] No warnings
- [ ] Code formatted properly
- [ ] Comments clear

### Documentation
- [ ] USER_FLOW_DOCUMENTATION.md ✅
- [ ] SESSION_PERSISTENCE_GUIDE.md ✅
- [ ] IMPLEMENTATION_SUMMARY.md ✅
- [ ] USER_ROUTING_DIAGRAM.md ✅
- [ ] TESTING_CHECKLIST_SESSION.md ✅

---

## 📊 Test Results Summary

| Test | Status | Notes |
|------|--------|-------|
| Fresh Install | [ ] | |
| Login Vendor | [ ] | |
| App Restart | [ ] | |
| Logout | [ ] | |
| Login Event Owner | [ ] | |
| Restart Event Owner | [ ] | |
| Login Attendee | [ ] | |
| Login Admin | [ ] | |
| Multiple Switches | [ ] | |
| Device Restart | [ ] | |
| Clear App Data | [ ] | |
| Network Offline | [ ] | |

---

## 🎯 Success Criteria

**All tests must pass**:
- ✅ Fresh install shows onboarding
- ✅ Login saves to Hive
- ✅ App restart loads from Hive
- ✅ Routes to correct dashboard
- ✅ Logout clears session
- ✅ Different user types work
- ✅ Console logs are clean
- ✅ No errors or crashes
- ✅ User experience is smooth

---

## 📝 Notes

### Common Issues to Watch For
1. **Unused imports** - Remove if not needed
2. **Null safety** - Check for null values
3. **Async/await** - Ensure proper ordering
4. **State management** - BLoC states emit correctly
5. **Navigation** - Routes work as expected

### Debugging Tips
1. Check console logs with emoji prefixes
2. Use `UserManager().printUserInfo()` to debug
3. Check Hive data with `UserManager().hasStoredUser()`
4. Use breakpoints in `_getHomeScreen()`
5. Monitor Firebase Auth state

---

**Date**: November 13, 2025
**Status**: Ready for Testing
**Version**: 1.0.0
