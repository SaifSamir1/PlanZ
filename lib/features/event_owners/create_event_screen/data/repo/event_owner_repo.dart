// lib/features/event_owner/data/repositories/event_owner_repo.dart

import 'package:dartz/dartz.dart';
import 'package:plan_z/core/error/failures.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_invitation_model.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_model.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_model_enum.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_model.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_request_model.dart';

abstract class EventOwnerRepository {
  // ===== Event Management =====

  /// Create a new event
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
  });

  /// Update event details
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
  });

  /// Delete event
  Future<Either<Failure, void>> deleteEvent(String eventId);

  /// Get event by ID
  Future<Either<Failure, EventModel>> getEventById(String eventId);

  /// Get all events for event owner
  Future<Either<Failure, List<EventModel>>> getEventOwnerEvents(
    String eventOwnerId,
  );

  /// Get events by status
  Future<Either<Failure, List<EventModel>>> getEventsByStatus({
    required String eventOwnerId,
    required EventStatus status,
  });

  // ===== Package Browsing (NEW) =====

  /// Get all active packages for a specific service
  /// This is used when Event Owner wants to select packages
  Future<Either<Failure, List<PackageModel>>> getPackagesByService({
    required String serviceId,
    bool onlyActive = true,
  });

  /// Get single package details
  Future<Either<Failure, PackageModel>> getPackageDetails(String packageId);

  /// Search packages with filters
  Future<Either<Failure, List<PackageModel>>> searchPackages({
    String? searchQuery,
    String? serviceId,
    double? minPrice,
    double? maxPrice,
  });

  // ===== Package Selection & Vendor Requests =====

  /// Add package to event and create request to vendor
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
  });

  /// Remove package from event
  Future<Either<Failure, EventModel>> removePackageFromEvent({
    required String eventId,
    required String serviceId,
  });

  /// Replace rejected package with new one
  Future<Either<Failure, EventModel>> replacePackage({
    required String eventId,
    required String serviceId,
    required String newPackageId,
    required String newPackageName,
    required String newVendorId,
    required String newVendorName,
    required double newPackagePrice,
  });

  /// Check and update vendor approval status
  Future<Either<Failure, EventModel>> updateVendorApprovalStatus(
    String eventId,
  );

  /// Get all package requests for an event
  Future<Either<Failure, List<PackageRequestModel>>> getEventPackageRequests(
    String eventId,
  );

  // ===== Event Invitations =====

  /// Send invitation to attendee
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
  });

  /// Send bulk invitations
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
  });

  /// Get all invitations for an event
  Future<Either<Failure, List<EventInvitationModel>>> getEventInvitations(
    String eventId,
  );

  /// Get invitations by status
  Future<Either<Failure, List<EventInvitationModel>>> getInvitationsByStatus({
    required String eventId,
    required InvitationStatus status,
  });

  /// Resend invitation
  Future<Either<Failure, EventInvitationModel>> resendInvitation(
    String invitationId,
  );

  /// Cancel invitation
  Future<Either<Failure, void>> cancelInvitation(String invitationId);

  /// Update invitation counts in event
  Future<Either<Failure, void>> updateInvitationCounts(String eventId);

  // ===== Event Status Management =====

  /// Confirm event (all vendors approved)
  Future<Either<Failure, EventModel>> confirmEvent(String eventId);

  /// Cancel event
  Future<Either<Failure, EventModel>> cancelEvent({
    required String eventId,
    required String cancellationReason,
  });

  /// Mark event as completed
  Future<Either<Failure, EventModel>> completeEvent(String eventId);

  // ===== Payment Management =====

  /// Update payment status
  Future<Either<Failure, EventModel>> updatePaymentStatus({
    required String eventId,
    required PaymentStatus paymentStatus,
    required double paidAmount,
  });

  /// Get owner total profits from all events (جلب كل الأرباح بدون filter)
  Future<Either<Failure, Map<String, dynamic>>> getOwnerProfits();

  /// Calculate total event cost
  Future<Either<Failure, double>> calculateTotalEventCost(String eventId);

  // ===== Statistics =====

  /// Get event statistics
  Future<Either<Failure, Map<String, dynamic>>> getEventStats(String eventId);

  /// Get event owner statistics
  Future<Either<Failure, Map<String, dynamic>>> getEventOwnerStats(
    String eventOwnerId,
  );
}
