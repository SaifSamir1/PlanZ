// lib/features/event_owner/presentation/cubit/event_owner_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/cubits/create_event_cubit/create_event_state.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_invitation_model.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_model_enum.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/repo/event_owner_repo.dart';

class EventOwnerCubit extends Cubit<EventOwnerState> {
  final EventOwnerRepository repository;

  EventOwnerCubit(this.repository) : super(EventOwnerInitial());

  // ============================================
  // 1. CREATE EVENT
  // ============================================
  Future<void> createEvent({
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
    emit(CreateEventLoading());

    final result = await repository.createEvent(
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
      expectedGuestCount: expectedGuestCount,
      customRequirements: customRequirements,
    );

    result.fold(
      (failure) => emit(CreateEventError(failure.message)),
      (event) => emit(CreateEventSuccess(event)),
    );
  }

  // ============================================
  // 2. UPDATE EVENT
  // ============================================
  Future<void> updateEvent({
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
    emit(UpdateEventLoading());

    final result = await repository.updateEvent(
      eventId: eventId,
      eventName: eventName,
      description: description,
      eventDate: eventDate,
      location: location,
      city: city,
      address: address,
      coordinates: coordinates,
      totalBudget: totalBudget,
      expectedGuestCount: expectedGuestCount,
      status: status,
    );

    result.fold(
      (failure) => emit(UpdateEventError(failure.message)),
      (event) => emit(UpdateEventSuccess(event)),
    );
  }

  // ============================================
  // 3. DELETE EVENT
  // ============================================
  Future<void> deleteEvent(String eventId) async {
    emit(DeleteEventLoading());

    final result = await repository.deleteEvent(eventId);

    result.fold(
      (failure) => emit(DeleteEventError(failure.message)),
      (_) => emit(DeleteEventSuccess()),
    );
  }

  // ============================================
  // 4. GET EVENT BY ID
  // ============================================
  Future<void> getEventById(String eventId) async {
    emit(GetEventByIdLoading());

    final result = await repository.getEventById(eventId);

    result.fold(
      (failure) => emit(GetEventByIdError(failure.message)),
      (event) => emit(GetEventByIdSuccess(event)),
    );
  }

  // ============================================
  // 5. GET EVENT OWNER EVENTS
  // ============================================
  Future<void> getEventOwnerEvents(String eventOwnerId) async {
    emit(GetEventOwnerEventsLoading());

    final result = await repository.getEventOwnerEvents(eventOwnerId);

    result.fold(
      (failure) => emit(GetEventOwnerEventsError(failure.message)),
      (events) => emit(GetEventOwnerEventsSuccess(events)),
    );
  }

  // ============================================
  // 6. GET EVENTS BY STATUS
  // ============================================
  Future<void> getEventsByStatus({
    required String eventOwnerId,
    required EventStatus status,
  }) async {
    emit(GetEventsByStatusLoading());

    final result = await repository.getEventsByStatus(
      eventOwnerId: eventOwnerId,
      status: status,
    );

    result.fold(
      (failure) => emit(GetEventsByStatusError(failure.message)),
      (events) => emit(GetEventsByStatusSuccess(events)),
    );
  }

  // ============================================
  // 7. GET PACKAGES BY SERVICE
  // ============================================
  Future<void> getPackagesByService({
    required String serviceId,
    bool onlyActive = true,
  }) async {
    emit(GetPackagesByServiceLoading());

    final result = await repository.getPackagesByService(
      serviceId: serviceId,
      onlyActive: onlyActive,
    );

    result.fold(
      (failure) => emit(GetPackagesByServiceError(failure.message)),
      (packages) => emit(GetPackagesByServiceSuccess(packages)),
    );
  }

  // ============================================
  // 8. GET PACKAGE DETAILS
  // ============================================
  Future<void> getPackageDetails(String packageId) async {
    emit(GetPackageDetailsLoading());

    final result = await repository.getPackageDetails(packageId);

    result.fold(
      (failure) => emit(GetPackageDetailsError(failure.message)),
      (package) => emit(GetPackageDetailsSuccess(package)),
    );
  }

  // ============================================
  // 9. SEARCH PACKAGES
  // ============================================
  Future<void> searchPackages({
    String? searchQuery,
    String? serviceId,
    double? minPrice,
    double? maxPrice,
  }) async {
    emit(SearchPackagesLoading());

    final result = await repository.searchPackages(
      searchQuery: searchQuery,
      serviceId: serviceId,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );

    result.fold(
      (failure) => emit(SearchPackagesError(failure.message)),
      (packages) => emit(SearchPackagesSuccess(packages)),
    );
  }

  // ============================================
  // 10. ADD PACKAGE TO EVENT
  // ============================================
  Future<void> addPackageToEvent({
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
    emit(AddPackageToEventLoading());

    final result = await repository.addPackageToEvent(
      eventId: eventId,
      serviceId: serviceId,
      serviceName: serviceName,
      serviceNameAr: serviceNameAr,
      isRequired: isRequired,
      packageId: packageId,
      packageName: packageName,
      vendorId: vendorId,
      vendorName: vendorName,
      packagePrice: packagePrice,
      message: message,
    );

    result.fold(
      (failure) => emit(AddPackageToEventError(failure.message)),
      (event) {
        // الـ Repo بيرجع EventModel فقط، مش Map
        // لو محتاج الـ request، لازم تعمل getEventPackageRequests
        emit(AddPackageToEventSuccess(event, event.services.last.requestId));
      },
    );
  }

  // ============================================
  // 11. REMOVE PACKAGE FROM EVENT
  // ============================================
  Future<void> removePackageFromEvent({
    required String eventId,
    required String serviceId,
  }) async {
    emit(RemovePackageFromEventLoading());

    final result = await repository.removePackageFromEvent(
      eventId: eventId,
      serviceId: serviceId,
    );

    result.fold(
      (failure) => emit(RemovePackageFromEventError(failure.message)),
      (event) => emit(RemovePackageFromEventSuccess(event)),
    );
  }

  // ============================================
  // 12. REPLACE PACKAGE
  // ============================================
  Future<void> replacePackage({
    required String eventId,
    required String serviceId,
    required String newPackageId,
    required String newPackageName,
    required String newVendorId,
    required String newVendorName,
    required double newPackagePrice,
  }) async {
    emit(ReplacePackageLoading());

    final result = await repository.replacePackage(
      eventId: eventId,
      serviceId: serviceId,
      newPackageId: newPackageId,
      newPackageName: newPackageName,
      newVendorId: newVendorId,
      newVendorName: newVendorName,
      newPackagePrice: newPackagePrice,
    );

    result.fold(
      (failure) => emit(ReplacePackageError(failure.message)),
      (event) {
        emit(ReplacePackageSuccess(event, event.services.last.requestId));
      },
    );
  }

  // ============================================
  // 13. UPDATE VENDOR APPROVAL STATUS
  // ============================================
  Future<void> updateVendorApprovalStatus({
    required String eventId,
  }) async {
    emit(UpdateVendorApprovalStatusLoading());

    final result = await repository.updateVendorApprovalStatus(eventId);

    result.fold(
      (failure) => emit(UpdateVendorApprovalStatusError(failure.message)),
      (event) => emit(UpdateVendorApprovalStatusSuccess(event)),
    );
  }

  // ============================================
  // 14. GET EVENT PACKAGE REQUESTS
  // ============================================
  Future<void> getEventPackageRequests(String eventId) async {
    emit(GetEventPackageRequestsLoading());

    final result = await repository.getEventPackageRequests(eventId);

    result.fold(
      (failure) => emit(GetEventPackageRequestsError(failure.message)),
      (requests) => emit(GetEventPackageRequestsSuccess(requests)),
    );
  }

  // ============================================
  // 15. SEND INVITATION
  // ============================================
  Future<void> sendInvitation({
    required String eventId,
    required String eventName,
    required String eventOwnerId,
    required String eventOwnerName,
    String? attendeeId,
    required String inviteeName,
    String? inviteeEmail,
    String? inviteePhone,
    required InvitationType invitationType,
    String? personalMessage,
    int guestCount = 1,
  }) async {
    emit(SendInvitationLoading());

    final result = await repository.sendInvitation(
      eventId: eventId,
      eventName: eventName,
      eventOwnerId: eventOwnerId,
      eventOwnerName: eventOwnerName,
      attendeeId: attendeeId,
      inviteeName: inviteeName,
      inviteeEmail: inviteeEmail,
      inviteePhone: inviteePhone,
      invitationType: invitationType,
      personalMessage: personalMessage,
      guestCount: guestCount,
    );

    result.fold(
      (failure) => emit(SendInvitationError(failure.message)),
      (invitation) => emit(SendInvitationSuccess(invitation)),
    );
  }

  // ============================================
  // 16. SEND BULK INVITATIONS
  // ============================================
  Future<void> sendBulkInvitations({
    required String eventId,
    required String eventName,
    required String eventOwnerId,
    required String eventOwnerName,
    required List<Map<String, dynamic>> invitees,
  }) async {
    emit(SendBulkInvitationsLoading());

    final result = await repository.sendBulkInvitations(
      eventId: eventId,
      eventName: eventName,
      eventOwnerId: eventOwnerId,
      eventOwnerName: eventOwnerName,
      invitees: invitees,
    );

    result.fold(
      (failure) => emit(SendBulkInvitationsError(failure.message)),
      (invitations) {
        // الـ Repo بيرجع List<EventInvitationModel> فقط
        // لو محتاج Event، اعمل getEventById
        emit(SendBulkInvitationsSuccess(invitations));
      },
    );
  }

  // ============================================
  // 17. GET EVENT INVITATIONS
  // ============================================
  Future<void> getEventInvitations(String eventId) async {
    emit(GetEventInvitationsLoading());

    final result = await repository.getEventInvitations(eventId);

    result.fold(
      (failure) => emit(GetEventInvitationsError(failure.message)),
      (invitations) => emit(GetEventInvitationsSuccess(invitations)),
    );
  }

  // ============================================
  // 18. GET INVITATIONS BY STATUS
  // ============================================
  Future<void> getInvitationsByStatus({
    required String eventId,
    required InvitationStatus status,
  }) async {
    emit(GetInvitationsByStatusLoading());

    final result = await repository.getInvitationsByStatus(
      eventId: eventId,
      status: status,
    );

    result.fold(
      (failure) => emit(GetInvitationsByStatusError(failure.message)),
      (invitations) => emit(GetInvitationsByStatusSuccess(invitations)),
    );
  }

  // ============================================
  // 19. RESEND INVITATION
  // ============================================
  Future<void> resendInvitation(String invitationId) async {
    emit(ResendInvitationLoading());

    final result = await repository.resendInvitation(invitationId);

    result.fold(
      (failure) => emit(ResendInvitationError(failure.message)),
      (invitation) => emit(ResendInvitationSuccess(invitation)),
    );
  }

  // ============================================
  // 20. CANCEL INVITATION
  // ============================================
  Future<void> cancelInvitation(String invitationId) async {
    emit(CancelInvitationLoading());

    final result = await repository.cancelInvitation(invitationId);

    result.fold(
      (failure) => emit(CancelInvitationError(failure.message)),
      (_) => emit(CancelInvitationSuccess()),
    );
  }

  // ============================================
  // 21. UPDATE INVITATION COUNTS
  // ============================================
  Future<void> updateInvitationCounts(String eventId) async {
    emit(UpdateInvitationCountsLoading());

    final result = await repository.updateInvitationCounts(eventId);

    result.fold(
      (failure) => emit(UpdateInvitationCountsError(failure.message)),
      (_) => emit(UpdateInvitationCountsSuccess()),
    );
  }

  // ============================================
  // 22. CONFIRM EVENT
  // ============================================
  Future<void> confirmEvent(String eventId) async {
    emit(ConfirmEventLoading());

    final result = await repository.confirmEvent(eventId);

    result.fold(
      (failure) => emit(ConfirmEventError(failure.message)),
      (event) => emit(ConfirmEventSuccess(event)),
    );
  }

  // ============================================
  // 23. CANCEL EVENT
  // ============================================
  Future<void> cancelEvent({
    required String eventId,
    required String cancellationReason,
  }) async {
    emit(CancelEventLoading());

    final result = await repository.cancelEvent(
      eventId: eventId,
      cancellationReason: cancellationReason,
    );

    result.fold(
      (failure) => emit(CancelEventError(failure.message)),
      (event) => emit(CancelEventSuccess(event)),
    );
  }

  // ============================================
  // 24. COMPLETE EVENT
  // ============================================
  Future<void> completeEvent(String eventId) async {
    emit(CompleteEventLoading());

    final result = await repository.completeEvent(eventId);

    result.fold(
      (failure) => emit(CompleteEventError(failure.message)),
      (event) => emit(CompleteEventSuccess(event)),
    );
  }

  // ============================================
  // 25. UPDATE PAYMENT STATUS
  // ============================================
  Future<void> updatePaymentStatus({
    required String eventId,
    required PaymentStatus paymentStatus,
    required double paidAmount,
  }) async {
    emit(UpdatePaymentStatusLoading());

    final result = await repository.updatePaymentStatus(
      eventId: eventId,
      paymentStatus: paymentStatus,
      paidAmount: paidAmount,
    );

    result.fold(
      (failure) => emit(UpdatePaymentStatusError(failure.message)),
      (event) => emit(UpdatePaymentStatusSuccess(event)),
    );
  }

  // ============================================
  // 26. CALCULATE TOTAL EVENT COST
  // ============================================
  Future<void> calculateTotalEventCost(String eventId) async {
    emit(CalculateTotalEventCostLoading());

    final result = await repository.calculateTotalEventCost(eventId);

    result.fold(
      (failure) => emit(CalculateTotalEventCostError(failure.message)),
      (totalCost) => emit(CalculateTotalEventCostSuccess(totalCost)),
    );
  }

  // ============================================
  // 27. GET EVENT STATS
  // ============================================
  Future<void> getEventStats(String eventId) async {
    emit(GetEventStatsLoading());

    final result = await repository.getEventStats(eventId);

    result.fold(
      (failure) => emit(GetEventStatsError(failure.message)),
      (stats) => emit(GetEventStatsSuccess(stats)),
    );
  }

  // ============================================
  // 28. GET EVENT OWNER STATS
  // ============================================
  Future<void> getEventOwnerStats(String eventOwnerId) async {
    emit(GetEventOwnerStatsLoading());

    final result = await repository.getEventOwnerStats(eventOwnerId);

    result.fold(
      (failure) => emit(GetEventOwnerStatsError(failure.message)),
      (stats) => emit(GetEventOwnerStatsSuccess(stats)),
    );
  }
}


