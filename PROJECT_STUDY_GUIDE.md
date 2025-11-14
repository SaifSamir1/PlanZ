# 📚 PlanZ Project - Complete Study Guide

## 🎯 Project Purpose
**PlanZ** is a comprehensive event planning platform that bridges Event Owners with Vendors. Event Owners create events and select vendor packages, while Vendors manage their packages and respond to booking requests.

---

## 📊 System Architecture Overview

### High-Level Flow
```
Event Owner                    System                    Vendor
    |                            |                         |
    |-- Creates Event ---------> |                         |
    |                            |-- Saves Event          |
    |                            |                         |
    |-- Browses Packages ------> |                         |
    |                            |-- Queries Packages     |
    |                            |                         |
    |-- Selects Package -------> |-- Creates Request ---> |
    |                            |                         |
    |                            |<-- Notification -------|
    |                            |                         |
    |                            |<-- Accept/Reject ------|
    |<-- Notification ---------- |                         |
    |                            |                         |
```

### Technology Stack
| Component | Technology |
|-----------|-----------|
| **Frontend** | Flutter (Dart) |
| **State Management** | BLoC (flutter_bloc) |
| **Backend** | Firebase (Firestore, Authentication) |
| **Local Storage** | Hive (NoSQL) |
| **Localization** | Intl (Arabic support) |
| **Architecture** | Clean Architecture + Repository Pattern |

---

## 📁 Project Structure Deep Dive

### Core Directory (`lib/core/`)
```
core/
├── constants/
│   └── constants.dart          # Firebase collection names, constants
├── error/
│   └── failures.dart           # Error handling (ServerFailure, etc.)
├── services/
│   └── [Services]              # Firebase services, API calls
├── theming/
│   └── text_styles.dart        # Typography, colors
├── utils/
│   └── app_colors.dart         # Color palette
└── widgets/
    └── custom_app_bar.dart     # Reusable widgets
```

### Features Directory (`lib/features/`)

#### 1. Authentication (`auth/`)
```
auth/
├── data/
│   ├── auth_repo/
│   │   └── auth_repo_impl.dart     # Firebase Auth implementation
│   └── models/
│       ├── user_model.dart         # User data structure
│       └── user_manager.dart       # Hive-based user storage
├── logic/
│   └── auth_cubit/
│       └── auth_cubit.dart         # Authentication state management
└── ui/
    └── [Login/Signup screens]
```

**UserModel Structure:**
```dart
UserModel {
  id: String,
  name: String,
  email: String,
  userType: UserType (vendor|eventOwner|attendee|admin),
  phoneNumber: String?,
  fcmToken: String?,           // For push notifications
  fcmTokens: List<String>?,    // Multiple devices
  createdAt: DateTime,
  updatedAt: DateTime
}
```

#### 2. Event Owners (`event_owners/`)
```
event_owners/
├── create_event_screen/
│   ├── data/
│   │   ├── models/
│   │   │   ├── event_model.dart              # Core event data
│   │   │   ├── event_model_enum.dart         # EventStatus, PaymentStatus
│   │   │   └── event_invitation_model.dart   # Attendee invitations
│   │   └── repo/
│   │       ├── event_owner_repo.dart         # Abstract interface
│   │       └── event_owner_repo_impl.dart    # Firebase implementation
│   ├── cubits/
│   │   ├── create_event_cubit/
│   │   └── event_creation_cubit/
│   └── ui/
│       └── [8-step event creation screens]
├── event_owner_home/
│   └── [Dashboard screens]
├── chat_bot/
│   └── [AI assistant screens]
├── payment/
│   └── [Payment processing]
└── user_info/
    └── [Profile management]
```

**EventModel Structure (CRITICAL):**
```dart
EventModel {
  // Identifiers
  eventId: String,
  eventOwnerId: String,
  eventOwnerName: String,
  eventOwnerEmail: String,
  
  // Event Details
  eventTypeId: String,
  eventTypeName: String,
  eventName: String,
  eventDate: DateTime,
  location: String,
  city: String?,
  
  // Budget Tracking
  totalBudget: double,
  allocatedBudget: double,
  remainingBudget: double,
  
  // Services & Packages
  services: List<EventService>,  // Selected packages
  
  // Vendor Approval Status
  allVendorsApproved: bool,
  totalVendorsCount: int,
  approvedVendorsCount: int,
  rejectedVendorsCount: int,
  pendingVendorsCount: int,
  
  // Payment
  paymentStatus: PaymentStatus (pending|completed|failed),
  totalAmount: double,
  paidAmount: double,
  
  // Status
  status: EventStatus (draft|confirmed|completed|cancelled),
  createdAt: DateTime,
  updatedAt: DateTime
}
```

**EventService Structure:**
```dart
EventService {
  serviceId: String,
  serviceName: String,
  isRequired: bool,
  packageId: String,
  packageName: String,
  vendorId: String,
  vendorName: String,
  packagePrice: double,
  vendorApproved: bool,
  requestId: String
}
```

#### 3. Vendor Features (`vendor_features/`)
```
vendor_features/
├── packages_mangment/
│   ├── data/
│   │   ├── models/
│   │   │   ├── package_model.dart              # Vendor's packages
│   │   │   ├── package_request_model.dart      # Requests from Event Owners
│   │   │   └── withdrawal_request_model.dart   # Payment withdrawals
│   │   └── repos/
│   │       ├── i_vendor_repository.dart        # Abstract interface
│   │       └── vendor_repository_impl.dart     # Firebase implementation
│   ├── cubit/
│   │   ├── vendor_cubit.dart                   # State management
│   │   └── vendor_state.dart                   # BLoC states
│   └── ui/
│       └── [Package management screens]
└── vendor_home/
    ├── ui/
    │   └── screens/
    │       ├── vendor_home_screen.dart         # Main dashboard
    │       ├── vendor_earnings_screen.dart     # Earnings/balance
    │       └── request_details_screen.dart     # Request details
    └── [Dashboard components]
```

**PackageModel Structure:**
```dart
PackageModel {
  // Identifiers
  packageId: String,
  vendorId: String,
  vendorName: String,
  serviceId: String,
  serviceName: String,
  
  // Details
  packageName: String,
  description: String,
  
  // Pricing
  price: double,
  currency: String (default: 'EGP'),
  priceUnit: String (per_event|per_person|per_hour|per_day),
  
  // Content
  features: List<String>,
  keywords: List<String>,        // For search
  portfolioLinks: List<PortfolioItem>,
  
  // Status
  status: PackageStatus (pending|active|rejected|inactive),
  isActive: bool,
  isApprovedByOwner: bool,
  
  // Stats
  viewCount: int,
  bookingCount: int,
  rating: double?,
  reviewCount: int?,
  
  createdAt: DateTime,
  updatedAt: DateTime
}
```

**PackageRequestModel Structure (CRITICAL):**
```dart
PackageRequestModel {
  // Identifiers
  requestId: String,
  eventOwnerId: String,
  vendorId: String,
  packageId: String,
  eventId: String,
  
  // Event Owner Info
  eventOwnerName: String,
  eventOwnerEmail: String,
  eventOwnerPhone: String?,
  
  // Vendor Info
  vendorName: String,
  
  // Package Info
  packageName: String,
  packagePrice: double?,
  
  // Event Info
  eventName: String,
  eventType: String,
  eventDate: DateTime,
  eventLocation: String?,
  guestCount: int?,
  
  // Status & Response
  status: RequestStatus (pending|accepted|rejected|expired|cancelled),
  isAccepted: bool,
  isExpired: bool,
  vendorResponse: String?,
  rejectionReason: String?,
  
  // Timing (24-hour expiry)
  requestedAt: DateTime,
  expiresAt: DateTime,           // 24 hours from requestedAt
  respondedAt: DateTime?,
  
  // Notifications
  vendorNotified: bool,
  ownerNotifiedOfResponse: bool,
  
  createdAt: DateTime,
  updatedAt: DateTime
}
```

---

## 🔄 Data Flow & Workflows

### Workflow 1: Event Creation (8 Steps)

**Step 1: Select Event Type**
- Display 6 event types in grid
- Load configuration from local JSON
- Save to state

**Step 2: Basic Event Information**
- Input: Event name, date, time, city, area, guest count
- Validation: Required fields
- Save to state

**Step 3: Budget Setup**
- Input: Total budget
- Auto-allocate to services (percentages)
- Display breakdown with edit capability
- Save to state

**Step 4: Services Selection**
- Display required vs optional services
- User can toggle optional services
- Auto-redistribute budget
- Save to state

**Step 5: Browse & Select Packages**
- For each service, show available packages
- Filter by price (budget + 20% margin)
- Display package details (price, capacity, duration, features)
- User selects package → Creates PackageRequest
- Check for over-budget warnings
- Auto-navigate to next service

**Step 6: Review & Summary**
- Display all selected packages
- Show budget summary
- Display warnings for over-budget items
- Allow editing or proceeding

**Step 7: Payment (Mock)**
- Select payment method
- Enter card details (mock)
- Process payment (2-3 second simulation)

**Step 8: Confirmation**
- Display confirmation message
- Show event ID and payment ID
- Notify vendors
- Create vendor_order documents

### Workflow 2: Package Request Lifecycle

```
Event Owner selects package
    ↓
addPackageToEvent() called
    ↓
PackageRequest created with status=pending
    ↓
Saved to Firestore: packageRequests/{requestId}
    ↓
Vendor receives notification
    ↓
Vendor Dashboard shows request
    ↓
Vendor accepts/rejects
    ↓
Status updated: pending → accepted/rejected
    ↓
Event Owner receives notification
    ↓
Event Owner sees response
```

---

## 🗄️ Firestore Collections Structure

### Collection: `packages`
```
packages/{packageId}
├── packageId: String
├── vendorId: String
├── vendorName: String
├── serviceId: String
├── serviceName: String
├── packageName: String
├── description: String
├── price: Number
├── currency: String
├── priceUnit: String
├── features: Array<String>
├── keywords: Array<String>
├── portfolioLinks: Array<Object>
├── status: String (pending|active|rejected|inactive)
├── isActive: Boolean
├── isApprovedByOwner: Boolean
├── viewCount: Number
├── bookingCount: Number
├── rating: Number
├── reviewCount: Number
├── createdAt: Timestamp
└── updatedAt: Timestamp
```

### Collection: `packageRequests`
```
packageRequests/{requestId}
├── requestId: String
├── eventOwnerId: String
├── eventOwnerName: String
├── eventOwnerEmail: String
├── eventOwnerPhone: String
├── vendorId: String
├── vendorName: String
├── packageId: String
├── packageName: String
├── packagePrice: Number
├── serviceId: String
├── serviceName: String
├── eventId: String
├── eventName: String
├── eventType: String
├── eventDate: Timestamp
├── eventLocation: String
├── guestCount: Number
├── message: String
├── customRequirements: Object
├── status: String (pending|accepted|rejected|expired|cancelled)
├── isAccepted: Boolean
├── isExpired: Boolean
├── vendorResponse: String
├── rejectionReason: String
├── requestedAt: Timestamp
├── expiresAt: Timestamp
├── respondedAt: Timestamp
├── vendorNotified: Boolean
├── ownerNotifiedOfResponse: Boolean
├── createdAt: Timestamp
└── updatedAt: Timestamp
```

### Collection: `events`
```
events/{eventId}
├── eventId: String
├── eventOwnerId: String
├── eventOwnerName: String
├── eventOwnerEmail: String
├── eventTypeId: String
├── eventTypeName: String
├── eventName: String
├── eventDate: Timestamp
├── location: String
├── city: String
├── totalBudget: Number
├── allocatedBudget: Number
├── remainingBudget: Number
├── expectedGuestCount: Number
├── services: Array<Object>  // EventService objects
├── allVendorsApproved: Boolean
├── totalVendorsCount: Number
├── approvedVendorsCount: Number
├── rejectedVendorsCount: Number
├── pendingVendorsCount: Number
├── paymentStatus: String (pending|completed|failed)
├── totalAmount: Number
├── paidAmount: Number
├── status: String (draft|confirmed|completed|cancelled)
├── createdAt: Timestamp
└── updatedAt: Timestamp
```

---

## 🎮 State Management (BLoC)

### VendorCubit States
```dart
// Initial
VendorInitial

// Package Management
CreatePackageLoading → CreatePackageSuccess | CreatePackageError
UpdatePackageLoading → UpdatePackageSuccess | UpdatePackageError
DeletePackageLoading → DeletePackageSuccess | DeletePackageError
GetVendorPackagesLoading → GetVendorPackagesSuccess | GetVendorPackagesError

// Package Requests
GetVendorRequestsLoading → GetVendorRequestsSuccess | GetVendorRequestsError
GetPendingRequestsLoading → GetPendingRequestsSuccess | GetPendingRequestsError
AcceptRequestLoading → AcceptRequestSuccess | AcceptRequestError
RejectRequestLoading → RejectRequestSuccess | RejectRequestError

// Statistics
GetVendorStatsLoading → GetVendorStatsSuccess | GetVendorStatsError
GetVendorBalanceLoading → GetVendorBalanceSuccess | GetVendorBalanceError
```

### EventCreationCubit States
```dart
// Event creation flow states
EventCreationInitial
EventTypeSelected
BasicInfoEntered
BudgetSetup
ServicesSelected
PackagesSelected
ReviewReady
PaymentProcessing → PaymentSuccess | PaymentError
EventCreated
```

---

## 🔑 Key Implementation Details

### 1. Repository Pattern
- **Abstract Interface**: Defines contract (e.g., `VendorRepository`)
- **Implementation**: Concrete class with Firebase logic (e.g., `VendorRepositoryImpl`)
- **Dependency Injection**: Passed to Cubits via constructor

### 2. Error Handling (Dartz)
```dart
// Using Either<Failure, Success>
Future<Either<Failure, List<PackageModel>>> getVendorPackages(String vendorId)

// Usage
result.fold(
  (failure) => emit(GetVendorPackagesError(failure.message)),
  (packages) => emit(GetVendorPackagesSuccess(packages)),
);
```

### 3. Debugging Strategy
- **Emojis**: 📱, 🔍, 📊, ✅, ❌, 💾, 📦, 🔄, etc.
- **Prefix Format**: `[ClassName.methodName]`
- **Example**: `debugPrint('🔍 [getVendorRequests] Searching for vendorId: $vendorId');`

### 4. Firestore Queries (No Index Required)
```dart
// Get vendor requests - manual sorting in memory
final querySnapshot = await _firestore
    .collection('packageRequests')
    .where('vendorId', isEqualTo: vendorId)
    .get();  // ✅ No .orderBy() to avoid index requirement

// Sort in memory
final requests = querySnapshot.docs
    .map((doc) => PackageRequestModel.fromJson(doc.data()))
    .toList()
  ..sort((a, b) => b.requestedAt.compareTo(a.requestedAt));
```

### 5. Local Storage (Hive)
```dart
// In main.dart
await Hive.initFlutter();
await UserManager().init();  // Loads user from Hive

// UserManager stores:
- userId
- userName
- userEmail
- userType
- userPhone
```

---

## 📋 Current Development Status

### ✅ Completed Features
- User authentication (Firebase Auth)
- Event creation (8-step flow)
- Package management (Vendor CRUD)
- Package browsing (Event Owner)
- Package requests (creation & display)
- Vendor Dashboard (requests display)
- Budget tracking & allocation
- Firestore integration
- BLoC state management
- Debugging infrastructure

### 🚀 Next Priority (From NEXT_STEPS.md)

**Phase 1: Accept/Reject Functionality (HIGH)**
- [ ] Implement `acceptRequest()` in VendorRepository
- [ ] Implement `rejectRequest()` in VendorRepository
- [ ] Add states to VendorCubit
- [ ] Add UI buttons for accept/reject
- [ ] Handle loading states
- [ ] Send notifications to Event Owner

**Phase 2: Request Details Screen (HIGH)**
- [ ] Create `RequestDetailsScreen`
- [ ] Display full request details
- [ ] Show accept/reject buttons
- [ ] Add messaging field

**Phase 3: Notifications (MEDIUM)**
- [ ] Implement push notifications (FCM)
- [ ] Show notification badge
- [ ] Track notification status

**Phase 4: Messaging System (MEDIUM)**
- [ ] Create chat screen
- [ ] Send/receive messages
- [ ] Message history

**Phase 5: Request Status Tracking (MEDIUM)**
- [ ] Display request timeline
- [ ] Show expiration countdown
- [ ] Track status changes

**Phase 6: Analytics & Reports (LOW)**
- [ ] Vendor statistics dashboard
- [ ] Response rate tracking
- [ ] Earnings reports

---

## 🛠️ Important Methods & Functions

### VendorRepository Methods
```dart
// Package Management
createPackage()
updatePackage()
deletePackage()
togglePackageStatus()
getVendorPackages()
getPackageById()
getPackagesByService()
searchPackages()

// Package Requests
getVendorRequests()
getPendingRequests()
getRequestById()
acceptRequest()          // ← TO IMPLEMENT
rejectRequest()          // ← TO IMPLEMENT
markExpiredRequests()

// Statistics
getVendorStats()
getVendorBalance()
incrementPackageViews()
incrementPackageBookings()

// Withdrawals
requestWithdrawal()
getWithdrawalRequests()
getPendingWithdrawals()
getWithdrawalById()
getTransactionHistory()
```

### EventOwnerRepository Methods
```dart
// Event Management
createEvent()
updateEvent()
deleteEvent()
getEventById()
getEventOwnerEvents()
getEventsByStatus()

// Package Browsing
getPackagesByService()
getPackageDetails()
searchPackages()

// Package Selection
addPackageToEvent()      // ← Creates PackageRequest
removePackageFromEvent()
replacePackage()
updateVendorApprovalStatus()
getEventPackageRequests()

// Invitations
sendInvitation()
sendBulkInvitations()
getEventInvitations()
getInvitationsByStatus()

// Payment
updatePaymentStatus()
calculateTotalEventCost()

// Statistics
getEventStats()
getEventOwnerStats()
```

---

## 📝 Code Examples

### Creating a Package Request
```dart
// In EventOwnerRepositoryImpl.addPackageToEvent()
final requestId = _uuid.v4();
final request = PackageRequestModel(
  requestId: requestId,
  eventOwnerId: eventOwnerId,
  vendorId: vendorId,
  packageId: packageId,
  eventId: eventId,
  status: RequestStatus.pending,
  requestedAt: DateTime.now(),
  expiresAt: DateTime.now().add(Duration(hours: 24)),
  // ... other fields
);

await _firestore
    .collection(FirebaseCollections.packageRequests)
    .doc(requestId)
    .set(request.toJson());
```

### Querying Vendor Requests
```dart
// In VendorRepositoryImpl.getVendorRequests()
final querySnapshot = await _firestore
    .collection(FirebaseCollections.packageRequests)
    .where('vendorId', isEqualTo: vendorId)
    .get();

final requests = querySnapshot.docs
    .map((doc) => PackageRequestModel.fromJson(doc.data()))
    .toList()
  ..sort((a, b) => b.requestedAt.compareTo(a.requestedAt));

return Right(requests);
```

### Displaying Requests in UI
```dart
// In VendorHomeScreen._buildRequestsList()
BlocBuilder<VendorCubit, VendorState>(
  builder: (context, state) {
    if (state is GetVendorRequestsSuccess) {
      return ListView.builder(
        itemCount: state.requests.length,
        itemBuilder: (context, index) {
          final request = state.requests[index];
          return RequestCard(request: request);
        },
      );
    }
    return SizedBox();
  },
);
```

---

## 🎓 Learning Path

1. **Start with**: `main.dart` - Understand app initialization
2. **Then study**: `event_model.dart` - Core data structure
3. **Next**: `package_request_model.dart` - Request lifecycle
4. **Then**: `vendor_repository_impl.dart` - Backend logic
5. **Finally**: `vendor_home_screen.dart` - UI implementation

---

## 🔗 File Cross-References

| Concept | Files |
|---------|-------|
| **Event Creation** | `event_model.dart`, `event_owner_repo_impl.dart`, `create_event_cubit.dart` |
| **Package Management** | `package_model.dart`, `vendor_repository_impl.dart`, `vendor_cubit.dart` |
| **Package Requests** | `package_request_model.dart`, `vendor_repository_impl.dart`, `vendor_home_screen.dart` |
| **Authentication** | `user_model.dart`, `auth_repo_impl.dart`, `auth_cubit.dart` |
| **State Management** | `vendor_cubit.dart`, `vendor_state.dart`, `event_creation_cubit.dart` |
| **Firestore Integration** | `*_repository_impl.dart` files |
| **UI Components** | `*_screen.dart` files in `ui/screens/` |

---

## 🚀 Next Steps for Development

1. **Implement Accept/Reject Functionality**
   - Add methods to `VendorRepository`
   - Add states to `VendorCubit`
   - Update `vendor_home_screen.dart` UI

2. **Create Request Details Screen**
   - New screen to show full request details
   - Add navigation from request list

3. **Implement Notifications**
   - Use FCM tokens from UserModel
   - Send notifications on status changes

4. **Add Messaging System**
   - Create chat collection in Firestore
   - Implement real-time messaging

5. **Testing & Debugging**
   - Use existing debug logs
   - Test all workflows end-to-end
   - Verify Firestore data

---

**Last Updated**: Study completed on Nov 13, 2025
**Project Status**: Active Development - Phase 1 (Accept/Reject) Ready to Implement
