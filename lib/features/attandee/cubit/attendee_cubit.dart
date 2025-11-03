// lib/features/attendee/presentation/cubit/attendee_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/features/attandee/cubit/attendee_state.dart';
import 'package:plan_z/features/attandee/data/attandee_repo.dart';
import 'package:plan_z/features/attandee/data/models/app_notification_model.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_invitation_model.dart';

class AttendeeCubit extends Cubit<AttendeeState> {
  final AttendeeRepository repository;

  AttendeeCubit(this.repository) : super(AttendeeInitial());

  // ============================================
  // 1. INVITATIONS MANAGEMENT
  // ============================================

  /// Get all invitations for an attendee
  Future<void> getMyInvitations(String attendeeId) async {
    emit(GetMyInvitationsLoading());

    final result = await repository.getMyInvitations(attendeeId: attendeeId);

    result.fold(
      (failure) => emit(GetMyInvitationsError(failure.message)),
      (invitations) => emit(GetMyInvitationsSuccess(invitations)),
    );
  }

  /// Get invitations filtered by status
  Future<void> getInvitationsByStatus({
    required String attendeeId,
    required InvitationStatus status,
  }) async {
    emit(GetInvitationsByStatusLoading());

    final result = await repository.getInvitationsByStatus(
      attendeeId: attendeeId,
      status: status,
    );

    result.fold(
      (failure) => emit(GetInvitationsByStatusError(failure.message)),
      (invitations) => emit(GetInvitationsByStatusSuccess(invitations, status)),
    );
  }

  /// Get a single invitation by ID (for deep links)
  Future<void> getInvitationById(String invitationId) async {
    emit(GetInvitationByIdLoading());

    final result = await repository.getInvitationById(
      invitationId: invitationId,
    );

    result.fold(
      (failure) => emit(GetInvitationByIdError(failure.message)),
      (invitation) => emit(GetInvitationByIdSuccess(invitation)),
    );
  }

  /// Get invitation by email (for non-registered users)
  Future<void> getInvitationByEmail({
    required String email,
    required String invitationId,
  }) async {
    emit(GetInvitationByEmailLoading());

    final result = await repository.getInvitationByEmail(
      email: email,
      invitationId: invitationId,
    );

    result.fold(
      (failure) => emit(GetInvitationByEmailError(failure.message)),
      (invitation) => emit(GetInvitationByEmailSuccess(invitation)),
    );
  }

  /// Get invitation by phone (for non-registered users)
  Future<void> getInvitationByPhone({
    required String phone,
    required String invitationId,
  }) async {
    emit(GetInvitationByPhoneLoading());

    final result = await repository.getInvitationByPhone(
      phone: phone,
      invitationId: invitationId,
    );

    result.fold(
      (failure) => emit(GetInvitationByPhoneError(failure.message)),
      (invitation) => emit(GetInvitationByPhoneSuccess(invitation)),
    );
  }

  /// Respond to an invitation (Accept/Reject/Maybe)
  Future<void> respondToInvitation({
    required String invitationId,
    required InvitationStatus status,
    String? responseMessage,
    int? confirmedGuestCount,
  }) async {
    emit(RespondToInvitationLoading());

    final result = await repository.respondToInvitation(
      invitationId: invitationId,
      status: status,
      responseMessage: responseMessage,
      confirmedGuestCount: confirmedGuestCount,
    );

    result.fold(
      (failure) => emit(RespondToInvitationError(failure.message)),
      (invitation) => emit(RespondToInvitationSuccess(invitation)),
    );
  }

  /// Update invitation response (change answer)
  Future<void> updateInvitationResponse({
    required String invitationId,
    required InvitationStatus status,
    String? responseMessage,
    int? confirmedGuestCount,
  }) async {
    emit(UpdateInvitationResponseLoading());

    final result = await repository.updateInvitationResponse(
      invitationId: invitationId,
      status: status,
      responseMessage: responseMessage,
      confirmedGuestCount: confirmedGuestCount,
    );

    result.fold(
      (failure) => emit(UpdateInvitationResponseError(failure.message)),
      (invitation) => emit(UpdateInvitationResponseSuccess(invitation)),
    );
  }

  // ============================================
  // 2. EVENTS MANAGEMENT
  // ============================================

  /// Get all accepted events for an attendee
  Future<void> getMyAcceptedEvents(String attendeeId) async {
    emit(GetMyAcceptedEventsLoading());

    final result = await repository.getMyAcceptedEvents(attendeeId: attendeeId);

    result.fold(
      (failure) => emit(GetMyAcceptedEventsError(failure.message)),
      (events) => emit(GetMyAcceptedEventsSuccess(events)),
    );
  }

  /// Get upcoming events (accepted invitations with future dates)
  Future<void> getUpcomingEvents(String attendeeId) async {
    emit(GetUpcomingEventsLoading());

    final result = await repository.getUpcomingEvents(attendeeId: attendeeId);

    result.fold(
      (failure) => emit(GetUpcomingEventsError(failure.message)),
      (events) => emit(GetUpcomingEventsSuccess(events)),
    );
  }

  /// Get past events (accepted invitations with past dates)
  Future<void> getPastEvents(String attendeeId) async {
    emit(GetPastEventsLoading());

    final result = await repository.getPastEvents(attendeeId: attendeeId);

    result.fold(
      (failure) => emit(GetPastEventsError(failure.message)),
      (events) => emit(GetPastEventsSuccess(events)),
    );
  }

  /// Get event details by ID
  Future<void> getEventDetails(String eventId) async {
    emit(GetEventDetailsLoading());

    final result = await repository.getEventDetails(eventId: eventId);

    result.fold(
      (failure) => emit(GetEventDetailsError(failure.message)),
      (event) => emit(GetEventDetailsSuccess(event)),
    );
  }

  // ============================================
  // 3. STATISTICS
  // ============================================

  /// Get attendee statistics
  Future<void> getAttendeeStats(String attendeeId) async {
    emit(GetAttendeeStatsLoading());

    final result = await repository.getAttendeeStats(attendeeId: attendeeId);

    result.fold(
      (failure) => emit(GetAttendeeStatsError(failure.message)),
      (stats) => emit(GetAttendeeStatsSuccess(stats)),
    );
  }

  // ============================================
  // 4. LINK ATTENDEE TO INVITATION
  // ============================================

  /// Link a registered attendee to an invitation (after sign-up)
  Future<void> linkAttendeeToInvitation({
    required String invitationId,
    required String attendeeId,
  }) async {
    emit(LinkAttendeeToInvitationLoading());

    final result = await repository.linkAttendeeToInvitation(
      invitationId: invitationId,
      attendeeId: attendeeId,
    );

    result.fold(
      (failure) => emit(LinkAttendeeToInvitationError(failure.message)),
      (invitation) => emit(LinkAttendeeToInvitationSuccess(invitation)),
    );
  }

  // ============================================

  void listenToNotifications(String attendeeId) {
    emit(GetNotificationsLoading());
    repository
        .getAttendeeNotifications(attendeeId)
        .listen(
          (notifications) {
            emit(GetNotificationsSuccess(notifications));
          },
          onError: (e) {
            emit(GetNotificationsError(e.toString()));
          },
        );
  }

  Future<void> sendNotification(String receiverId, String title, String body) async {
    await repository.sendAttendeeNotification(receiverId: receiverId, title: title, body: body);
  }

  // HELPER METHODS
  // ============================================

  /// Reset state to initial
  void resetState() {
    emit(AttendeeInitial());
  }
}
