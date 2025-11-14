// lib/features/event_owner/data/repositories/event_owner_repo_impl.dart

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:plan_z/core/constants/constants.dart';
import 'package:plan_z/core/error/failures.dart';
import 'package:plan_z/core/services/notification_service.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_invitation_model.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_model.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_model_enum.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/repo/event_owner_repo.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_model.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_request_model.dart';

import 'package:uuid/uuid.dart';

class EventOwnerRepositoryImpl implements EventOwnerRepository {
  final FirebaseFirestore _firestore;
  final Uuid _uuid;

  EventOwnerRepositoryImpl({FirebaseFirestore? firestore, Uuid? uuid})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _uuid = uuid ?? const Uuid();

  // ===== Event Management =====

  @override
  Future<Either<Failure, EventModel>> createEvent({
    required String eventOwnerId,
    required String eventOwnerName,
    required String eventOwnerEmail,
    String? eventOwnerPhone,
    required String eventTypeId,
    required String eventTypeName,
    required String eventName,
    String? description,
    required DateTime eventDate,
    required String location,
    String? city,
    String? address,
    Map<String, dynamic>? coordinates,
    required double totalBudget,
    required int expectedGuestCount,
    Map<String, dynamic>? customRequirements,
  }) async {
    try {
      final eventId = _uuid.v4();

      // ✅ FIX: Convert selectedPackagesData to EventService objects
      List<EventService> services = [];
      double allocatedBudget = 0.0;
      int totalVendorsCount = 0;

      debugPrint('🔍 [createEvent] customRequirements keys: ${customRequirements?.keys.toList()}');
      debugPrint('🔍 [createEvent] customRequirements is null: ${customRequirements == null}');
      debugPrint('🔍 [createEvent] selectedPackagesData exists: ${customRequirements?['selectedPackagesData'] != null}');
      debugPrint('🔍 [createEvent] selectedPackagesData type: ${customRequirements?['selectedPackagesData'].runtimeType}');
      debugPrint('🔍 [createEvent] selectedPackagesData: ${customRequirements?['selectedPackagesData']}');

      if (customRequirements != null && 
          customRequirements['selectedPackagesData'] != null) {
        final packagesData = customRequirements['selectedPackagesData'] as List;
        debugPrint('✅ [createEvent] Found ${packagesData.length} packages to convert');
        
        for (var packageData in packagesData) {
          final service = EventService(
            serviceId: packageData['serviceId'] ?? '',
            serviceName: packageData['serviceName'] ?? 
                _getServiceNameFromSelectedServices(
                  customRequirements['selectedServices'],
                  packageData['serviceId'],
                ) ?? '',
            serviceNameAr: packageData['serviceNameAr'],
            isRequired: packageData['isRequired'] ?? true,
            packageId: packageData['packageId'] ?? '',
            packageName: packageData['packageName'] ?? '',
            vendorId: packageData['vendorId'] ?? '',
            vendorName: packageData['vendorName'] ?? '',
            packagePrice: (packageData['price'] as num?)?.toDouble() ?? 0.0,
            vendorApproved: false,
            requestId: _uuid.v4(), // Generate requestId for package request
          );
          
          debugPrint('  ✅ Created EventService: ${service.serviceName} -> ${service.packageName} (${service.packagePrice})');
          services.add(service);
          allocatedBudget += service.packagePrice;
          totalVendorsCount++;
        }
      } else {
        debugPrint('❌ [createEvent] No selectedPackagesData found in customRequirements');
      }

      debugPrint('📊 [createEvent] Final services count: ${services.length}, allocatedBudget: $allocatedBudget');
      final remainingBudget = totalBudget - allocatedBudget;

      final event = EventModel(
        eventId: eventId,
        eventOwnerId: eventOwnerId,
        eventOwnerName: eventOwnerName,
        eventOwnerEmail: eventOwnerEmail,
        eventOwnerPhone: eventOwnerPhone,
        eventTypeId: eventTypeId,
        eventTypeName: eventTypeName,
        eventName: eventName,
        description: description,
        eventDate: eventDate,
        location: location,
        city: city,
        address: address,
        coordinates: coordinates,
        totalBudget: totalBudget,
        allocatedBudget: allocatedBudget,
        remainingBudget: remainingBudget,
        expectedGuestCount: expectedGuestCount,
        services: services, // ✅ Now populated with EventService objects
        customRequirements: customRequirements,
        status: services.isNotEmpty ? EventStatus.pending : EventStatus.draft,
        totalAmount: allocatedBudget,
        remainingAmount: allocatedBudget,
        totalVendorsCount: totalVendorsCount,
        pendingVendorsCount: totalVendorsCount,
      );

      await _firestore
          
          .collection(FirebaseCollections.events)
          .doc(eventId)
          .set(event.toJson());

      // ✅ Create PackageRequestModel for each service
      debugPrint('📦 [createEvent] Creating PackageRequests for ${services.length} services...');
      debugPrint('   Location: $location, City: $city, Address: $address');
      debugPrint('   EventDate: $eventDate, Phone: $eventOwnerPhone, Price: ${services.isNotEmpty ? services.first.packagePrice : 'N/A'}');
      
      for (var service in services) {
        final requestId = service.requestId;
        debugPrint('   📤 Creating request: $requestId for ${service.packageName}');
        
        final packageRequest = PackageRequestModel(
          packagePrice: service.packagePrice,
          requestId: requestId,
          eventOwnerId: eventOwnerId,
          eventOwnerName: eventOwnerName,
          eventOwnerEmail: eventOwnerEmail,
          eventOwnerPhone: eventOwnerPhone ?? 'N/A',
          vendorId: service.vendorId,
          vendorName: service.vendorName,
          packageId: service.packageId,
          packageName: service.packageName,
          serviceId: service.serviceId,
          serviceName: service.serviceName,
          eventId: eventId,
          eventName: eventName,
          eventType: eventTypeName,
          eventDate: eventDate,
          eventLocation: (location.isNotEmpty) ? location : 'N/A',
          guestCount: expectedGuestCount,
          // ✅ إضافة بيانات إضافية
          message: 'Event Details: $eventName on ${eventDate.toString()}',
          customRequirements: {
            'city': (city?.isNotEmpty ?? false) ? city : 'N/A',
            'address': (address?.isNotEmpty ?? false) ? address : 'N/A',
            'description': (description?.isNotEmpty ?? false) ? description : 'No description',
            'eventTypeId': eventTypeId,
            'totalBudget': totalBudget,
            'expectedGuestCount': expectedGuestCount,
            'packagePrice': service.packagePrice,
          },
        );

        await _firestore
            .collection(FirebaseCollections.packageRequests)
            .doc(requestId)
            .set(packageRequest.toJson());
        
        debugPrint('   ✅ Request saved: $requestId');
        debugPrint('      - Location: $location, City: $city, Address: $address');
        debugPrint('      - Phone: $eventOwnerPhone, Price: ${service.packagePrice}');
        debugPrint('      - EventDate: $eventDate');
      }
      debugPrint('✅ [createEvent] All PackageRequests created successfully!');

      return Right(event);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to create event'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// ✅ Helper: Get service name from selectedServices list
  String? _getServiceNameFromSelectedServices(
    dynamic selectedServices,
    String serviceId,
  ) {
    if (selectedServices is! List) return null;
    
    try {
      final service = selectedServices.firstWhere(
        (s) => s['serviceId'] == serviceId,
        orElse: () => null,
      );
      return service?['serviceName'];
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Either<Failure, EventModel>> updateEvent({
    required String eventId,
    String? eventName,
    String? description,
    DateTime? eventDate,
    String? location,
    String? city,
    String? address,
    Map<String, dynamic>? coordinates,
    double? totalBudget,
    int? expectedGuestCount,
    EventStatus? status,
  }) async {
    try {
      final docRef = _firestore
          .collection(FirebaseCollections.events)
          .doc(eventId);

      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        return Left(ServerFailure('Event not found'));
      }

      final Map<String, dynamic> updates = {
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      };

      if (eventName != null) updates['eventName'] = eventName;
      if (description != null) updates['description'] = description;
      if (eventDate != null)
        updates['eventDate'] = Timestamp.fromDate(eventDate);
      if (location != null) updates['location'] = location;
      if (city != null) updates['city'] = city;
      if (address != null) updates['address'] = address;
      if (coordinates != null) updates['coordinates'] = coordinates;
      if (expectedGuestCount != null) {
        updates['expectedGuestCount'] = expectedGuestCount;
      }
      if (status != null) updates['status'] = status.name;

      if (totalBudget != null) {
        updates['totalBudget'] = totalBudget;
        // Recalculate remaining budget
        final currentEvent = EventModel.fromJson(
          docSnapshot.data() as Map<String, dynamic>,
        );
        updates['remainingBudget'] = totalBudget - currentEvent.allocatedBudget;
      }

      await docRef.update(updates);

      final updatedDoc = await docRef.get();
      final updatedEvent = EventModel.fromJson(
        updatedDoc.data() as Map<String, dynamic>,
      );

      return Right(updatedEvent);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to update event'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEvent(String eventId) async {
    try {
      // Delete event
      await _firestore
          .collection(FirebaseCollections.events)
          .doc(eventId)
          .delete();

      // Delete associated invitations
      final invitationsSnapshot = await _firestore
          .collection(FirebaseCollections.eventInvitations)
          .where('eventId', isEqualTo: eventId)
          .get();

      final batch = _firestore.batch();
      for (var doc in invitationsSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to delete event'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EventModel>> getEventById(String eventId) async {
    try {
      final docSnapshot = await _firestore
          .collection(FirebaseCollections.events)
          .doc(eventId)
          .get();

      if (!docSnapshot.exists) {
        return Left(ServerFailure('Event not found'));
      }

      final event = EventModel.fromJson(
        docSnapshot.data() as Map<String, dynamic>,
      );

      return Right(event);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to get event'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EventModel>>> getEventOwnerEvents(
    String eventOwnerId,
  ) async {
    try {
      debugPrint('');
      debugPrint('🔄 [EventOwnerRepoImpl.getEventOwnerEvents] Starting...');
      debugPrint('   Owner ID: $eventOwnerId');
      
      final querySnapshot = await _firestore
          .collection(FirebaseCollections.events)
          .where('eventOwnerId', isEqualTo: eventOwnerId)
          .get();

      debugPrint('   📊 Query returned ${querySnapshot.docs.length} documents');

      // ✅ Sort manually in memory after fetching
      final events =
          querySnapshot.docs
              .map((doc) {
                final data = doc.data();
                debugPrint('   📄 Doc ID: ${doc.id}');
                debugPrint('      Event: ${data['eventName']}');
                debugPrint('      Paid Amount: ${data['paidAmount']}');
                debugPrint('      Payment Status: ${data['paymentStatus']}');
                return EventModel.fromJson(data);
              })
              .toList()
            ..sort(
              (a, b) => b.createdAt.compareTo(a.createdAt),
            ); // ✅ Manual sorting

      debugPrint('✅ [EventOwnerRepoImpl.getEventOwnerEvents] Success!');
      debugPrint('   Total events after mapping: ${events.length}');
      return Right(events);
    } on FirebaseException catch (e) {
      debugPrint('❌ [EventOwnerRepoImpl.getEventOwnerEvents] Firebase Error: ${e.message}');
      return Left(ServerFailure(e.message ?? 'Failed to get events'));
    } catch (e) {
      debugPrint('❌ [EventOwnerRepoImpl.getEventOwnerEvents] Error: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EventModel>>> getEventsByStatus({
    required String eventOwnerId,
    required EventStatus status,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseCollections.events)
          .where('eventOwnerId', isEqualTo: eventOwnerId)
          .where('status', isEqualTo: status.name)
          // ❌ Removed: .orderBy('eventDate', descending: false)
          .get();

      // ✅ Sort manually in memory after fetching
      final events =
          querySnapshot.docs
              .map((doc) => EventModel.fromJson(doc.data()))
              .toList()
            ..sort(
              (a, b) => a.eventDate.compareTo(b.eventDate),
            ); // ✅ Manual sorting

      return Right(events);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to get events'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ===== Package Selection & Vendor Requests =====

  @override
  Future<Either<Failure, EventModel>> addPackageToEvent({
    required String eventId,
    required String serviceId,
    required String serviceName,
    String? serviceNameAr,
    required bool isRequired,
    required String packageId,
    required String packageName,
    required String vendorId,
    required String vendorName,
    required double packagePrice,
    String? message,
  }) async {
    try {
      // Get current event
      final eventResult = await getEventById(eventId);
      if (eventResult.isLeft()) {
        return Left(ServerFailure('Event not found'));
      }

      final event = eventResult.getOrElse(() => throw Exception());

      // Create package request
      final requestId = _uuid.v4();
      debugPrint('📦 [addPackageToEvent] Creating PackageRequest:');
      debugPrint('   requestId: $requestId');
      debugPrint('   vendorId: $vendorId');
      debugPrint('   vendorName: $vendorName');
      debugPrint('   packageId: $packageId');
      debugPrint('   packageName: $packageName');
      debugPrint('   eventId: $eventId');
      debugPrint('   eventOwnerId: ${event.eventOwnerId}');
      
      final packageRequest = PackageRequestModel(
        packagePrice: packagePrice,
        requestId: requestId,
        eventOwnerId: event.eventOwnerId,
        eventOwnerName: event.eventOwnerName,
        eventOwnerEmail: event.eventOwnerEmail,
        eventOwnerPhone: event.eventOwnerPhone,
        vendorId: vendorId,
        vendorName: vendorName,
        packageId: packageId,
        packageName: packageName,
        serviceId: serviceId,
        serviceName: serviceName,
        eventId: eventId,
        eventName: event.eventName,
        eventType: event.eventTypeName,
        eventDate: event.eventDate,
        eventLocation: event.location,
        guestCount: event.expectedGuestCount,
        message: message,
      );

      // Save package request
      debugPrint('💾 [addPackageToEvent] Saving to Firestore...');
      await _firestore
          .collection(FirebaseCollections.packageRequests)
          .doc(requestId)
          .set(packageRequest.toJson());
      debugPrint('✅ [addPackageToEvent] PackageRequest saved successfully!');

      // Create EventService
      final eventService = EventService(
        serviceId: serviceId,
        serviceName: serviceName,
        serviceNameAr: serviceNameAr,
        isRequired: isRequired,
        packageId: packageId,
        packageName: packageName,
        vendorId: vendorId,
        vendorName: vendorName,
        packagePrice: packagePrice,
        vendorApproved: false,
        requestId: requestId,
      );

      // Update event with new service
      final updatedServices = List<EventService>.from(event.services)
        ..add(eventService);

      final allocatedBudget = event.allocatedBudget + packagePrice;
      final remainingBudget = event.totalBudget - allocatedBudget;

      await _firestore
          .collection(FirebaseCollections.events)
          .doc(eventId)
          .update({
            'services': updatedServices.map((s) => s.toJson()).toList(),
            'allocatedBudget': allocatedBudget,
            'remainingBudget': remainingBudget,
            'totalAmount': allocatedBudget,
            'remainingAmount': allocatedBudget,
            'totalVendorsCount': updatedServices.length,
            'pendingVendorsCount': updatedServices
                .where((s) => !s.vendorApproved)
                .length,
            'status': EventStatus.pending.name,
            'updatedAt': Timestamp.fromDate(DateTime.now()),
          });

      final updatedEventResult = await getEventById(eventId);
      return updatedEventResult;
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to add package'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EventModel>> removePackageFromEvent({
    required String eventId,
    required String serviceId,
  }) async {
    try {
      // 1. Get Event
      final eventResult = await getEventById(eventId);
      if (eventResult.isLeft()) {
        return Left(ServerFailure('Event not found'));
      }

      final event = eventResult.getOrElse(() => throw Exception());

      // 2. Find the service to be removed
      final removedService = event.services.firstWhere(
        (s) => s.serviceId == serviceId,
        orElse: () => throw Exception('Service not found'),
      );

      // 3. Update Event: Remove service from list
      final updatedServices = event.services
          .where((s) => s.serviceId != serviceId)
          .toList();

      // 4. Recalculate Budget
      final allocatedBudget =
          event.allocatedBudget - removedService.packagePrice;
      final remainingBudget = event.totalBudget - allocatedBudget;

      // 5. Update Event in Firestore
      await _firestore
          .collection(FirebaseCollections.events)
          .doc(eventId)
          .update({
            'services': updatedServices.map((s) => s.toJson()).toList(),
            'allocatedBudget': allocatedBudget,
            'remainingBudget': remainingBudget,
            'totalAmount': allocatedBudget,
            'remainingAmount': allocatedBudget,
            'totalVendorsCount': updatedServices.length,
            'updatedAt': Timestamp.fromDate(DateTime.now()),
          });

      // ✅ 6. DELETE PackageRequest from Firestore (المهم!)
      // البحث عن الـ PackageRequest اللي عنده نفس eventId و serviceId
      final requestsSnapshot = await _firestore
          .collection(FirebaseCollections.packageRequests)
          .where('eventId', isEqualTo: eventId)
          .where('serviceId', isEqualTo: serviceId)
          .get();

      // مسح الـ Request
      for (var doc in requestsSnapshot.docs) {
        await doc.reference.delete();
      }

      // ✅ 7. (Optional) Notify Vendor about cancellation
      // TODO: Send notification to vendor
      // await _notificationService.sendCancellationNotification(
      //   vendorId: removedService.vendorId,
      //   eventName: event.eventName,
      //   packageName: removedService.packageName,
      // );

      // 8. Return updated event
      final updatedEventResult = await getEventById(eventId);
      return updatedEventResult;
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to remove package'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EventModel>> replacePackage({
    required String eventId,
    required String serviceId,
    required String newPackageId,
    required String newPackageName,
    required String newVendorId,
    required String newVendorName,
    required double newPackagePrice,
  }) async {
    try {
      // ✅ 1. Get Event BEFORE removing
      final eventResult = await getEventById(eventId);
      if (eventResult.isLeft()) {
        return Left(ServerFailure('Event not found'));
      }

      final event = eventResult.getOrElse(() => throw Exception());

      // ✅ 2. Find serviceName BEFORE removing
      final oldService = event.services.firstWhere(
        (s) => s.serviceId == serviceId,
        orElse: () => throw Exception('Service not found'),
      );

      final serviceName = oldService.serviceName;
      final serviceNameAr = oldService.serviceNameAr;

      // ✅ 3. NOW remove old package
      await removePackageFromEvent(eventId: eventId, serviceId: serviceId);

      // ✅ 4. Add new package with saved serviceName
      return await addPackageToEvent(
        eventId: eventId,
        serviceId: serviceId,
        serviceName: serviceName,
        serviceNameAr: serviceNameAr,
        isRequired: true,
        packageId: newPackageId,
        packageName: newPackageName,
        vendorId: newVendorId,
        vendorName: newVendorName,
        packagePrice: newPackagePrice,
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EventModel>> updateVendorApprovalStatus(
    String eventId,
  ) async {
    try {
      final eventResult = await getEventById(eventId);
      if (eventResult.isLeft()) {
        return Left(ServerFailure('Event not found'));
      }

      final event = eventResult.getOrElse(() => throw Exception());

      // Get all package requests for this event
      final requestsSnapshot = await _firestore
          .collection(FirebaseCollections.packageRequests)
          .where('eventId', isEqualTo: eventId)
          .get();

      final requests = requestsSnapshot.docs
          .map((doc) => PackageRequestModel.fromJson(doc.data()))
          .toList();

      // ✅ Update service approval status
      final updatedServices = event.services.map((service) {
        final request = requests.firstWhere(
          (r) => r.requestId == service.requestId,
        );

        // ✅ استخدام vendorApprovalStatus (String) مش status (Enum)
        return service.copyWith(
          vendorApproved: request.status == RequestStatus.accepted,
        );
      }).toList();

      final approvedCount = updatedServices
          .where((s) => s.vendorApproved)
          .length;

      // ✅ استخدام vendorApprovalStatus
      final rejectedCount = requests
          .where((r) => r.status == RequestStatus.rejected)
          .length;

      final pendingCount = updatedServices
          .where((s) => !s.vendorApproved)
          .length;

      final allApproved =
          approvedCount == updatedServices.length && updatedServices.isNotEmpty;

      await _firestore
          .collection(FirebaseCollections.events)
          .doc(eventId)
          .update({
            'services': updatedServices.map((s) => s.toJson()).toList(),
            'approvedVendorsCount': approvedCount,
            'rejectedVendorsCount': rejectedCount,
            'pendingVendorsCount': pendingCount,
            'allVendorsApproved': allApproved,
            'status': allApproved
                ? EventStatus.confirmed.name
                : EventStatus.pending.name,
            'updatedAt': Timestamp.fromDate(DateTime.now()),
          });

      final updatedEventResult = await getEventById(eventId);
      return updatedEventResult;
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to update status'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PackageRequestModel>>> getEventPackageRequests(
    String eventId,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseCollections.packageRequests)
          .where('eventId', isEqualTo: eventId)
          .get();

      final requests = querySnapshot.docs
          .map((doc) => PackageRequestModel.fromJson(doc.data()))
          .toList();

      return Right(requests);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to get requests'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ===== Event Invitations =====

  @override
  Future<Either<Failure, EventInvitationModel>> sendInvitation({
    required String eventId,
    required String eventName,
    required String eventOwnerId,
    required String eventOwnerName,
    String? eventOwnerEmail,
    // ✅ Event Details
    required DateTime eventDate,
    String? eventLocation,
    String? eventCity,
    String? eventAddress,
    String? eventType,
    int? expectedGuestCount,
    // Invitee Info
    String? attendeeId,
    required String inviteeName,
    String? inviteeEmail,
    String? inviteePhone,
    required InvitationType invitationType,
    String? personalMessage,
    int guestCount = 1,
  }) async {
    try {
      final invitationId = _uuid.v4();

      final invitation = EventInvitationModel(
        invitationId: invitationId,
        eventId: eventId,
        eventName: eventName,
        eventOwnerId: eventOwnerId,
        eventOwnerName: eventOwnerName,
        eventOwnerEmail: eventOwnerEmail,
        // ✅ Event Details
        eventDate: eventDate,
        eventLocation: eventLocation,
        eventCity: eventCity,
        eventAddress: eventAddress,
        eventType: eventType,
        expectedGuestCount: expectedGuestCount,
        // Invitee Info
        attendeeId: attendeeId,
        inviteeName: inviteeName,
        inviteeEmail: inviteeEmail,
        inviteePhone: inviteePhone,
        invitationType: invitationType,
        personalMessage: personalMessage,
        guestCount: guestCount,
      );

      await _firestore
          .collection(FirebaseCollections.eventInvitations)
          .doc(invitationId)
          .set(invitation.toJson());

      // Update event invitation counts
      await updateInvitationCounts(eventId);

      return Right(invitation);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to send invitation'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EventInvitationModel>>> sendBulkInvitations({
    required String eventId,
    required String eventName,
    required String eventOwnerId,
    required String eventOwnerName,
    String? eventOwnerEmail,
    // ✅ Event Details
    required DateTime eventDate,
    String? eventLocation,
    String? eventCity,
    String? eventAddress,
    String? eventType,
    int? expectedGuestCount,
    required List<Map<String, dynamic>> invitees,
  }) async {
    try {
      final List<EventInvitationModel> invitations = [];
      final batch = _firestore.batch();

      debugPrint('📨 [EventOwnerRepository.sendBulkInvitations] Starting...');
      debugPrint('   Event: $eventName');
      debugPrint('   Total invitees: ${invitees.length}');

      for (var invitee in invitees) {
        final invitationId = _uuid.v4();

        final invitation = EventInvitationModel(
          invitationId: invitationId,
          eventId: eventId,
          eventName: eventName,
          eventOwnerId: eventOwnerId,
          eventOwnerName: eventOwnerName,
          eventOwnerEmail: eventOwnerEmail,
          // ✅ Event Details
          eventDate: eventDate,
          eventLocation: eventLocation,
          eventCity: eventCity,
          eventAddress: eventAddress,
          eventType: eventType,
          expectedGuestCount: expectedGuestCount,
          // Invitee Info
          attendeeId: invitee['attendeeId'],
          inviteeName: invitee['inviteeName'],
          inviteeEmail: invitee['inviteeEmail'],
          inviteePhone: invitee['inviteePhone'],
          invitationType: InvitationType.values.firstWhere(
            (t) => t.name == invitee['invitationType'],
            orElse: () => InvitationType.email,
          ),
          personalMessage: invitee['personalMessage'],
          guestCount: invitee['guestCount'] ?? 1,
        );

        final docRef = _firestore
            .collection(FirebaseCollections.eventInvitations)
            .doc(invitationId);

        batch.set(docRef, invitation.toJson());
        invitations.add(invitation);

        // ✅ إرسال notification للـ attendee
        final attendeeId = invitee['attendeeId'] as String?;
        final attendeeFcmToken = invitee['attendeeFcmToken'] as String?;
        final inviteeName = invitee['inviteeName'] as String?;

        if (attendeeId != null && attendeeFcmToken != null && attendeeFcmToken.isNotEmpty) {
          try {
            debugPrint('📤 [EventOwnerRepository] Sending notification to: $inviteeName');
            debugPrint('   Attendee ID: $attendeeId');
            debugPrint('   FCM Token: $attendeeFcmToken');

            await NotificationService.sendNotification(
              receiverId: attendeeId,
              receiverRole: 'attendee',
              title: '🎉 Event Invitation',
              body: 'You\'re invited to: $eventName',
              type: 'invitation',
              data: {
                'invitationId': invitationId,
                'eventId': eventId,
                'eventName': eventName,
                'eventDate': eventDate.toIso8601String(),
                'eventOwnerName': eventOwnerName,
              },
              fcmToken: attendeeFcmToken,
            );

            // عرض local notification فوراً
            await NotificationService.showLocalNotification(
              title: '🎉 Event Invitation',
              body: 'You\'re invited to: $eventName',
            );

            debugPrint('✅ [EventOwnerRepository] Notification sent to: $inviteeName');
          } catch (e) {
            debugPrint('⚠️ [EventOwnerRepository] Error sending notification to $inviteeName: $e');
            // لا نوقف العملية إذا فشل الـ notification
          }
        } else {
          debugPrint('⚠️ [EventOwnerRepository] No FCM token for attendee: $inviteeName');
        }
      }

      await batch.commit();

      // Update event invitation counts
      await updateInvitationCounts(eventId);

      debugPrint('✅ [EventOwnerRepository.sendBulkInvitations] Completed! ${invitations.length} invitations sent');
      return Right(invitations);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to send invitations'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EventInvitationModel>>> getEventInvitations(
    String eventId,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseCollections.eventInvitations)
          .where('eventId', isEqualTo: eventId)
          // ❌ Removed: .orderBy('sentAt', descending: true)
          .get();

      // ✅ Sort manually in memory after fetching
      final invitations =
          querySnapshot.docs
              .map((doc) => EventInvitationModel.fromJson(doc.data()))
              .toList()
            ..sort((a, b) => b.sentAt.compareTo(a.sentAt)); // ✅ Manual sorting

      return Right(invitations);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to get invitations'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EventInvitationModel>>> getInvitationsByStatus({
    required String eventId,
    required InvitationStatus status,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseCollections.eventInvitations)
          .where('eventId', isEqualTo: eventId)
          .where('status', isEqualTo: status.name)
          .get();

      final invitations = querySnapshot.docs
          .map((doc) => EventInvitationModel.fromJson(doc.data()))
          .toList();

      return Right(invitations);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to get invitations'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EventInvitationModel>> resendInvitation(
    String invitationId,
  ) async {
    try {
      final docRef = _firestore
          .collection(FirebaseCollections.eventInvitations)
          .doc(invitationId);

      await docRef.update({
        'reminderSent': true,
        'reminderSentAt': Timestamp.fromDate(DateTime.now()),
        'reminderCount': FieldValue.increment(1),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      final updatedDoc = await docRef.get();
      final invitation = EventInvitationModel.fromJson(
        updatedDoc.data() as Map<String, dynamic>,
      );

      return Right(invitation);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to resend invitation'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelInvitation(String invitationId) async {
    try {
      await _firestore
          .collection(FirebaseCollections.eventInvitations)
          .doc(invitationId)
          .delete();

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to cancel invitation'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateInvitationCounts(String eventId) async {
    try {
      final invitationsResult = await getEventInvitations(eventId);
      if (invitationsResult.isLeft()) {
        return const Right(null);
      }

      final invitations = invitationsResult.getOrElse(() => []);

      final totalSent = invitations.length;
      final accepted = invitations
          .where((i) => i.status == InvitationStatus.accepted)
          .length;
      final rejected = invitations
          .where((i) => i.status == InvitationStatus.rejected)
          .length;
      final pending = invitations
          .where((i) => i.status == InvitationStatus.pending)
          .length;

      await _firestore
          .collection(FirebaseCollections.events)
          .doc(eventId)
          .update({
            'totalInvitationsSent': totalSent,
            'acceptedInvitations': accepted,
            'rejectedInvitations': rejected,
            'pendingInvitations': pending,
            'updatedAt': Timestamp.fromDate(DateTime.now()),
          });

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ===== Event Status Management =====

  @override
  Future<Either<Failure, EventModel>> confirmEvent(String eventId) async {
    try {
      await _firestore
          .collection(FirebaseCollections.events)
          .doc(eventId)
          .update({
            'status': EventStatus.confirmed.name,
            'updatedAt': Timestamp.fromDate(DateTime.now()),
          });

      final eventResult = await getEventById(eventId);
      return eventResult;
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to confirm event'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EventModel>> cancelEvent({
    required String eventId,
    required String cancellationReason,
  }) async {
    try {
      await _firestore
          .collection(FirebaseCollections.events)
          .doc(eventId)
          .update({
            'status': EventStatus.cancelled.name,
            'isCancelled': true,
            'cancellationReason': cancellationReason,
            'cancelledAt': Timestamp.fromDate(DateTime.now()),
            'updatedAt': Timestamp.fromDate(DateTime.now()),
          });

      final eventResult = await getEventById(eventId);
      return eventResult;
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to cancel event'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EventModel>> completeEvent(String eventId) async {
    try {
      await _firestore
          .collection(FirebaseCollections.events)
          .doc(eventId)
          .update({
            'status': EventStatus.completed.name,
            'completedAt': Timestamp.fromDate(DateTime.now()),
            'updatedAt': Timestamp.fromDate(DateTime.now()),
          });

      final eventResult = await getEventById(eventId);
      return eventResult;
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to complete event'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  // ===== Package Browsing (NEW) =====

  @override
Future<Either<Failure, List<PackageModel>>> getPackagesByService({
  required String serviceId,
  bool onlyActive = true,
}) async {
  try {
    Query query = _firestore
        .collection(FirebaseCollections.packages)
        .where('serviceId', isEqualTo: serviceId);

    // Only get approved and active packages for Event Owner
    if (onlyActive) {
      query = query
          .where('isActive', isEqualTo: true)
          .where('isApprovedByOwner', isEqualTo: true)
          .where('status', isEqualTo: 'active');
    }

    // ❌ Removed multiple orderBy - causes Index error
    // .orderBy('rating', descending: true)
    // .orderBy('createdAt', descending: true)

    final querySnapshot = await query.get();

    // ✅ Sort manually in memory
    final packages = querySnapshot.docs
        .map((doc) => PackageModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList()
      ..sort((a, b) {
        // First by rating (descending)
        final ratingCompare = (b.rating ?? 0).compareTo(a.rating ?? 0);
        if (ratingCompare != 0) return ratingCompare;
        
        // Then by created date (descending)
        return b.createdAt.compareTo(a.createdAt);
      });

    return Right(packages);
  } on FirebaseException catch (e) {
    return Left(
      ServerFailure(e.message ?? 'Failed to get packages'),
    );
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}


  @override
  Future<Either<Failure, PackageModel>> getPackageDetails(
    String packageId,
  ) async {
    try {
      final docSnapshot = await _firestore
          .collection(FirebaseCollections.packages)
          .doc(packageId)
          .get();

      if (!docSnapshot.exists) {
        return Left(ServerFailure('Package not found'));
      }

      final package = PackageModel.fromJson(
        docSnapshot.data() as Map<String, dynamic>,
      );

      // Increment view count
      await _firestore
          .collection(FirebaseCollections.packages)
          .doc(packageId)
          .update({
            'viewCount': FieldValue.increment(1),
            'updatedAt': DateTime.now().toIso8601String(),
          });

      return Right(package);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to get package details'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PackageModel>>> searchPackages({
    String? searchQuery,
    String? serviceId,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      Query query = _firestore
          .collection(FirebaseCollections.packages)
          .where('isActive', isEqualTo: true)
          .where('isApprovedByOwner', isEqualTo: true)
          .where('status', isEqualTo: 'active');

      // Filter by service if provided
      if (serviceId != null && serviceId.isNotEmpty) {
        query = query.where('serviceId', isEqualTo: serviceId);
      }

      final querySnapshot = await query.get();

      List<PackageModel> packages = querySnapshot.docs
          .map(
            (doc) => PackageModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();

      // Filter by search query (keywords, name, description)
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final lowerQuery = searchQuery.toLowerCase();
        packages = packages.where((pkg) {
          return pkg.keywords.any(
                (keyword) => keyword.toLowerCase().contains(lowerQuery),
              ) ||
              pkg.packageName.toLowerCase().contains(lowerQuery) ||
              pkg.description.toLowerCase().contains(lowerQuery);
        }).toList();
      }

      // Filter by price range
      if (minPrice != null) {
        packages = packages.where((pkg) => pkg.price >= minPrice).toList();
      }
      if (maxPrice != null) {
        packages = packages.where((pkg) => pkg.price <= maxPrice).toList();
      }

      // Sort by rating and popularity
      packages.sort((a, b) {
        // First by rating
        final ratingCompare = (b.rating ?? 0).compareTo(a.rating ?? 0);
        if (ratingCompare != 0) return ratingCompare;

        // Then by booking count
        return b.bookingCount.compareTo(a.bookingCount);
      });

      return Right(packages);
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to search packages'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ===== Payment Management =====

  @override
  Future<Either<Failure, EventModel>> updatePaymentStatus({
    required String eventId,
    required PaymentStatus paymentStatus,
    required double paidAmount,
  }) async {
    try {
      final eventResult = await getEventById(eventId);
      if (eventResult.isLeft()) {
        return Left(ServerFailure('Event not found'));
      }

      final event = eventResult.getOrElse(() => throw Exception());
      final remainingAmount = event.totalAmount - paidAmount;

      // ✅ Determine event status based on payment status
      EventStatus newEventStatus = event.status;
      if (paymentStatus == PaymentStatus.paid || 
          paymentStatus == PaymentStatus.partiallyPaid) {
        newEventStatus = EventStatus.confirmed;
      }

      final now = DateTime.now();

      // ✅ Update event payment status
      await _firestore
          .collection(FirebaseCollections.events)
          .doc(eventId)
          .update({
            'paymentStatus': paymentStatus.name,
            'paidAmount': paidAmount,
            'remainingAmount': remainingAmount,
            'status': newEventStatus.name, // ✅ Update event status to confirmed
            'updatedAt': Timestamp.fromDate(now),
          });

      // ✅ Create owner profit record
      await _firestore
          .collection('owner_profit')
          .add({
            'eventOwnerId': event.eventOwnerId,
            'eventOwnerName': event.eventOwnerName,
            'eventOwnerEmail': event.eventOwnerEmail,
            'eventId': eventId,
            'eventName': event.eventName,
            'paidAmount': paidAmount,
            'paymentStatus': paymentStatus.name,
            'paymentMethod': 'card', // Default, can be updated based on actual method
            'createdAt': Timestamp.fromDate(now),
            'updatedAt': Timestamp.fromDate(now),
          });

      debugPrint('💰 [updatePaymentStatus] Owner profit recorded:');
      debugPrint('   eventOwnerId: ${event.eventOwnerId}');
      debugPrint('   eventId: $eventId');
      debugPrint('   paidAmount: $paidAmount');

      final updatedEventResult = await getEventById(eventId);
      return updatedEventResult;
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to update payment'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ✅ Get owner total profits (جلب كل الأرباح بدون filter)
  @override
  Future<Either<Failure, Map<String, dynamic>>> getOwnerProfits(
  ) async {
    try {
      debugPrint('💰 [getOwnerProfits] Fetching all profits from owner_profit collection');

      // ✅ جلب كل الـ documents من غير filter (الـ owner واحد فقط)
      final querySnapshot = await _firestore
          .collection('owner_profit')
          .get();

      debugPrint('💰 [getOwnerProfits] Found ${querySnapshot.docs.length} profit records');

      double totalProfit = 0.0;
      int totalTransactions = 0;
      List<Map<String, dynamic>> profitRecords = [];

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final paidAmount = (data['paidAmount'] as num?)?.toDouble() ?? 0.0;
        
        totalProfit += paidAmount;
        totalTransactions++;
        
        profitRecords.add({
          'profitId': doc.id,
          'eventOwnerId': data['eventOwnerId'],
          'eventOwnerName': data['eventOwnerName'],
          'eventId': data['eventId'],
          'eventName': data['eventName'],
          'paidAmount': paidAmount,
          'paymentStatus': data['paymentStatus'],
          'paymentMethod': data['paymentMethod'],
          'createdAt': data['createdAt'],
        });
      }

      debugPrint('💰 [getOwnerProfits] Total profit: $totalProfit from $totalTransactions transactions');

      return Right({
        'totalProfit': totalProfit,
        'totalTransactions': totalTransactions,
        'profitRecords': profitRecords,
      });
    } on FirebaseException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to get owner profits'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> calculateTotalEventCost(
    String eventId,
  ) async {
    try {
      final eventResult = await getEventById(eventId);
      if (eventResult.isLeft()) {
        return Left(ServerFailure('Event not found'));
      }

      final event = eventResult.getOrElse(() => throw Exception());
      final totalCost = event.services.fold<double>(
        0.0,
        (sum, service) => sum + service.packagePrice,
      );

      return Right(totalCost);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ===== Statistics =====

  @override
  Future<Either<Failure, Map<String, dynamic>>> getEventStats(
    String eventId,
  ) async {
    try {
      final eventResult = await getEventById(eventId);
      if (eventResult.isLeft()) {
        return Left(ServerFailure('Event not found'));
      }

      final event = eventResult.getOrElse(() => throw Exception());

      final stats = {
        'eventId': event.eventId,
        'eventName': event.eventName,
        'status': event.status.name,
        'totalBudget': event.totalBudget,
        'allocatedBudget': event.allocatedBudget,
        'remainingBudget': event.remainingBudget,
        'budgetUtilization': event.budgetUtilizationPercentage,
        'totalServices': event.services.length,
        'approvedVendors': event.approvedVendorsCount,
        'rejectedVendors': event.rejectedVendorsCount,
        'pendingVendors': event.pendingVendorsCount,
        'allVendorsApproved': event.allVendorsApproved,
        'totalInvitations': event.totalInvitationsSent,
        'acceptedInvitations': event.acceptedInvitations,
        'rejectedInvitations': event.rejectedInvitations,
        'pendingInvitations': event.pendingInvitations,
        'expectedGuests': event.expectedGuestCount,
        'confirmedGuests': event.confirmedGuestCount ?? 0,
        'paymentStatus': event.paymentStatus.name,
        'totalAmount': event.totalAmount,
        'paidAmount': event.paidAmount,
        'remainingAmount': event.remainingAmount,
      };

      return Right(stats);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getEventOwnerStats(
    String eventOwnerId,
  ) async {
    try {
      final eventsResult = await getEventOwnerEvents(eventOwnerId);
      if (eventsResult.isLeft()) {
        return Left(ServerFailure('Failed to get stats'));
      }

      final events = eventsResult.getOrElse(() => []);

      final stats = {
        'totalEvents': events.length,
        'draftEvents': events
            .where((e) => e.status == EventStatus.draft)
            .length,
        'pendingEvents': events
            .where((e) => e.status == EventStatus.pending)
            .length,
        'confirmedEvents': events
            .where((e) => e.status == EventStatus.confirmed)
            .length,
        'completedEvents': events
            .where((e) => e.status == EventStatus.completed)
            .length,
        'cancelledEvents': events
            .where((e) => e.status == EventStatus.cancelled)
            .length,
        'totalBudget': events.fold<double>(0, (sum, e) => sum + e.totalBudget),
        'totalSpent': events.fold<double>(
          0,
          (sum, e) => sum + e.allocatedBudget,
        ),
        'upcomingEvents': events
            .where(
              (e) =>
                  e.eventDate.isAfter(DateTime.now()) &&
                  e.status != EventStatus.cancelled,
            )
            .length,
      };

      return Right(stats);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
