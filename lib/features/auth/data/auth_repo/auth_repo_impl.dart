// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:plan_z/features/auth/data/auth_repo/auth_repo.dart';
import 'package:uuid/uuid.dart';
import 'package:plan_z/core/constants/constants.dart';
import 'package:plan_z/core/error/failures.dart';
import 'package:plan_z/core/services/auth_hive_service.dart';
import 'package:plan_z/features/auth/data/models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final Uuid _uuid;

  AuthRepositoryImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    Uuid? uuid,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _uuid = uuid ?? const Uuid();

  @override
  Future<Either<Failure, UserModel>> signUp({
    required String name,
    required String email,
    required String password,
    required UserType userType,
    String? phoneNumber,
    Map<String, dynamic>? additionalInfo,
  }) async {
    try {
      // إنشاء مستخدم في Firebase Auth
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        return const Left(AuthFailure('Failed to create user account'));
      }
      final fcmToken = await FirebaseMessaging.instance.getToken();
      // تحديث الاسم في Firebase Auth
      await credential.user!.updateDisplayName(name);

      // إنشاء ID مخصص للمستخدم
      final customUserId = _uuid.v4();

      // إنشاء نموذج المستخدم
      final userModel = UserModel(
        id: customUserId,
        name: name,
        email: email,
        userType: userType,
        phoneNumber: phoneNumber,
        isActive: true,
        additionalInfo: additionalInfo,
        fcmToken: fcmToken,
      );

      // تحديد اسم الكولكشن حسب نوع المستخدم
      final collectionName = _getCollectionName(userType);

      // حفظ بيانات المستخدم في Firestore
      await _firestore
          .collection(collectionName)
          .doc(customUserId)
          .set(userModel.toJson());

      // حفظ جلسة المستخدم محلياً
      await AuthHiveService.saveUserSession(
        userId: customUserId,
        userType: userType.name,
      );

      return Right(userModel);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_getAuthErrorMessage(e.code)));
    } catch (e) {
      return Left(ServerFailure('Failed to sign up: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 [AuthRepo.signIn] Starting login for email: $email');

      // تسجيل الدخول في Firebase Auth
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        print('❌ [AuthRepo.signIn] Firebase Auth credential.user is null');
        return const Left(AuthFailure('Failed to sign in'));
      }

      print(
        '✅ [AuthRepo.signIn] Firebase Auth successful for: ${credential.user!.email}',
      );

      // البحث عن المستخدم في جميع الكولكشنز
      UserModel? userModel;
      String?
      actualCollectionName; // ✅ Track the actual collection where user was found

      for (final userType in UserType.values) {
        final collectionName = _getCollectionName(userType);
        print(
          '🔍 [AuthRepo.signIn] Searching in collection: $collectionName for email: $email',
        );

        final querySnapshot = await _firestore
            .collection(collectionName)
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        print(
          '📊 [AuthRepo.signIn] Found ${querySnapshot.docs.length} document(s) in $collectionName',
        );

        if (querySnapshot.docs.isNotEmpty) {
          try {
            final docData = querySnapshot.docs.first.data();
            print(
              '📄 [AuthRepo.signIn] Document data from $collectionName: $docData',
            );

            userModel = UserModel.fromJson(docData);
            actualCollectionName =
                collectionName; // ✅ Store the actual collection name
            print(
              '✅ [AuthRepo.signIn] Successfully parsed UserModel: ${userModel.toString()}',
            );
            print(
              '📍 [AuthRepo.signIn] User found in collection: $actualCollectionName',
            );
            break;
          } catch (e) {
            print(
              '❌ [AuthRepo.signIn] Error parsing UserModel from $collectionName: $e',
            );
            throw e;
          }
        }
      }

      if (userModel == null || actualCollectionName == null) {
        print(
          '❌ [AuthRepo.signIn] User data not found in any collection for email: $email',
        );
        await _firebaseAuth.signOut();
        return const Left(AuthFailure('User data not found'));
      }

      // التحقق من أن المستخدم نشط
      if (!userModel.isActive) {
        print(
          '❌ [AuthRepo.signIn] User account is deactivated: ${userModel.id}',
        );
        await _firebaseAuth.signOut();
        return const Left(AuthFailure('Account is deactivated'));
      }

      print('✅ [AuthRepo.signIn] User is active, proceeding with login');

      // حفظ جلسة المستخدم محلياً
      await AuthHiveService.saveUserSession(
        userId: userModel.id,
        userType: userModel.userType.name,
      );
      print('✅ [AuthRepo.signIn] User session saved to Hive');

      // ✅ Update FCM token using the ACTUAL collection where user was found
      try {
        final fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          print(
            '🔄 [AuthRepo.signIn] Updating FCM token in collection: $actualCollectionName',
          );
          await _firestore
              .collection(actualCollectionName)
              .doc(userModel.id)
              .update({
                'fcmToken': fcmToken,
                'fcmTokenUpdatedAt': Timestamp.now(),
              });
          print('✅ [AuthRepo.signIn] FCM token updated successfully');
        }
      } catch (e) {
        // Don't fail login if FCM token update fails
        print('⚠️ [AuthRepo.signIn] Failed to update FCM token: $e');
      }

      print('🎉 [AuthRepo.signIn] Login successful for user: ${userModel.id}');
      return Right(userModel);
    } on FirebaseAuthException catch (e) {
      print(
        '❌ [AuthRepo.signIn] FirebaseAuthException: ${e.code} - ${e.message}',
      );
      return Left(AuthFailure(_getAuthErrorMessage(e.code)));
    } catch (e) {
      print('❌ [AuthRepo.signIn] Unexpected error: $e');
      return Left(ServerFailure('Failed to sign in: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await AuthHiveService.clearUserSession();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to sign out: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    try {
      final userId = AuthHiveService.getCachedUserId();
      final userTypeString = AuthHiveService.getCachedUserType();

      if (userId == null || userTypeString == null) {
        return const Right(null);
      }

      // تحويل النص إلى UserType
      final userType = UserType.values.firstWhere(
        (type) => type.name == userTypeString,
        orElse: () => UserType.attendee,
      );

      final collectionName = _getCollectionName(userType);
      final doc = await _firestore.collection(collectionName).doc(userId).get();

      if (!doc.exists) {
        await AuthHiveService.clearUserSession();
        return const Right(null);
      }

      final userModel = UserModel.fromJson(doc.data()!);
      return Right(userModel);
    } catch (e) {
      return Left(ServerFailure('Failed to get current user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> isUserLoggedIn() async {
    try {
      final isLoggedInHive = AuthHiveService.isUserLoggedIn();
      final firebaseUser = _firebaseAuth.currentUser;

      // التحقق من أن المستخدم مسجل في Firebase Auth أيضاً
      if (isLoggedInHive && firebaseUser != null) {
        return const Right(true);
      } else {
        // مسح الجلسة المحلية إذا لم يكن مسجلاً في Firebase
        await AuthHiveService.clearUserSession();
        return const Right(false);
      }
    } catch (e) {
      return Left(
        CacheFailure('Failed to check login status: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUserById(String userId) async {
    try {
      // البحث في جميع الكولكشنز
      for (final userType in UserType.values) {
        final collectionName = _getCollectionName(userType);
        final doc = await _firestore
            .collection(collectionName)
            .doc(userId)
            .get();

        if (doc.exists) {
          final userModel = UserModel.fromJson(doc.data()!);
          return Right(userModel);
        }
      }

      return const Left(ServerFailure('User not found'));
    } catch (e) {
      return Left(ServerFailure('Failed to get user: ${e.toString()}'));
    }
  }

  // ================ Helper Methods ================

  // دالة مساعدة لتحديد اسم الكولكشن حسب نوع المستخدم
  String _getCollectionName(UserType userType) {
    switch (userType) {
      case UserType.vendor:
        return FirebaseCollections.vendors;
      case UserType.eventOwner:
        return FirebaseCollections.eventOwners;
      case UserType.attendee:
        return FirebaseCollections.attendees;
      case UserType.admin:
        return FirebaseCollections.admins; // ✅ Add this
    }
  }

  // دالة مساعدة لتحويل أخطاء Firebase Auth إلى رسائل مفهومة
  String _getAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'network-request-failed':
        return 'Network error occurred. Please check your connection.';
      case 'invalid-credential':
        return 'The supplied auth credential is malformed or has expired.';
      default:
        return 'An authentication error occurred. Please try again.';
    }
  }
}
