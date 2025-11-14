# 🔍 Vendor Dashboard - Package Requests Debugging Guide

## 📋 المشكلة:
الـ Vendor Dashboard ما بتظهر الـ package requests رغم أن الـ Event Owner بعت طلبات.

---

## 🔧 الـ Debugging Steps:

### **الخطوة 1: تشغيل التطبيق وفتح Vendor Dashboard**

**ما تحتاج تفعله:**
1. شغّل التطبيق
2. سجّل دخول كـ Vendor
3. ادخل على الـ Vendor Dashboard

**ما تشوف في الـ Console:**
```
📱 [VendorHomeScreen._loadData] Starting...
   vendorId: vendor_123
   userName: Ahmed Vendor
   userEmail: ahmed@vendor.com
🔄 [VendorHomeScreen._loadData] Loading requests...
📊 [VendorHomeScreen._loadData] Loading stats...
📦 [VendorHomeScreen._loadData] Loading packages...
```

**إذا شُفت `vendorId: null`:**
- ❌ المشكلة: الـ UserManager ما بيرجع الـ vendorId الصحيح
- 🔧 الحل: تأكد من أن الـ Vendor سجّل دخول بشكل صحيح

---

### **الخطوة 2: فحص الـ Requests Query**

**ما تشوف في الـ Console:**
```
🔍 [getVendorRequests] Searching for vendorId: vendor_123
📊 [getVendorRequests] Found 0 requests
✅ [getVendorRequests] Returning 0 requests
```

**إذا شُفت `Found 0 requests`:**
- ❌ المشكلة: ما في requests في Firestore بـ هذا الـ vendorId
- 🔧 الحل: تحقق من الخطوة التالية

---

### **الخطوة 3: تشغيل Event Owner وإنشاء حدث**

**ما تحتاج تفعله:**
1. سجّل دخول كـ Event Owner (في متصفح آخر أو جهاز آخر)
2. أنشئ حدث جديد
3. اختر packages من الفندقين
4. أكمل الإنشاء

**ما تشوف في الـ Console (Event Owner Side):**
```
📦 [addPackageToEvent] Creating PackageRequest:
   requestId: req_abc123
   vendorId: vendor_123
   vendorName: Ahmed Vendor
   packageId: pkg_456
   packageName: Grand Ballroom
   eventId: evt_789
   eventOwnerId: owner_001
💾 [addPackageToEvent] Saving to Firestore...
✅ [addPackageToEvent] PackageRequest saved successfully!
```

**إذا شُفت الـ logs:**
- ✅ الـ PackageRequest بتحفظ بشكل صحيح
- تحقق من أن الـ `vendorId` نفس الـ `vendorId` اللي بتبحث عنه الـ Vendor

---

### **الخطوة 4: فحص الـ Firestore مباشرة**

**ما تحتاج تفعله:**
1. افتح Firebase Console
2. اذهب إلى Firestore Database
3. ادخل على collection `packageRequests`

**ما تشوف:**
```
packageRequests/
  ├─ req_abc123/
  │   ├─ requestId: "req_abc123"
  │   ├─ vendorId: "vendor_123"  ← تأكد من أن هذا موجود!
  │   ├─ packageName: "Grand Ballroom"
  │   ├─ status: "pending"
  │   └─ ... other fields
  └─ req_def456/
      ├─ vendorId: "vendor_456"
      └─ ...
```

**إذا شُفت الـ requests:**
- ✅ الـ requests موجودة في Firestore
- تحقق من أن الـ `vendorId` صحيح

**إذا ما شُفت الـ requests:**
- ❌ المشكلة: الـ requests ما بتحفظ في Firestore
- 🔧 الحل: تحقق من الـ Event Owner logs

---

### **الخطوة 5: فحص الـ Vendor Dashboard مرة أخرى**

**ما تحتاج تفعله:**
1. ارجع إلى الـ Vendor Dashboard
2. اضغط على زر Refresh (أو أغلق وافتح الـ app من جديد)

**ما تشوف في الـ Console:**
```
🔍 [getVendorRequests] Searching for vendorId: vendor_123
📊 [getVendorRequests] Found 1 requests
   📄 Request: req_abc123
      vendorId: vendor_123
      packageName: Grand Ballroom
      status: pending
✅ [getVendorRequests] Returning 1 requests
```

**ثم في الـ UI:**
```
📋 [_buildRequestsList] State: GetVendorRequestsSuccess
✅ [_buildRequestsList] Success: 1 requests
   [0] Grand Ballroom - pending
```

**إذا شُفت الـ logs:**
- ✅ الـ requests بتظهر بشكل صحيح!

---

## 🐛 المشاكل الشائعة والحلول:

### **المشكلة 1: vendorId is null**
```
❌ [VendorHomeScreen._loadData] vendorId is null!
```

**السبب:**
- الـ Vendor ما سجّل دخول بشكل صحيح
- الـ UserManager ما بيحفظ البيانات بشكل صحيح

**الحل:**
1. تأكد من أن الـ Vendor سجّل دخول كـ Vendor (مش Event Owner)
2. تحقق من أن الـ UserManager.init() استُدعي في main.dart
3. تحقق من أن الـ Hive box بتحفظ البيانات بشكل صحيح

---

### **المشكلة 2: Found 0 requests**
```
🔍 [getVendorRequests] Searching for vendorId: vendor_123
📊 [getVendorRequests] Found 0 requests
```

**السبب:**
- ما في requests في Firestore بـ هذا الـ vendorId
- الـ Event Owner ما بعت طلبات

**الحل:**
1. تأكد من أن الـ Event Owner أنشأ حدث واختار packages
2. تأكد من أن الـ vendorId في الـ PackageRequest نفس الـ vendorId للـ Vendor
3. تحقق من Firestore مباشرة

---

### **المشكلة 3: vendorId مختلف**
```
🔍 [getVendorRequests] Searching for vendorId: vendor_123
📊 [getVendorRequests] Found 0 requests

// لكن في Firestore:
packageRequests/req_abc123/vendorId: "vendor_456"
```

**السبب:**
- الـ Event Owner اختار package من vendor مختلف
- الـ vendorId في الـ PackageRequest مختلف عن الـ vendorId للـ Vendor الحالي

**الحل:**
1. تأكد من أن الـ Event Owner اختار package من الـ Vendor الصحيح
2. تأكد من أن الـ vendorId في الـ package صحيح

---

### **المشكلة 4: Firebase Error**
```
❌ [getVendorRequests] Firebase Error: Permission denied
```

**السبب:**
- Firestore security rules ما بتسمح بـ الوصول
- الـ User ما عنده permission

**الحل:**
1. تحقق من Firestore security rules
2. تأكد من أن الـ rules بتسمح بـ الوصول للـ collection

---

## 📊 الـ Console Output الكامل:

### **السيناريو الناجح:**

**Event Owner Side:**
```
📦 [addPackageToEvent] Creating PackageRequest:
   requestId: req_abc123
   vendorId: vendor_123
   vendorName: Ahmed Vendor
   packageId: pkg_456
   packageName: Grand Ballroom
   eventId: evt_789
   eventOwnerId: owner_001
💾 [addPackageToEvent] Saving to Firestore...
✅ [addPackageToEvent] PackageRequest saved successfully!
```

**Vendor Side:**
```
📱 [VendorHomeScreen._loadData] Starting...
   vendorId: vendor_123
   userName: Ahmed Vendor
   userEmail: ahmed@vendor.com
🔄 [VendorHomeScreen._loadData] Loading requests...
📊 [VendorHomeScreen._loadData] Loading stats...
📦 [VendorHomeScreen._loadData] Loading packages...

🔍 [getVendorRequests] Searching for vendorId: vendor_123
📊 [getVendorRequests] Found 1 requests
   📄 Request: req_abc123
      vendorId: vendor_123
      packageName: Grand Ballroom
      status: pending
✅ [getVendorRequests] Returning 1 requests

📋 [_buildRequestsList] State: GetVendorRequestsSuccess
✅ [_buildRequestsList] Success: 1 requests
   [0] Grand Ballroom - pending
```

---

## 🎯 الخطوات التالية:

بعد ما تتأكد من أن الـ requests بتظهر:

1. **اختبر قبول الطلب:**
   - اضغط على الطلب
   - اختر "Accept"
   - تحقق من أن الـ status تغير إلى "accepted"

2. **اختبر رفض الطلب:**
   - اضغط على الطلب
   - اختر "Reject"
   - أدخل سبب الرفض
   - تحقق من أن الـ status تغير إلى "rejected"

3. **اختبر الـ Event Owner Side:**
   - تحقق من أن الـ Event Owner يشوف الـ status الجديد
   - تحقق من أن الـ notifications بتظهر

---

## 📝 ملاحظات مهمة:

- الـ debugging logs بتظهر فقط في الـ Debug mode
- استخدم `flutter run -v` لـ رؤية كل الـ logs
- استخدم `Ctrl+F` في الـ console لـ البحث عن الـ logs
- الـ logs مرتبة بـ الـ timestamp، فـ يمكنك متابعة الـ flow

---

## 🚀 الخطوات المطلوبة منك:

1. **شغّل التطبيق** مع الـ debugging logs
2. **أنشئ حدث** كـ Event Owner واختر packages
3. **ادخل الـ Vendor Dashboard** وشوف الـ logs
4. **أخبرني بـ الـ logs اللي شُفت** حتى أعرف أين المشكلة بالضبط

---

**بعد ما تعمل الخطوات دي، أخبرني بـ الـ logs اللي شُفت في الـ console!** 🔍
