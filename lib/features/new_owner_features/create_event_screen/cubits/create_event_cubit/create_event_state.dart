// lib/features/event_owner/presentation/cubit/event_owner_state.dart

import 'package:equatable/equatable.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_model.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_invitation_model.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_model.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/models/package_request_model.dart';

abstract class EventOwnerState extends Equatable {
  const EventOwnerState();

  @override
  List<Object?> get props => [];
}

// ============================================
// Initial State
// ============================================
class EventOwnerInitial extends EventOwnerState {}

// ============================================
// 1. CREATE EVENT STATES
// ============================================
class CreateEventLoading extends EventOwnerState {}

class CreateEventSuccess extends EventOwnerState {
  final EventModel event;

  const CreateEventSuccess(this.event);

  @override
  List<Object?> get props => [event];
}

class CreateEventError extends EventOwnerState {
  final String message;

  const CreateEventError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 2. UPDATE EVENT STATES
// ============================================
class UpdateEventLoading extends EventOwnerState {}

class UpdateEventSuccess extends EventOwnerState {
  final EventModel event;

  const UpdateEventSuccess(this.event);

  @override
  List<Object?> get props => [event];
}

class UpdateEventError extends EventOwnerState {
  final String message;

  const UpdateEventError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 3. DELETE EVENT STATES
// ============================================
class DeleteEventLoading extends EventOwnerState {}

class DeleteEventSuccess extends EventOwnerState {}

class DeleteEventError extends EventOwnerState {
  final String message;

  const DeleteEventError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 4. GET EVENT BY ID STATES
// ============================================
class GetEventByIdLoading extends EventOwnerState {}

class GetEventByIdSuccess extends EventOwnerState {
  final EventModel event;

  const GetEventByIdSuccess(this.event);

  @override
  List<Object?> get props => [event];
}

class GetEventByIdError extends EventOwnerState {
  final String message;

  const GetEventByIdError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 5. GET EVENT OWNER EVENTS STATES
// ============================================
class GetEventOwnerEventsLoading extends EventOwnerState {}

class GetEventOwnerEventsSuccess extends EventOwnerState {
  final List<EventModel> events;

  const GetEventOwnerEventsSuccess(this.events);

  @override
  List<Object?> get props => [events];
}

class GetEventOwnerEventsError extends EventOwnerState {
  final String message;

  const GetEventOwnerEventsError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 6. GET EVENTS BY STATUS STATES
// ============================================
class GetEventsByStatusLoading extends EventOwnerState {}

class GetEventsByStatusSuccess extends EventOwnerState {
  final List<EventModel> events;

  const GetEventsByStatusSuccess(this.events);

  @override
  List<Object?> get props => [events];
}

class GetEventsByStatusError extends EventOwnerState {
  final String message;

  const GetEventsByStatusError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 7. GET PACKAGES BY SERVICE STATES
// ============================================
class GetPackagesByServiceLoading extends EventOwnerState {}

class GetPackagesByServiceSuccess extends EventOwnerState {
  final List<PackageModel> packages;

  const GetPackagesByServiceSuccess(this.packages);

  @override
  List<Object?> get props => [packages];
}

class GetPackagesByServiceError extends EventOwnerState {
  final String message;

  const GetPackagesByServiceError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 8. GET PACKAGE DETAILS STATES
// ============================================
class GetPackageDetailsLoading extends EventOwnerState {}

class GetPackageDetailsSuccess extends EventOwnerState {
  final PackageModel package;

  const GetPackageDetailsSuccess(this.package);

  @override
  List<Object?> get props => [package];
}

class GetPackageDetailsError extends EventOwnerState {
  final String message;

  const GetPackageDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 9. SEARCH PACKAGES STATES
// ============================================
class SearchPackagesLoading extends EventOwnerState {}

class SearchPackagesSuccess extends EventOwnerState {
  final List<PackageModel> packages;

  const SearchPackagesSuccess(this.packages);

  @override
  List<Object?> get props => [packages];
}

class SearchPackagesError extends EventOwnerState {
  final String message;

  const SearchPackagesError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 10. ADD PACKAGE TO EVENT STATES
// ============================================
class AddPackageToEventLoading extends EventOwnerState {}

class AddPackageToEventSuccess extends EventOwnerState {
  final EventModel event;
  final String requestId; // ✅ بدل PackageRequestModel

  const AddPackageToEventSuccess(this.event, this.requestId);

  @override
  List<Object?> get props => [event, requestId];
}


class AddPackageToEventError extends EventOwnerState {
  final String message;

  const AddPackageToEventError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 11. REMOVE PACKAGE FROM EVENT STATES
// ============================================
class RemovePackageFromEventLoading extends EventOwnerState {}

class RemovePackageFromEventSuccess extends EventOwnerState {
  final EventModel event;

  const RemovePackageFromEventSuccess(this.event);

  @override
  List<Object?> get props => [event];
}

class RemovePackageFromEventError extends EventOwnerState {
  final String message;

  const RemovePackageFromEventError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 12. REPLACE PACKAGE STATES
// ============================================
class ReplacePackageLoading extends EventOwnerState {}
class ReplacePackageSuccess extends EventOwnerState {
  final EventModel event;
  final String requestId; // ✅ بدل PackageRequestModel

  const ReplacePackageSuccess(this.event, this.requestId);

  @override
  List<Object?> get props => [event, requestId];
}


class ReplacePackageError extends EventOwnerState {
  final String message;

  const ReplacePackageError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 13. UPDATE VENDOR APPROVAL STATUS STATES
// ============================================
class UpdateVendorApprovalStatusLoading extends EventOwnerState {}

class UpdateVendorApprovalStatusSuccess extends EventOwnerState {
  final EventModel event;

  const UpdateVendorApprovalStatusSuccess(this.event);

  @override
  List<Object?> get props => [event];
}

class UpdateVendorApprovalStatusError extends EventOwnerState {
  final String message;

  const UpdateVendorApprovalStatusError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 14. GET EVENT PACKAGE REQUESTS STATES
// ============================================
class GetEventPackageRequestsLoading extends EventOwnerState {}

class GetEventPackageRequestsSuccess extends EventOwnerState {
  final List<PackageRequestModel> requests;

  const GetEventPackageRequestsSuccess(this.requests);

  @override
  List<Object?> get props => [requests];
}

class GetEventPackageRequestsError extends EventOwnerState {
  final String message;

  const GetEventPackageRequestsError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 15. SEND INVITATION STATES
// ============================================
class SendInvitationLoading extends EventOwnerState {}

class SendInvitationSuccess extends EventOwnerState {
  final EventInvitationModel invitation;

  const SendInvitationSuccess(this.invitation);

  @override
  List<Object?> get props => [invitation];
}

class SendInvitationError extends EventOwnerState {
  final String message;

  const SendInvitationError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 16. SEND BULK INVITATIONS STATES
// ============================================
class SendBulkInvitationsLoading extends EventOwnerState {}

class SendBulkInvitationsSuccess extends EventOwnerState {
  final List<EventInvitationModel> invitations;

  const SendBulkInvitationsSuccess(this.invitations);

  @override
  List<Object?> get props => [invitations];
}

class SendBulkInvitationsError extends EventOwnerState {
  final String message;

  const SendBulkInvitationsError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 17. GET EVENT INVITATIONS STATES
// ============================================
class GetEventInvitationsLoading extends EventOwnerState {}

class GetEventInvitationsSuccess extends EventOwnerState {
  final List<EventInvitationModel> invitations;

  const GetEventInvitationsSuccess(this.invitations);

  @override
  List<Object?> get props => [invitations];
}

class GetEventInvitationsError extends EventOwnerState {
  final String message;

  const GetEventInvitationsError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 18. GET INVITATIONS BY STATUS STATES
// ============================================
class GetInvitationsByStatusLoading extends EventOwnerState {}

class GetInvitationsByStatusSuccess extends EventOwnerState {
  final List<EventInvitationModel> invitations;

  const GetInvitationsByStatusSuccess(this.invitations);

  @override
  List<Object?> get props => [invitations];
}

class GetInvitationsByStatusError extends EventOwnerState {
  final String message;

  const GetInvitationsByStatusError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 19. RESEND INVITATION STATES
// ============================================
class ResendInvitationLoading extends EventOwnerState {}

class ResendInvitationSuccess extends EventOwnerState {
  final EventInvitationModel invitation;

  const ResendInvitationSuccess(this.invitation);

  @override
  List<Object?> get props => [invitation];
}

class ResendInvitationError extends EventOwnerState {
  final String message;

  const ResendInvitationError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 20. CANCEL INVITATION STATES
// ============================================
class CancelInvitationLoading extends EventOwnerState {}

class CancelInvitationSuccess extends EventOwnerState {}

class CancelInvitationError extends EventOwnerState {
  final String message;

  const CancelInvitationError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 21. UPDATE INVITATION COUNTS STATES
// ============================================
class UpdateInvitationCountsLoading extends EventOwnerState {}

class UpdateInvitationCountsSuccess extends EventOwnerState {

  const UpdateInvitationCountsSuccess();

  @override
  List<Object?> get props => [];
}

class UpdateInvitationCountsError extends EventOwnerState {
  final String message;

  const UpdateInvitationCountsError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 22. CONFIRM EVENT STATES
// ============================================
class ConfirmEventLoading extends EventOwnerState {}

class ConfirmEventSuccess extends EventOwnerState {
  final EventModel event;

  const ConfirmEventSuccess(this.event);

  @override
  List<Object?> get props => [event];
}

class ConfirmEventError extends EventOwnerState {
  final String message;

  const ConfirmEventError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 23. CANCEL EVENT STATES
// ============================================
class CancelEventLoading extends EventOwnerState {}

class CancelEventSuccess extends EventOwnerState {
  final EventModel event;

  const CancelEventSuccess(this.event);

  @override
  List<Object?> get props => [event];
}

class CancelEventError extends EventOwnerState {
  final String message;

  const CancelEventError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 24. COMPLETE EVENT STATES
// ============================================
class CompleteEventLoading extends EventOwnerState {}

class CompleteEventSuccess extends EventOwnerState {
  final EventModel event;

  const CompleteEventSuccess(this.event);

  @override
  List<Object?> get props => [event];
}

class CompleteEventError extends EventOwnerState {
  final String message;

  const CompleteEventError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 25. UPDATE PAYMENT STATUS STATES
// ============================================
class UpdatePaymentStatusLoading extends EventOwnerState {}

class UpdatePaymentStatusSuccess extends EventOwnerState {
  final EventModel event;

  const UpdatePaymentStatusSuccess(this.event);

  @override
  List<Object?> get props => [event];
}

class UpdatePaymentStatusError extends EventOwnerState {
  final String message;

  const UpdatePaymentStatusError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 26. CALCULATE TOTAL EVENT COST STATES
// ============================================
class CalculateTotalEventCostLoading extends EventOwnerState {}

class CalculateTotalEventCostSuccess extends EventOwnerState {
  final double totalCost;

  const CalculateTotalEventCostSuccess(this.totalCost);

  @override
  List<Object?> get props => [totalCost];
}

class CalculateTotalEventCostError extends EventOwnerState {
  final String message;

  const CalculateTotalEventCostError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 27. GET EVENT STATS STATES
// ============================================
class GetEventStatsLoading extends EventOwnerState {}

class GetEventStatsSuccess extends EventOwnerState {
  final Map<String, dynamic> stats;

  const GetEventStatsSuccess(this.stats);

  @override
  List<Object?> get props => [stats];
}

class GetEventStatsError extends EventOwnerState {
  final String message;

  const GetEventStatsError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 28. GET EVENT OWNER STATS STATES
// ============================================
class GetEventOwnerStatsLoading extends EventOwnerState {}

class GetEventOwnerStatsSuccess extends EventOwnerState {
  final Map<String, dynamic> stats;

  const GetEventOwnerStatsSuccess(this.stats);

  @override
  List<Object?> get props => [stats];
}

class GetEventOwnerStatsError extends EventOwnerState {
  final String message;

  const GetEventOwnerStatsError(this.message);

  @override
  List<Object?> get props => [message];
}


