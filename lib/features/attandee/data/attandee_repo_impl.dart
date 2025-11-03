// lib/features/attendee/data/repositories/attendee_repository_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:plan_z/core/constants/constants.dart';
import 'package:plan_z/core/error/failures.dart';
import 'package:plan_z/features/attandee/data/attandee_repo.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_invitation_model.dart';
import 'package:plan_z/features/new_owner_features/create_event_screen/data/models/event_model.dart';

class AttendeeRepositoryImpl implements AttendeeRepository {
  final FirebaseFirestore _firestore;

  AttendeeRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // ============================================
  // 1. INVITATIONS MANAGEMENT
  // ============================================

  @override
  Future<Either<Failure, List<EventInvitationModel>>> getMyInvitations({
    required String attendeeId,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(FirebaseCollections.eventInvitations)
          .where('attendeeId', isEqualTo: attendeeId)
          .get();

      final invitations = snapshot.docs
          .map(
            (doc) => EventInvitationModel.fromJson({
              ...doc.data(),
              'invitationId': doc.id,
            }),
          )
          .toList();

      return Right(invitations);
    } catch (e) {
      return Left(FirestoreFailure(message: 'Failed to load invitations: $e'));
    }
  }

  @override
  Future<Either<Failure, List<EventInvitationModel>>> getInvitationsByStatus({
    required String attendeeId,
    required InvitationStatus status,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(FirebaseCollections.eventInvitations)
          .where('attendeeId', isEqualTo: attendeeId)
          .where('status', isEqualTo: status.name)
          .get();

      final invitations = snapshot.docs
          .map(
            (doc) => EventInvitationModel.fromJson({
              ...doc.data(),
              'invitationId': doc.id,
            }),
          )
          .toList();

      return Right(invitations);
    } catch (e) {
      return Left(FirestoreFailure(message: 'Failed to load invitations: $e'));
    }
  }

  @override
  Future<Either<Failure, EventInvitationModel>> getInvitationById({
    required String invitationId,
  }) async {
    try {
      final doc = await _firestore
          .collection(FirebaseCollections.eventInvitations)
          .doc(invitationId)
          .get();

      if (!doc.exists) {
        return Left(FirestoreFailure(message: 'Invitation not found'));
      }

      final invitation = EventInvitationModel.fromJson({
        ...doc.data()!,
        'invitationId': doc.id,
      });

      return Right(invitation);
    } catch (e) {
      return Left(FirestoreFailure(message: 'Failed to load invitation: $e'));
    }
  }

  @override
  Future<Either<Failure, EventInvitationModel>> getInvitationByEmail({
    required String email,
    required String invitationId,
  }) async {
    try {
      final doc = await _firestore
          .collection(FirebaseCollections.eventInvitations)
          .doc(invitationId)
          .get();

      if (!doc.exists) {
        return Left(FirestoreFailure(message: 'Invitation not found'));
      }

      final invitation = EventInvitationModel.fromJson({
        ...doc.data()!,
        'invitationId': doc.id,
      });

      if (invitation.inviteeEmail?.toLowerCase() != email.toLowerCase()) {
        return Left(
          FirestoreFailure(message: 'Email does not match invitation'),
        );
      }

      return Right(invitation);
    } catch (e) {
      return Left(FirestoreFailure(message: 'Failed to load invitation: $e'));
    }
  }

  @override
  Future<Either<Failure, EventInvitationModel>> getInvitationByPhone({
    required String phone,
    required String invitationId,
  }) async {
    try {
      final doc = await _firestore
          .collection(FirebaseCollections.eventInvitations)
          .doc(invitationId)
          .get();

      if (!doc.exists) {
        return Left(FirestoreFailure(message: 'Invitation not found'));
      }

      final invitation = EventInvitationModel.fromJson({
        ...doc.data()!,
        'invitationId': doc.id,
      });

      if (invitation.inviteePhone != phone) {
        return Left(
          FirestoreFailure(message: 'Phone does not match invitation'),
        );
      }

      return Right(invitation);
    } catch (e) {
      return Left(FirestoreFailure(message: 'Failed to load invitation: $e'));
    }
  }

  @override
  Future<Either<Failure, EventInvitationModel>> respondToInvitation({
    required String invitationId,
    required InvitationStatus status,
    String? responseMessage,
    int? confirmedGuestCount,
  }) async {
    try {
      final invitationRef = _firestore
          .collection(FirebaseCollections.eventInvitations)
          .doc(invitationId);

      final invitationDoc = await invitationRef.get();
      if (!invitationDoc.exists) {
        return Left(FirestoreFailure(message: 'Invitation not found'));
      }

      final updateData = {
        'status': status.name,
        'respondedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (responseMessage != null) {
        updateData['responseMessage'] = responseMessage;
      }
      if (confirmedGuestCount != null) {
        updateData['confirmedGuestCount'] = confirmedGuestCount;
      }

      await invitationRef.update(updateData);

      final updatedDoc = await invitationRef.get();
      final updatedInvitation = EventInvitationModel.fromJson({
        ...updatedDoc.data()!,
        'invitationId': updatedDoc.id,
      });

      return Right(updatedInvitation);
    } catch (e) {
      return Left(
        FirestoreFailure(message: 'Failed to respond to invitation: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, EventInvitationModel>> updateInvitationResponse({
    required String invitationId,
    required InvitationStatus status,
    String? responseMessage,
    int? confirmedGuestCount,
  }) async {
    return respondToInvitation(
      invitationId: invitationId,
      status: status,
      responseMessage: responseMessage,
      confirmedGuestCount: confirmedGuestCount,
    );
  }

  // ============================================
  // 2. EVENTS MANAGEMENT
  // ============================================

  @override
  Future<Either<Failure, List<EventModel>>> getMyAcceptedEvents({
    required String attendeeId,
  }) async {
    try {
      final invitationsSnapshot = await _firestore
          .collection(FirebaseCollections.eventInvitations)
          .where('attendeeId', isEqualTo: attendeeId)
          .where('status', isEqualTo: InvitationStatus.accepted.name)
          .get();

      if (invitationsSnapshot.docs.isEmpty) {
        return const Right([]);
      }

      final eventIds = invitationsSnapshot.docs
          .map((doc) => doc.data()['eventId'] as String)
          .toList();

      final List<EventModel> events = [];
      for (int i = 0; i < eventIds.length; i += 10) {
        final batch = eventIds.skip(i).take(10).toList();
        final eventsSnapshot = await _firestore
            .collection(FirebaseCollections.events)
            .where(FieldPath.documentId, whereIn: batch)
            .get();

        events.addAll(
          eventsSnapshot.docs.map(
            (doc) => EventModel.fromJson({...doc.data(), 'eventId': doc.id}),
          ),
        );
      }

      events.sort((a, b) => a.eventDate.compareTo(b.eventDate));
      return Right(events);
    } catch (e) {
      return Left(FirestoreFailure(message: 'Failed to load events: $e'));
    }
  }

  @override
  Future<Either<Failure, List<EventModel>>> getUpcomingEvents({
    required String attendeeId,
  }) async {
    try {
      final result = await getMyAcceptedEvents(attendeeId: attendeeId);
      return result.fold((failure) => Left(failure), (events) {
        final now = DateTime.now();
        final upcomingEvents = events
            .where((event) => event.eventDate.isAfter(now))
            .toList();
        return Right(upcomingEvents);
      });
    } catch (e) {
      return Left(
        FirestoreFailure(message: 'Failed to load upcoming events: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<EventModel>>> getPastEvents({
    required String attendeeId,
  }) async {
    try {
      final result = await getMyAcceptedEvents(attendeeId: attendeeId);
      return result.fold((failure) => Left(failure), (events) {
        final now = DateTime.now();
        final pastEvents = events
            .where((event) => event.eventDate.isBefore(now))
            .toList();
        return Right(pastEvents);
      });
    } catch (e) {
      return Left(FirestoreFailure(message: 'Failed to load past events: $e'));
    }
  }

  @override
  Future<Either<Failure, EventModel>> getEventDetails({
    required String eventId,
  }) async {
    try {
      final doc = await _firestore
          .collection(FirebaseCollections.events)
          .doc(eventId)
          .get();

      if (!doc.exists) {
        return Left(FirestoreFailure(message: 'Event not found'));
      }

      final event = EventModel.fromJson({...doc.data()!, 'eventId': doc.id});

      return Right(event);
    } catch (e) {
      return Left(
        FirestoreFailure(message: 'Failed to load event details: $e'),
      );
    }
  }

  // ============================================
  // 3. STATISTICS
  // ============================================

  @override
  Future<Either<Failure, Map<String, dynamic>>> getAttendeeStats({
    required String attendeeId,
  }) async {
    try {
      final invitationsSnapshot = await _firestore
          .collection(FirebaseCollections.eventInvitations)
          .where('attendeeId', isEqualTo: attendeeId)
          .get();

      final invitations = invitationsSnapshot.docs
          .map(
            (doc) => EventInvitationModel.fromJson({
              ...doc.data(),
              'invitationId': doc.id,
            }),
          )
          .toList();

      final total = invitations.length;
      final accepted = invitations
          .where((inv) => inv.status == InvitationStatus.accepted)
          .length;
      final rejected = invitations
          .where((inv) => inv.status == InvitationStatus.rejected)
          .length;
      final pending = invitations
          .where((inv) => inv.status == InvitationStatus.pending)
          .length;
      final maybeAttending = invitations
          .where((inv) => inv.status == InvitationStatus.maybeAttending)
          .length;

      int upcomingEvents = 0;
      int pastEvents = 0;

      for (final invitation in invitations) {
        if (invitation.status == InvitationStatus.accepted) {
          try {
            final eventDoc = await _firestore
                .collection(FirebaseCollections.events)
                .doc(invitation.eventId)
                .get();

            if (eventDoc.exists) {
              final event = EventModel.fromJson({
                ...eventDoc.data()!,
                'eventId': eventDoc.id,
              });

              if (event.eventDate.isAfter(DateTime.now())) {
                upcomingEvents++;
              } else {
                pastEvents++;
              }
            }
          } catch (e) {
            print('Error loading event: $e');
          }
        }
      }

      final stats = {
        'totalInvitations': total,
        'acceptedInvitations': accepted,
        'rejectedInvitations': rejected,
        'pendingInvitations': pending,
        'maybeAttendingInvitations': maybeAttending,
        'upcomingEvents': upcomingEvents,
        'pastEvents': pastEvents,
      };

      return Right(stats);
    } catch (e) {
      return Left(FirestoreFailure(message: 'Failed to load stats: $e'));
    }
  }

  // ============================================
  // 4. LINK ATTENDEE TO INVITATION
  // ============================================

  @override
  Future<Either<Failure, EventInvitationModel>> linkAttendeeToInvitation({
    required String invitationId,
    required String attendeeId,
  }) async {
    try {
      final invitationRef = _firestore
          .collection(FirebaseCollections.eventInvitations)
          .doc(invitationId);

      await invitationRef.update({
        'attendeeId': attendeeId,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final updatedDoc = await invitationRef.get();
      final updatedInvitation = EventInvitationModel.fromJson({
        ...updatedDoc.data()!,
        'invitationId': updatedDoc.id,
      });

      return Right(updatedInvitation);
    } catch (e) {
      return Left(FirestoreFailure(message: 'Failed to link attendee: $e'));
    }
  }

  @override
  Stream<List<Map<String, dynamic>>> getAttendeeNotifications(
    String attendeeId,
  ) {
    return FirebaseFirestore.instance
        .collection('notifications')
        .where('receiverId', isEqualTo: attendeeId)
        .where('receiverRole', isEqualTo: 'attendee')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList(),
        );
  }

  @override
  Future<Either<Failure, Unit>> sendAttendeeNotification({
    required String receiverId,
    required String title,
    required String body,
  }) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();

      await _firestore.collection('notifications').add({
        'receiverId': receiverId,
        'title': title,
        'body': body,
        'tokens': token != null ? [token] : [],
        'createdAt': DateTime.now(),
      });
      return Right(unit);
    } catch (e) {
      print("❌ Error sending notification: $e");
      return Left(FirestoreFailure(message: 'Failed to send notification: $e'));
    }
  }
}
