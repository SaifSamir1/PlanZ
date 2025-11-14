# 🔧 PlanZ Project - Technical Deep Dive

## 1. Architecture & Design Patterns

### Clean Architecture Layers
```
Presentation (UI) → BLoC → Repository → Data (Firebase/Hive)
```

### Repository Pattern Benefits
- Abstraction of data sources
- Easy testing with mock repositories
- Centralized business logic
- Dependency injection

### BLoC State Management
- Predictable state transitions
- Separation of business logic from UI
- Easy debugging with state history
- Testable cubits

---

## 2. Core Data Models

### EventModel (Event Lifecycle)
- **Status**: draft → confirmed → completed/cancelled
- **Budget Tracking**: total, allocated, remaining
- **Vendor Approval**: tracks acceptance/rejection from each vendor
- **Payment**: pending → completed/failed
- **Invitations**: tracks attendee responses

### PackageRequestModel (24-Hour Request)
- **Status Flow**: pending → accepted/rejected/expired
- **Expiry**: Auto-expires after 24 hours
- **Notifications**: Tracks vendor and owner notifications
- **Response**: Vendor can provide response message

### PackageModel (Vendor Offerings)
- **Status**: pending → active/rejected/inactive
- **Keywords**: For search indexing
- **Portfolio**: Links to Google Drive samples
- **Stats**: View count, booking count, rating

---

## 3. Firestore Collections

### packageRequests Collection
```
Query: where('vendorId', isEqualTo: vendorId)
Sort: by requestedAt (descending)
Strategy: Query without orderBy, sort in memory (no index needed)
```

### packages Collection
```
Query: where('serviceId', isEqualTo: serviceId)
       .where('isActive', isEqualTo: true)
       .where('price', <=, budget + 20%)
Sort: by rating, then by price
```

### events Collection
```
Query: where('eventOwnerId', isEqualTo: eventOwnerId)
       .where('status', isEqualTo: status)
Sort: by createdAt (descending)
```

---

## 4. State Management States

### VendorCubit States
- **Loading**: GetVendorRequestsLoading
- **Success**: GetVendorRequestsSuccess(requests)
- **Error**: GetVendorRequestsError(message)
- **Accept/Reject**: AcceptRequestLoading → Success/Error
- **Balance**: GetVendorBalanceSuccess(balance)

### EventCreationCubit States
- **Step Progress**: EventTypeSelected → BasicInfoEntered → ... → EventCreated
- **Payment**: PaymentProcessing → PaymentSuccess/Error
- **Validation**: Validates at each step

---

## 5. Error Handling

### Failure Types
- **ServerFailure**: Firebase/network errors
- **CacheFailure**: Local storage errors
- **ValidationFailure**: Input validation errors

### Error Flow
```
Repository catches exception
    ↓
Returns Left(Failure)
    ↓
Cubit receives failure
    ↓
Emits ErrorState with message
    ↓
UI displays error widget
```

---

## 6. Debugging Strategy

### Log Prefixes
- 📱 UI events
- 🔍 Queries
- 📊 Data aggregation
- ✅ Success
- ❌ Errors
- 💾 Database ops
- 📦 Packages
- 🔄 State changes

### Example Logs
```
📱 [VendorHomeScreen._loadData] Starting...
🔍 [getVendorRequests] Searching for vendorId: vendor_123
📊 [getVendorRequests] Found 5 requests
✅ [getVendorRequests] Returning 5 requests
```

---

## 7. Key Implementation Files

### Authentication
- `lib/features/auth/data/models/user_model.dart`
- `lib/features/auth/data/models/user_manager.dart`
- `lib/features/auth/logic/auth_cubit/auth_cubit.dart`

### Event Management
- `lib/features/event_owners/create_event_screen/data/models/event_model.dart`
- `lib/features/event_owners/create_event_screen/data/repo/event_owner_repo_impl.dart`
- `lib/features/event_owners/create_event_screen/cubits/event_creation_cubit/event_creation_cubit.dart`

### Vendor Features
- `lib/features/vendor_features/packages_mangment/data/models/package_model.dart`
- `lib/features/vendor_features/packages_mangment/data/models/package_request_model.dart`
- `lib/features/vendor_features/packages_mangment/data/repos/vendor_repository_impl.dart`
- `lib/features/vendor_features/packages_mangment/cubit/vendor_cubit.dart`
- `lib/features/vendor_features/vendor_home/ui/screens/vendor_home_screen.dart`

---

## 8. Current Development Status

### ✅ Completed
- User authentication (Firebase Auth)
- Event creation (8-step flow)
- Package management (CRUD)
- Package requests (creation & display)
- Vendor Dashboard (requests display)
- Budget tracking
- BLoC state management
- Firestore integration

### 🚀 Next Priority (Phase 1)
- Accept/Reject functionality
- Request details screen
- Notifications system
- Messaging system
- Status tracking

---

## 9. Testing Checklist

### Event Creation Flow
- [ ] Select event type
- [ ] Enter basic info
- [ ] Set budget
- [ ] Select services
- [ ] Browse packages
- [ ] Review summary
- [ ] Process payment
- [ ] Confirm event

### Package Request Flow
- [ ] Create request
- [ ] Verify in Firestore
- [ ] Display in vendor dashboard
- [ ] Accept request
- [ ] Reject request
- [ ] Verify status update
- [ ] Check notifications

### Vendor Dashboard
- [ ] Load requests
- [ ] Display request list
- [ ] Show request details
- [ ] Accept/reject buttons
- [ ] Update status
- [ ] Refresh data

---

## 10. Performance Considerations

### Firestore Optimization
- No composite indexes needed (sort in memory)
- Pagination for large lists
- Caching with Hive
- Lazy loading of images

### Memory Management
- Dispose controllers
- Clear cached data
- Limit list sizes
- Use const constructors

### Network Optimization
- Batch requests
- Cache responses
- Compress data
- Minimize payload size

---

## 11. Security Considerations

### Firestore Security Rules
- Vendor can only see own requests
- Event Owner can only see own events
- Admin can see all data
- Validate user type before operations

### Authentication
- Firebase Auth for user management
- FCM tokens for push notifications
- User type validation
- Session management

### Data Validation
- Validate input on client
- Validate on server (Firestore rules)
- Sanitize user input
- Check permissions before operations

---

## 12. Scalability Considerations

### Database Scaling
- Partition by vendorId for requests
- Partition by eventOwnerId for events
- Archive old data
- Use subcollections for related data

### Code Scaling
- Modular feature structure
- Reusable widgets
- Service layer for common operations
- Constants for configuration

### Performance Scaling
- Pagination for lists
- Lazy loading
- Caching strategy
- Background jobs for cleanup

---

## 13. Future Enhancements

### Phase 2: Accept/Reject
- Implement accept/reject methods
- Add confirmation dialogs
- Send notifications
- Update event status

### Phase 3: Messaging
- Real-time chat
- Message history
- Typing indicators
- Read receipts

### Phase 4: Notifications
- Push notifications (FCM)
- In-app notifications
- Email notifications
- SMS notifications

### Phase 5: Analytics
- Vendor statistics
- Event analytics
- User behavior tracking
- Revenue reports

### Phase 6: Advanced Features
- Reviews and ratings
- Favorites/wishlist
- Package comparison
- Advanced search
- Recommendations

---

## 14. Deployment Checklist

### Pre-Deployment
- [ ] All tests passing
- [ ] No console errors
- [ ] Performance optimized
- [ ] Security rules configured
- [ ] Firebase configured
- [ ] Error handling complete

### Deployment
- [ ] Build APK/IPA
- [ ] Test on real device
- [ ] Deploy to Firebase Hosting
- [ ] Update app version
- [ ] Release notes prepared

### Post-Deployment
- [ ] Monitor crashes
- [ ] Check analytics
- [ ] Monitor performance
- [ ] User feedback
- [ ] Bug fixes

---

## 15. Documentation References

- **README.md**: Project overview and features
- **NEXT_STEPS.md**: Development roadmap
- **DEBUGGING_GUIDE.md**: Debugging procedures
- **CHANGES_SUMMARY.md**: Recent changes
- **PROJECT_STUDY_GUIDE.md**: Complete study guide
- **TECHNICAL_DEEP_DIVE.md**: This file

---

**Last Updated**: November 13, 2025
**Status**: Active Development - Phase 1 Complete, Phase 2 Ready
