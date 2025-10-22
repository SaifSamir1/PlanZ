📍 Part 1: Vendor Creates Package

1. Vendor يدخل على "Create New Package"

2. يختار Service من dropdown:
   - يحمل الـ Services من local JSON
   - يعرضهم في dropdown
   - مثال: يختار "Venue & Spaces"

3. يختار Event Types المناسبة:
   ☑ Wedding
   ☐ Birthday
   ☐ Corporate
   ☑ Engagement
   ☐ Baby Shower
   ☐ Graduation

4. يدخل تفاصيل الـ Package:
   - Package Name
   - Description
   - Price
   - Capacity (if applicable)
   - Duration (if applicable)
   - What's Included (list of items)
   - Images (upload)
   - Location details

5. System Auto-generates keywords:
   - من اسم الـ Service
   - من الـ Event Types المختارة
   - من عنوان الـ Package
   - من الـ Description

6. يضغط "Publish Package"

7. System:
   - يحفظ في Firestore collection: packages/
   - يعمل validation للبيانات
   - يرسل confirmation للـ Vendor


📍 Part 2: Event Owner Creates Event
Step 1: Select Event Type

UI:
- يعرض الـ 6 أنواع في Grid Cards
- كل card يحتوي على:
  * Icon
  * Event Name
  * Short Description
  * "Select" button

User Action:
- يختار مثلاً "Wedding"

System Action:
- يحمل الـ Wedding configuration من local JSON
- يحفظ في الـ state
- ينتقل للـ Step 2

Step 2: Basic Event Information

UI Form:
┌────────────────────────────────┐
│ Event Name: [_______________]  │
│ Event Date: [📅 Picker]        │
│ Event Time: [🕐 Picker]        │
│ City: [Dropdown ▼]            │
│ Area: [Dropdown ▼]            │
│ Guest Count: [______]          │
│ Additional Notes: [_______]    │
│                                │
│ [Previous] [Next Step →]       │
└────────────────────────────────┘

System Action:
- يحفظ البيانات مؤقتاً في state
- validation للحقول المطلوبة
- ينتقل للـ Step 3

Step 3: Budget Setup
UI:
┌─────────────────────────────────────────┐
│ 💰 Set Your Budget                      │
├─────────────────────────────────────────┤
│                                         │
│ Similar weddings cost between:          │
│ 50,000 - 500,000 EGP                   │
│ Average: 150,000 EGP                    │
│                                         │
│ Enter Your Total Budget:                │
│ [_______________] EGP                   │
│                                         │
│ ✓ Auto Budget Allocation:               │
│                                         │
│ 🏛️ Venue:        45,000 (30%) [Edit]  │
│ 🍽️ Catering:     37,500 (25%) [Edit]  │
│ 📷 Photography:  22,500 (15%) [Edit]  │
│ 🎨 Decoration:   22,500 (15%) [Edit]  │
│ 🎵 Entertainment:15,000 (10%) [Edit]  │
│ 🎂 Cake:          7,500  (5%) [Edit]  │
│                                         │
│ Total: 150,000 / 150,000 ✓             │
│                                         │
│ [Previous] [Confirm Budget →]           │
└─────────────────────────────────────────┘

System Logic:
1. يحسب auto allocation based on config
2. لو User عدل أي رقم:
   - يحسب الـ total الجديد
   - لو اختلف عن الـ budget، يعرض warning
3. يحفظ الـ budget allocation
4. ينتقل للـ Step 4

Step 4: Services Selection & Review

UI:
┌──────────────────────────────────────────┐
│ Select Services for Your Event           │
├──────────────────────────────────────────┤
│                                          │
│ ✅ Required Services:                    │
│ ✓ Venue & Spaces       (45,000 EGP)     │
│ ✓ Catering & Food      (37,500 EGP)     │
│ ✓ Photography & Video  (22,500 EGP)     │
│                                          │
│ ☐ Optional Services:                     │
│ ✓ Decoration & Flowers (22,500 EGP)     │
│ ✓ Entertainment        (15,000 EGP)     │
│ □ Wedding Cake         ( 7,500 EGP)     │
│ □ Invitations          ( 0 EGP)         │
│                                          │
│ Total Allocated: 142,500 EGP             │
│ Unallocated: 7,500 EGP                  │
│                                          │
│ [Previous] [Browse Packages →]           │
└──────────────────────────────────────────┘

User Action:
- يقدر يشيل Optional services
- لو شال service، Budget بتاعها تتوزع تلقائياً

System Action:
- يحدث الـ budget allocation
- يحفظ الـ selected services
- ينتقل للـ Step 5

Step 5: Browse & Select Packages (الجزء المهم جداً)

For Each Selected Service (واحدة واحدة):

UI Layout:
┌────────────────────────────────────────────┐
│ 🏛️ Venue & Spaces                         │
│ Budget: 45,000 EGP | Spent: 0 | Left: 45k │
│ ▓▓▓▓▓▓░░░░░░░░░░░░ 0%                     │
├────────────────────────────────────────────┤
│                                            │
│ [Filters ▼] [Sort By: Price ▼]           │
│                                            │
│ ┌─────────────────────────────────────┐  │
│ │ 📸 Premium Wedding Hall Package      │  │
│ │ by Grand Events Hall ⭐ 4.5 (120)   │  │
│ │                                      │  │
│ │ [Image Gallery]                      │  │
│ │                                      │  │
│ │ 💵 50,000 EGP                        │  │
│ │ 👥 Capacity: 500 guests              │  │
│ │ ⏱️ Duration: 6 hours                 │  │
│ │ 📍 Nasr City, Cairo                  │  │
│ │                                      │  │
│ │ Includes:                            │  │
│ │ • Hall rental                        │  │
│ │ • Tables & chairs                    │  │
│ │ • Basic decoration                   │  │
│ │ • Sound system                       │  │
│ │                                      │  │
│ │ [View Details] [Select Package]      │  │
│ └─────────────────────────────────────┘  │
│                                            │
│ ┌─────────────────────────────────────┐  │
│ │ Another Package...                   │  │
│ └─────────────────────────────────────┘  │
│                                            │
│ [Skip This Service] [Next Service →]      │
└────────────────────────────────────────────┘

Firestore Query:
packagesRef
  .where('serviceId', '==', 'srv_venue')
  .where('eventTypes', 'array-contains', 'evt_wedding')
  .where('price', '<=', 54000) // 45k + 20% margin
  .where('isActive', '==', true)
  .where('isAvailable', '==', true)
  .orderBy('rating', 'desc')
  .limit(20)

User Selects Package:
1. يضغط "Select Package"

2. System يعمل:
   a. يضيف الـ Package للـ selectedPackages
   
   b. Budget Update:
      servicesBudget['srv_venue'].spent = 50000
      servicesBudget['srv_venue'].remaining = -5000
      totalSpent = 50000
      totalRemaining = 100000
   
   c. Check Over Budget:
      if (spent > allocated) {
        showWarning(
          "⚠️ Service Over Budget!",
          "Venue: Allocated 45,000 | Spent 50,000",
          "You exceeded by 5,000 EGP"
        )
      }
   
   d. Update UI:
      - Progress bar → 111%
      - Remaining → -5,000 (in red)
      - Show selected package card
   
   e. Auto Navigate:
      - ينتقل للـ Service التالي (Catering)

3. User يقدر يعمل:
   - Remove Package (يرجع الفلوس للـ budget)
   - Skip Service (لو optional)
   - Go back to previous service

هكذا لكل Service...

Step 6: Review & Summary

UI:
┌────────────────────────────────────────────┐
│ 📋 Event Summary & Review                  │
├────────────────────────────────────────────┤
│                                            │
│ 📅 Event Details:                          │
│ • Name: Sarah & Ahmed Wedding              │
│ • Date: December 15, 2025                  │
│ • Location: Nasr City, Cairo               │
│ • Guests: 350                              │
│                                            │
├────────────────────────────────────────────┤
│ 💰 Budget Overview:                        │
│                                            │
│ Total Budget:    150,000 EGP               │
│ Total Spent:     142,000 EGP               │
│ Remaining:         8,000 EGP               │
│ ████████████████░░ 94.6%                  │
│                                            │
├────────────────────────────────────────────┤
│ 📦 Selected Packages:                      │
│                                            │
│ 🏛️ Venue & Spaces:                        │
│ ├─ Premium Wedding Hall                    │
│ ├─ by Grand Events Hall                    │
│ ├─ 50,000 EGP ⚠️ (over by 5,000)          │
│ └─ [Remove] [View]                         │
│                                            │
│ 🍽️ Catering & Food:                       │
│ ├─ Premium Buffet Package                  │
│ ├─ by Delicious Catering                   │
│ ├─ 38,000 EGP ⚠️ (over by 500)            │
│ └─ [Remove] [View]                         │
│                                            │
│ 📷 Photography & Videography:              │
│ ├─ Full Day Coverage                       │
│ ├─ by Moments Photography                  │
│ ├─ 20,000 EGP ✓                           │
│ └─ [Remove] [View]                         │
│                                            │
│ ... (باقي الـ services)                   │
│                                            │
├────────────────────────────────────────────┤
│ ⚠️ Budget Warnings:                        │
│ • Venue exceeded by 5,000 EGP              │
│ • Catering exceeded by 500 EGP             │
│ • Consider adjusting budget or packages    │
│                                            │
├────────────────────────────────────────────┤
│                                            │
│ [Edit Event] [Change Packages] [Continue →]│
└────────────────────────────────────────────┘

Step 7: Payment (Mock Payment)

UI:
┌────────────────────────────────────────────┐
│ 💳 Payment                                 │
├────────────────────────────────────────────┤
│                                            │
│ Total Amount: 142,000 EGP                  │
│                                            │
│ Select Payment Method:                     │
│                                            │
│ ○ Credit/Debit Card 💳                    │
│ ○ E-Wallet 📱                             │
│ ○ PayPal                                   │
│                                            │
│ [If Credit Card selected:]                 │
│ Card Number: [________________]            │
│ Expiry: [MM/YY] CVV: [___]                │
│ Cardholder Name: [____________]            │
│                                            │
│ ☐ I agree to terms and conditions          │
│                                            │
│ [Cancel] [Proceed to Pay →]                │
└────────────────────────────────────────────┘

Payment Flow (Mock):
1. User يختار payment method
2. يدخل بيانات (شكلياً فقط)
3. يضغط "Proceed to Pay"
4. System:
   a. يعرض loading indicator
   b. ينتظر 2-3 ثواني (simulation)
   c. يعرض success message
   
5. System Actions:
   a. Event Status → "confirmed"
   b. Payment Status → "completed"
   c. يحفظ Event في Firestore: events/
   
   d. لكل Package مختار:
      - ينشئ vendor_order document
      - يضيف notification للـ vendor
      - يرسل push notification (لو متاح)
   
   e. يعرض confirmation screen

Step 8: Confirmation

UI:
┌────────────────────────────────────────────┐
│ ✅ Booking Confirmed!                      │
├────────────────────────────────────────────┤
│                                            │
│ Your event has been successfully booked!   │
│                                            │
│ Event ID: #EVT67890                        │
│ Payment ID: #TXN_ABC123XYZ                 │
│                                            │
│ What happens next?                         │
│ 1. Vendors will be notified                │
│ 2. They will review your booking           │
│ 3. You'll receive confirmation emails      │
│                                            │
│ [View Event Details] [Go to Dashboard]     │
└────────────────────────────────────────────┘

📍 Part 3: Vendor Receives Notification

Notification System:

1. Real-time Notification (Push):
   - لما Event Owner يختار package
   - Vendor يستلم notification فوراً
   - يظهر في Notification Bell 🔔

2. Vendor Dashboard:
   - يدخل على "My Orders" أو "Bookings"
   - يشوف الـ pending orders
   
   UI:
   ┌────────────────────────────────────────┐
   │ 📦 New Booking Requests                │
   ├────────────────────────────────────────┤
   │                                        │
   │ ┌────────────────────────────────────┐│
   │ │ Sarah & Ahmed Wedding              ││
   │ │ Event Date: Dec 15, 2025           ││
   │ │                                    ││
   │ │ Package: Premium Wedding Hall      ││
   │ │ Price: 50,000 EGP                  ││
   │ │                                    ││
   │ │ Customer: Ahmed Mohamed            ││
   │ │ Phone: +201234567890               ││
   │ │ Guests: 350                        ││
   │ │                                    ││
   │ │ Status: ⏳ Pending Your Response   ││
   │ │                                    ││
   │ │ [View Details] [Accept] [Reject]   ││
   │ └────────────────────────────────────┘│
   │                                        │
   └────────────────────────────────────────┘

3. Vendor Actions:
   a. Accept Booking:
      - orderStatus → "accepted"
      - يرسل notification للـ Event Owner
      
   b. Reject Booking:
      - orderStatus → "rejected"
      - يطلب reason (optional)
      - يرسل notification للـ Event Owner
      - Event Owner يقدر يختار package تاني

🎯 5. الخلاصة والنقاط المهمة:
✅ ما تم تغطيته:
✓ Services System - خدمات ثابتة مخزنة locally

✓ Packages - الـ Vendors ينزلوها ويربطوها بـ Services

✓ Event Creation Flow - من البداية للنهاية

✓ Budget Tracking - real-time مع warnings

✓ Required vs Optional Services - handling كامل

✓ Payment Mock - simulation للدفع

✓ Vendor Notifications - إشعارات للـ vendors

✓ Data Models - شاملة وكاملة

📝 اقتراحاتي الإضافية:
Service Request Feature:

لو Event Owner مش لاقي package مناسب

يقدر يعمل "Custom Request"

يوصل لكل الـ Vendors في الـ Service ده

الـ Vendors يقدموا عروض مخصصة

Favorites/Wishlist:

Event Owner يحفظ packages مهتم بيها

يراجعها قبل الحجز النهائي

Package Comparison:

مقارنة بين packages مختلفة

Side by side comparison

Reviews System:

بعد Event ينتهي

Event Owner يقيّم كل Package/Vendor

يكتب review

Calendar Integration:

Vendor يشوف الـ bookings على calendar

يمنع double booking

