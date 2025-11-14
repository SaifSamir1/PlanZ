import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/features/attandee/cubit/attendee_state.dart';
import 'package:plan_z/features/attandee/data/attandee_repo.dart';
 import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_invitation_model.dart';

class AttendeeCubit extends Cubit<AttendeeState> {
  final AttendeeRepository repository;

  AttendeeCubit(this.repository) : super(AttendeeInitial());

  StreamSubscription? _notificationsSubscription;

  // ============================================
  // 1. INVITATIONS MANAGEMENT
  // ============================================

  Future<void> getMyInvitations(String attendeeId) async {
    emit(GetMyInvitationsLoading());
    final result = await repository.getMyInvitations(attendeeId: attendeeId);
    result.fold(
      (failure) => emit(GetMyInvitationsError(failure.message)),
      (invitations) => emit(GetMyInvitationsSuccess(invitations)),
    );
  }

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

  Future<void> getInvitationById(String invitationId) async {
    emit(GetInvitationByIdLoading());
    final result = await repository.getInvitationById(invitationId: invitationId);
    result.fold(
      (failure) => emit(GetInvitationByIdError(failure.message)),
      (invitation) => emit(GetInvitationByIdSuccess(invitation)),
    );
  }

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

  Future<void> getMyAcceptedEvents(String attendeeId) async {
    emit(GetMyAcceptedEventsLoading());
    final result = await repository.getMyAcceptedEvents(attendeeId: attendeeId);
    result.fold(
      (failure) => emit(GetMyAcceptedEventsError(failure.message)),
      (events) => emit(GetMyAcceptedEventsSuccess(events)),
    );
  }

  Future<void> getUpcomingEvents(String attendeeId) async {
    emit(GetUpcomingEventsLoading());
    final result = await repository.getUpcomingEvents(attendeeId: attendeeId);
    result.fold(
      (failure) => emit(GetUpcomingEventsError(failure.message)),
      (events) => emit(GetUpcomingEventsSuccess(events)),
    );
  }

  Future<void> getPastEvents(String attendeeId) async {
    emit(GetPastEventsLoading());
    final result = await repository.getPastEvents(attendeeId: attendeeId);
    result.fold(
      (failure) => emit(GetPastEventsError(failure.message)),
      (events) => emit(GetPastEventsSuccess(events)),
    );
  }

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
  // 5. NOTIFICATIONS
  // ============================================

  void listenToNotifications(String attendeeId) {
    _notificationsSubscription?.cancel();
    emit(GetNotificationsLoading());
    _notificationsSubscription = repository
        .getAttendeeNotifications(attendeeId)
        .listen(
          (notifications) => emit(GetNotificationsSuccess(notifications)),
          onError: (e) => emit(GetNotificationsError(e.toString())),
        );
  }

  Future<void> sendNotification({
    required String receiverId,
    required String title,
    required String body,
  }) async {
    await repository.sendAttendeeNotification(
      receiverId: receiverId,
      title: title,
      body: body,
    );
  }

  // ============================================
  // 6. CLEANUP
  // ============================================

  void resetState() => emit(AttendeeInitial());

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }
}
