import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:plan_z/core/error/failures.dart';
import 'package:plan_z/features/attandee_features/data/attandee_repo.dart';
import 'package:plan_z/features/attandee_features/models/attandee_model.dart';
import 'package:uuid/uuid.dart';

class AttendeeRepositoryImpl implements AttendeeRepository {
  final FirebaseFirestore _firestore;
  final Uuid _uuid;

  AttendeeRepositoryImpl({
    FirebaseFirestore? firestore,
    Uuid? uuid,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _uuid = uuid ?? const Uuid();

  static const String _collection = 'attendees';

  @override
  Future<Either<Failure, AttendeeModel>> createAttendee({
    required String name,
    required String email,
    required String phoneNumber,
    String? profileImageUrl,
  }) async {
    try {
      final id = _uuid.v4();
      final attendee = AttendeeModel(
        id: id,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        isActive: true,
        invitations: [],
        acceptedInvitations: [],
        declinedInvitations: [],
        attendedEvents: [],
        profileImageUrl: profileImageUrl,
        createdAt: DateTime.now(),
      );
      await _firestore.collection(_collection).doc(id).set(attendee.toJson());
      return Right(attendee);
    } catch (e) {
      return Left(ServerFailure('Failed to create attendee: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, AttendeeModel>> getAttendeeById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) {
        return const Left(ServerFailure('Attendee not found'));
      }
      return Right(AttendeeModel.fromJson(doc.data()!));
    } catch (e) {
      return Left(ServerFailure('Failed to fetch attendee: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateAttendee(AttendeeModel attendee) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(attendee.id)
          .update(attendee.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to update attendee: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAttendee(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to delete attendee: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<AttendeeModel>>> getAllAttendees() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      final attendees =
          snapshot.docs.map((doc) => AttendeeModel.fromJson(doc.data())).toList();
      return Right(attendees);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch attendees: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> addInvitation({
    required String attendeeId,
    required String invitationId,
  }) async {
    try {
      final doc = await _firestore.collection(_collection).doc(attendeeId).get();
      if (!doc.exists) {
        return const Left(ServerFailure('Attendee not found'));
      }
      final attendee = AttendeeModel.fromJson(doc.data()!);
      final updatedInvitations = List<String>.from(attendee.invitations)
        ..add(invitationId);
      final updatedAttendee = attendee.copyWith(invitations: updatedInvitations);
      await _firestore
          .collection(_collection)
          .doc(attendeeId)
          .update(updatedAttendee.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to add invitation: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> respondToInvitation({
    required String attendeeId,
    required String invitationId,
    required bool accepted,
  }) async {
    try {
      final doc = await _firestore.collection(_collection).doc(attendeeId).get();
      if (!doc.exists) {
        return const Left(ServerFailure('Attendee not found'));
      }
      final attendee = AttendeeModel.fromJson(doc.data()!);
      final updatedInvitations =
          List<String>.from(attendee.invitations)..remove(invitationId);
      final updatedAccepted = List<String>.from(attendee.acceptedInvitations);
      final updatedDeclined = List<String>.from(attendee.declinedInvitations);
      if (accepted) {
        updatedAccepted.add(invitationId);
      } else {
        updatedDeclined.add(invitationId);
      }
      final updatedAttendee = attendee.copyWith(
        invitations: updatedInvitations,
        acceptedInvitations: updatedAccepted,
        declinedInvitations: updatedDeclined,
      );
      await _firestore
          .collection(_collection)
          .doc(attendeeId)
          .update(updatedAttendee.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to respond to invitation: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> markEventAsAttended({
    required String attendeeId,
    required String eventId,
  }) async {
    try {
      final doc = await _firestore.collection(_collection).doc(attendeeId).get();
      if (!doc.exists) {
        return const Left(ServerFailure('Attendee not found'));
      }
      final attendee = AttendeeModel.fromJson(doc.data()!);
      final updatedEvents = List<String>.from(attendee.attendedEvents)
        ..add(eventId);
      final updatedAttendee = attendee.copyWith(attendedEvents: updatedEvents);
      await _firestore
          .collection(_collection)
          .doc(attendeeId)
          .update(updatedAttendee.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to mark event attended: ${e.toString()}'));
    }
  }
}
