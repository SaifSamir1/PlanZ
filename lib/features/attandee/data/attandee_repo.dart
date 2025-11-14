// lib/features/attendee/data/repositories/i_attendee_repository.dart

import 'package:dartz/dartz.dart';
import 'package:plan_z/core/error/failures.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_invitation_model.dart';
import 'package:plan_z/features/event_owners/create_event_screen/data/models/event_model.dart';

abstract class AttendeeRepository {
  // ============================================
  // 1. INVITATIONS MANAGEMENT
  // ============================================

  /// Get all invitations for an attendee (by attendeeId)
  Future<Either<Failure, List<EventInvitationModel>>> getMyInvitations({
    required String attendeeId,
  });

  /// Get invitations filtered by status
  Future<Either<Failure, List<EventInvitationModel>>> getInvitationsByStatus({
    required String attendeeId,
    required InvitationStatus status,
  });

  /// Get a single invitation by ID (for deep links)
  Future<Either<Failure, EventInvitationModel>> getInvitationById({
    required String invitationId,
  });

  /// Get invitation by email (for non-registered users)
  Future<Either<Failure, EventInvitationModel>> getInvitationByEmail({
    required String email,
    required String invitationId,
  });

  /// Get invitation by phone (for non-registered users)
  Future<Either<Failure, EventInvitationModel>> getInvitationByPhone({
    required String phone,
    required String invitationId,
  });

  /// Respond to an invitation (Accept/Reject/Maybe)
  Future<Either<Failure, EventInvitationModel>> respondToInvitation({
    required String invitationId,
    required InvitationStatus status,
    String? responseMessage,
    int? confirmedGuestCount,
  });

  /// Update invitation response (change answer)
  Future<Either<Failure, EventInvitationModel>> updateInvitationResponse({
    required String invitationId,
    required InvitationStatus status,
    String? responseMessage,
    int? confirmedGuestCount,
  });

  // ============================================
  // 2. EVENTS MANAGEMENT
  // ============================================

  /// Get all accepted events for an attendee
  Future<Either<Failure, List<EventModel>>> getMyAcceptedEvents({
    required String attendeeId,
  });

  /// Get upcoming events (accepted invitations with future dates)
  Future<Either<Failure, List<EventModel>>> getUpcomingEvents({
    required String attendeeId,
  });

  /// Get past events (accepted invitations with past dates)
  Future<Either<Failure, List<EventModel>>> getPastEvents({
    required String attendeeId,
  });

  /// Get event details by ID
  Future<Either<Failure, EventModel>> getEventDetails({
    required String eventId,
  });

  // ============================================
  // 3. STATISTICS
  // ============================================

  /// Get attendee statistics
  Future<Either<Failure, Map<String, dynamic>>> getAttendeeStats({
    required String attendeeId,
  });

  // ============================================
  // 4. LINK ATTENDEE TO INVITATION (For Sign-Up)
  // ============================================

  /// Link a registered attendee to an invitation (after sign-up)
  Future<Either<Failure, EventInvitationModel>> linkAttendeeToInvitation({
    required String invitationId,
    required String attendeeId,
  });
}
