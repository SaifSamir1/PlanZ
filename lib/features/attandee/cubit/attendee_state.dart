// lib/features/attendee/presentation/cubit/attendee_state.dart

import 'package:equatable/equatable.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_invitation_model.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_model.dart';

abstract class AttendeeState extends Equatable {
  const AttendeeState();

  @override
  List<Object?> get props => [];
}

// ============================================
// Initial State
// ============================================
class AttendeeInitial extends AttendeeState {}

// ============================================
// 1. INVITATIONS STATES
// ============================================

// Get My Invitations
class GetMyInvitationsLoading extends AttendeeState {}

class GetMyInvitationsSuccess extends AttendeeState {
  final List<EventInvitationModel> invitations;

  const GetMyInvitationsSuccess(this.invitations);

  @override
  List<Object?> get props => [invitations];
}

class GetMyInvitationsError extends AttendeeState {
  final String message;

  const GetMyInvitationsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Get Invitations By Status
class GetInvitationsByStatusLoading extends AttendeeState {}

class GetInvitationsByStatusSuccess extends AttendeeState {
  final List<EventInvitationModel> invitations;
  final InvitationStatus status;

  const GetInvitationsByStatusSuccess(this.invitations, this.status);

  @override
  List<Object?> get props => [invitations, status];
}

class GetInvitationsByStatusError extends AttendeeState {
  final String message;

  const GetInvitationsByStatusError(this.message);

  @override
  List<Object?> get props => [message];
}

// Get Invitation By ID
class GetInvitationByIdLoading extends AttendeeState {}

class GetInvitationByIdSuccess extends AttendeeState {
  final EventInvitationModel invitation;

  const GetInvitationByIdSuccess(this.invitation);

  @override
  List<Object?> get props => [invitation];
}

class GetInvitationByIdError extends AttendeeState {
  final String message;

  const GetInvitationByIdError(this.message);

  @override
  List<Object?> get props => [message];
}

// Get Invitation By Email
class GetInvitationByEmailLoading extends AttendeeState {}

class GetInvitationByEmailSuccess extends AttendeeState {
  final EventInvitationModel invitation;

  const GetInvitationByEmailSuccess(this.invitation);

  @override
  List<Object?> get props => [invitation];
}

class GetInvitationByEmailError extends AttendeeState {
  final String message;

  const GetInvitationByEmailError(this.message);

  @override
  List<Object?> get props => [message];
}

// Get Invitation By Phone
class GetInvitationByPhoneLoading extends AttendeeState {}

class GetInvitationByPhoneSuccess extends AttendeeState {
  final EventInvitationModel invitation;

  const GetInvitationByPhoneSuccess(this.invitation);

  @override
  List<Object?> get props => [invitation];
}

class GetInvitationByPhoneError extends AttendeeState {
  final String message;

  const GetInvitationByPhoneError(this.message);

  @override
  List<Object?> get props => [message];
}

// Respond To Invitation
class RespondToInvitationLoading extends AttendeeState {}

class RespondToInvitationSuccess extends AttendeeState {
  final EventInvitationModel invitation;

  const RespondToInvitationSuccess(this.invitation);

  @override
  List<Object?> get props => [invitation];
}

class RespondToInvitationError extends AttendeeState {
  final String message;

  const RespondToInvitationError(this.message);

  @override
  List<Object?> get props => [message];
}

// Update Invitation Response
class UpdateInvitationResponseLoading extends AttendeeState {}

class UpdateInvitationResponseSuccess extends AttendeeState {
  final EventInvitationModel invitation;

  const UpdateInvitationResponseSuccess(this.invitation);

  @override
  List<Object?> get props => [invitation];
}

class UpdateInvitationResponseError extends AttendeeState {
  final String message;

  const UpdateInvitationResponseError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 2. EVENTS STATES
// ============================================

// Get My Accepted Events
class GetMyAcceptedEventsLoading extends AttendeeState {}

class GetMyAcceptedEventsSuccess extends AttendeeState {
  final List<EventModel> events;

  const GetMyAcceptedEventsSuccess(this.events);

  @override
  List<Object?> get props => [events];
}

class GetMyAcceptedEventsError extends AttendeeState {
  final String message;

  const GetMyAcceptedEventsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Get Upcoming Events
class GetUpcomingEventsLoading extends AttendeeState {}

class GetUpcomingEventsSuccess extends AttendeeState {
  final List<EventModel> events;

  const GetUpcomingEventsSuccess(this.events);

  @override
  List<Object?> get props => [events];
}

class GetUpcomingEventsError extends AttendeeState {
  final String message;

  const GetUpcomingEventsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Get Past Events
class GetPastEventsLoading extends AttendeeState {}

class GetPastEventsSuccess extends AttendeeState {
  final List<EventModel> events;

  const GetPastEventsSuccess(this.events);

  @override
  List<Object?> get props => [events];
}

class GetPastEventsError extends AttendeeState {
  final String message;

  const GetPastEventsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Get Event Details
class GetEventDetailsLoading extends AttendeeState {}

class GetEventDetailsSuccess extends AttendeeState {
  final EventModel event;

  const GetEventDetailsSuccess(this.event);

  @override
  List<Object?> get props => [event];
}

class GetEventDetailsError extends AttendeeState {
  final String message;

  const GetEventDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 3. STATISTICS STATES
// ============================================

// Get Attendee Stats
class GetAttendeeStatsLoading extends AttendeeState {}

class GetAttendeeStatsSuccess extends AttendeeState {
  final Map<String, dynamic> stats;

  const GetAttendeeStatsSuccess(this.stats);

  @override
  List<Object?> get props => [stats];
}

class GetAttendeeStatsError extends AttendeeState {
  final String message;

  const GetAttendeeStatsError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 4. LINK ATTENDEE STATES
// ============================================

// Link Attendee To Invitation
class LinkAttendeeToInvitationLoading extends AttendeeState {}

class LinkAttendeeToInvitationSuccess extends AttendeeState {
  final EventInvitationModel invitation;

  const LinkAttendeeToInvitationSuccess(this.invitation);

  @override
  List<Object?> get props => [invitation];
}

class LinkAttendeeToInvitationError extends AttendeeState {
  final String message;

  const LinkAttendeeToInvitationError(this.message);

  @override
  List<Object?> get props => [message];
}

// ============================================
// 5. NOTIFICATIONS STATES
// ============================================

class GetNotificationsLoading extends AttendeeState {}

class GetNotificationsSuccess extends AttendeeState {
  final List<Map<String, dynamic>> notifications;

  const GetNotificationsSuccess(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

class GetNotificationsError extends AttendeeState {
  final String message;

  const GetNotificationsError(this.message);

  @override
  List<Object?> get props => [message];
}

