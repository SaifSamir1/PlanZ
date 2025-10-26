import 'package:dartz/dartz.dart';
import 'package:plan_z/core/error/failures.dart';
import 'package:plan_z/features/attandee_features/models/attandee_model.dart';

abstract class AttendeeRepository {
  Future<Either<Failure, AttendeeModel>> createAttendee({
    required String name,
    required String email,
    required String phoneNumber,
    String? profileImageUrl,
  });

  Future<Either<Failure, AttendeeModel>> getAttendeeById(String id);

  Future<Either<Failure, void>> updateAttendee(AttendeeModel attendee);

  Future<Either<Failure, void>> deleteAttendee(String id);

  Future<Either<Failure, List<AttendeeModel>>> getAllAttendees();

  Future<Either<Failure, void>> addInvitation({
    required String attendeeId,
    required String invitationId,
  });

  Future<Either<Failure, void>> respondToInvitation({
    required String attendeeId,
    required String invitationId,
    required bool accepted,
  });

  Future<Either<Failure, void>> markEventAsAttended({
    required String attendeeId,
    required String eventId,
  });
}