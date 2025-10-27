


// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';
import 'package:plan_z/core/error/failures.dart';
import 'package:plan_z/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  // تسجيل حساب جديد
  Future<Either<Failure, UserModel>> signUp({
    required String name,
    required String email,
    required String password,
    required UserType userType,
    String? phoneNumber,
    Map<String, dynamic>? additionalInfo,
  });

  // تسجيل الدخول
  Future<Either<Failure, UserModel>> signIn({
    required String email,
    required String password,
  });

  // تسجيل الخروج
  Future<Either<Failure, void>> signOut();

  // جلب المستخدم الحالي
  Future<Either<Failure, UserModel?>> getCurrentUser();

  // التحقق من حالة تسجيل الدخول
  Future<Either<Failure, bool>> isUserLoggedIn();

  // جلب مستخدم بالمعرف
  Future<Either<Failure, UserModel>> getUserById(String userId);
}
