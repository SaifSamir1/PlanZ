# ✅ Testing Checklist - Vendor Dashboard Package Requests

## 🎯 الهدف:
اختبار الـ flow الكامل من إنشاء الحدث إلى ظهور الـ requests في الـ Vendor Dashboard.

---

## 📋 الـ Checklist:

### **Phase 1: Setup**

- [ ] **1.1** شغّل التطبيق بـ `flutter run -v`
- [ ] **1.2** افتح الـ console لـ رؤية الـ logs
- [ ] **1.3** افتح Firebase Console في متصفح
- [ ] **1.4** اذهب إلى Firestore Database

---

### **Phase 2: Event Owner - Create Event**

- [ ] **2.1** سجّل دخول كـ Event Owner
  - الـ expected log: `✅ User logged in: [name] (eventOwner)`

- [ ] **2.2** أنشئ حدث جديد
  - الـ expected log: `✅ [createEvent] Event created successfully`

- [ ] **2.3** اختر خدمات (Services)
  - الـ expected log: `📦 [EventCreationCubit] Selected services: [count]`

- [ ] **2.4** ادخل على "Browse Packages"
  - الـ expected log: `📦 [BrowsePackagesScreen] Loaded [count] packages`

- [ ] **2.5** اختر package من الفندق
  - الـ expected log: `✅ [_selectPackage] Selected: [packageName]`

- [ ] **2.6** اضغط "Finish Selection"
  - الـ expected log: `🔄 [_finishSelection] Replacement Mode - Returning package`

- [ ] **2.7** اضغط "Create Event"
  - الـ expected log:
    ```
    📦 [addPackageToEvent] Creating PackageRequest:
       requestId: [id]
       vendorId: [id]
       packageName: [name]
    💾 [addPackageToEvent] Saving to Firestore...
    ✅ [addPackageToEvent] PackageRequest saved successfully!
    ```

---

### **Phase 3: Firestore Verification**

- [ ] **3.1** افتح Firebase Console
- [ ] **3.2** اذهب إلى `packageRequests` collection
- [ ] **3.3** تحقق من وجود الـ request الجديد
  - الـ expected fields:
    ```
    requestId: [id]
    vendorId: [vendor_id]
    packageName: [name]
    status: "pending"
    eventOwnerId: [owner_id]
    ```

- [ ] **3.4** انسخ الـ `vendorId` من الـ request

---

### **Phase 4: Vendor - Open Dashboard**

- [ ] **4.1** سجّل دخول كـ Vendor (استخدم الـ `vendorId` من الـ request)
  - الـ expected log: `✅ User logged in: [name] (vendor)`

- [ ] **4.2** ادخل على الـ Vendor Dashboard
  - الـ expected log:
    ```
    📱 [VendorHomeScreen._loadData] Starting...
       vendorId: [vendor_id]
       userName: [name]
       userEmail: [email]
    🔄 [VendorHomeScreen._loadData] Loading requests...
    ```

- [ ] **4.3** شوف الـ console logs
  - الـ expected log:
    ```
    🔍 [getVendorRequests] Searching for vendorId: [vendor_id]
    📊 [getVendorRequests] Found 1 requests
       📄 Request: [request_id]
          vendorId: [vendor_id]
          packageName: [name]
          status: pending
    ✅ [getVendorRequests] Returning 1 requests
    ```

- [ ] **4.4** شوف الـ UI
  - الـ expected: الـ request بتظهر في الـ list

---

### **Phase 5: Troubleshooting**

#### **إذا ما شُفت الـ logs في Phase 2:**

- [ ] **5.1** تحقق من أن الـ Event Owner سجّل دخول بشكل صحيح
- [ ] **5.2** تحقق من أن الـ event بتحفظ في Firestore
- [ ] **5.3** تحقق من أن الـ package selection بتشتغل

#### **إذا ما شُفت الـ logs في Phase 4:**

- [ ] **5.4** تحقق من أن الـ Vendor سجّل دخول بشكل صحيح
- [ ] **5.5** تحقق من أن الـ `vendorId` صحيح
- [ ] **5.6** تحقق من أن الـ UserManager بيحفظ البيانات

#### **إذا شُفت "Found 0 requests":**

- [ ] **5.7** تحقق من أن الـ `vendorId` في الـ request نفس الـ `vendorId` للـ Vendor
- [ ] **5.8** تحقق من أن الـ request بتحفظ في Firestore
- [ ] **5.9** تحقق من أن الـ collection اسمه صحيح: `packageRequests`

---

### **Phase 6: Advanced Testing**

- [ ] **6.1** أنشئ حدث آخر مع package مختلف
  - الـ expected: الـ requests بتظهر في الـ Vendor Dashboard

- [ ] **6.2** أنشئ حدث مع packages من فندقين مختلفين
  - الـ expected: كل فندق يشوف requests بتاعته فقط

- [ ] **6.3** اختبر accept/reject (إذا كانت الـ functionality موجودة)
  - الـ expected: الـ status بتتغير

- [ ] **6.4** اختبر الـ notifications
  - الـ expected: الـ Event Owner يشوف الـ notification

---

## 📊 الـ Expected Logs Summary:

### **Event Owner Side:**
```
✅ User logged in: [name] (eventOwner)
📦 [EventCreationCubit] Selected services: 3
📦 [BrowsePackagesScreen] Loaded 5 packages
✅ [_selectPackage] Selected: Grand Ballroom
🔄 [_finishSelection] Replacement Mode - Returning package
📦 [addPackageToEvent] Creating PackageRequest:
   requestId: req_abc123
   vendorId: vendor_123
   packageName: Grand Ballroom
💾 [addPackageToEvent] Saving to Firestore...
✅ [addPackageToEvent] PackageRequest saved successfully!
```

### **Vendor Side:**
```
✅ User logged in: Ahmed Vendor (vendor)
📱 [VendorHomeScreen._loadData] Starting...
   vendorId: vendor_123
   userName: Ahmed Vendor
   userEmail: ahmed@vendor.com
🔄 [VendorHomeScreen._loadData] Loading requests...
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

## 🚨 Common Issues:

### **Issue 1: vendorId is null**
```
❌ [VendorHomeScreen._loadData] vendorId is null!
```
**Solution:**
- تأكد من أن الـ Vendor سجّل دخول بشكل صحيح
- تأكد من أن الـ UserManager.init() استُدعي في main.dart

### **Issue 2: Found 0 requests**
```
🔍 [getVendorRequests] Searching for vendorId: vendor_123
📊 [getVendorRequests] Found 0 requests
```
**Solution:**
- تأكد من أن الـ Event Owner أنشأ حدث واختار packages
- تأكد من أن الـ `vendorId` صحيح
- تحقق من Firestore مباشرة

### **Issue 3: Firebase Error**
```
❌ [getVendorRequests] Firebase Error: Permission denied
```
**Solution:**
- تحقق من Firestore security rules
- تأكد من أن الـ rules بتسمح بـ الوصول

---

## 📝 Notes:

- استخدم `Ctrl+F` في الـ console للبحث عن الـ logs
- استخدم `flutter run -v` لـ رؤية كل الـ logs
- الـ logs مرتبة بـ الـ timestamp
- احفظ الـ logs في ملف للمرجعية

---

## ✅ Success Criteria:

- [ ] الـ Event Owner بتقدر تنشئ حدث واختار packages
- [ ] الـ PackageRequest بتحفظ في Firestore
- [ ] الـ Vendor Dashboard بتظهر الـ requests
- [ ] الـ logs بتظهر بدون errors
- [ ] الـ UI بتعرض الـ requests بشكل صحيح

---

**بعد ما تكمل الـ checklist، أخبرني بـ النتائج!** ✅
