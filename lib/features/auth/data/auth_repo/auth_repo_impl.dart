// // lib/features/auth/data/repositories/auth_repository_impl.dart
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:plan_z/features/auth/data/models/user_model.dart';

// class AuthRepositoryImpl implements AuthRepository {
//   final Firebasflutter pub add firebase_autheAuth _firebaseAuth;
//   final FirebaseFirestore _firestore;
//   final Uuid _uuid;

//   AuthRepositoryImpl({
//     FirebaseAuth? firebaseAuth,
//     FirebaseFirestore? firestore,
//     Uuid? uuid,
//   })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
//         _firestore = firestore ?? FirebaseFirestore.instance,
//         _uuid = uuid ?? const Uuid();

//   @override
//   Future<Either<Failure, UserModel>> signUp({
//     required String name,
//     required String email,
//     required String password,
//     required UserType userType,
//     String? phoneNumber,
//     Map<String, dynamic>? additionalInfo,
//   }) async {
//     try {
//       // إنشاء مستخدم في Firebase Auth
//       final credential = await _firebaseAuth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       if (credential.user == null) {
//         return const Left(AuthFailure('Failed to create user account'));
//       }

//       // تحديث الاسم في Firebase Auth
//       await credential.user!.updateDisplayName(name);

//       // إنشاء ID مخصص للمستخدم
//       final customUserId = _uuid.v4();

//       // إنشاء نموذج المستخدم
//       final userModel = UserModel(
//         id: customUserId,
//         name: name,
//         email: email,
//         userType: userType,
//         phoneNumber: phoneNumber,
//         isActive: true,
//         additionalInfo: additionalInfo,
//       );

//       // تحديد اسم الكولكشن حسب نوع المستخدم
//       final collectionName = _getCollectionName(userType);

//       // حفظ بيانات المستخدم في Firestore
//       await _firestore
//           .collection(collectionName)
//           .doc(customUserId)
//           .set(userModel.toJson());

//       // حفظ جلسة المستخدم محلياً
//       await AuthHiveService.saveUserSession(
//         userId: customUserId,
//         userType: userType.name,
//       );

//       return Right(userModel);
//     } on FirebaseAuthException catch (e) {
//       return Left(AuthFailure(_getAuthErrorMessage(e.code)));
//     } catch (e) {
//       return Left(ServerFailure('Failed to sign up: ${e.toString()}'));
//     }
//   }

//   @override
//   Future<Either<Failure, UserModel>> signIn({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       // تسجيل الدخول في Firebase Auth
//       final credential = await _firebaseAuth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       if (credential.user == null) {
//         return const Left(AuthFailure('Failed to sign in'));
//       }

//       // البحث عن المستخدم في جميع الكولكشنز
//       UserModel? userModel;

//       for (final userType in UserType.values) {
//         final collectionName = _getCollectionName(userType);
//         final querySnapshot = await _firestore
//             .collection(collectionName)
//             .where('email', isEqualTo: email)
//             .limit(1)
//             .get();

//         if (querySnapshot.docs.isNotEmpty) {
//           userModel = UserModel.fromJson(querySnapshot.docs.first.data());
//           break;
//         }
//       }

//       if (userModel == null) {
//         await _firebaseAuth.signOut();
//         return const Left(AuthFailure('User data not found'));
//       }

//       // التحقق من أن المستخدم نشط
//       if (!userModel.isActive) {
//         await _firebaseAuth.signOut();
//         return const Left(AuthFailure('Account is deactivated'));
//       }

//       // حفظ جلسة المستخدم محلياً
//       await AuthHiveService.saveUserSession(
//         userId: userModel.id,
//         userType: userModel.userType.name,
//       );

//       return Right(userModel);
//     } on FirebaseAuthException catch (e) {
//       return Left(AuthFailure(_getAuthErrorMessage(e.code)));
//     } catch (e) {
//       return Left(ServerFailure('Failed to sign in: ${e.toString()}'));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> signOut() async {
//     try {
//       await _firebaseAuth.signOut();
//       await AuthHiveService.clearUserSession();
//       return const Right(null);
//     } catch (e) {
//       return Left(ServerFailure('Failed to sign out: ${e.toString()}'));
//     }
//   }

//   @override
//   Future<Either<Failure, UserModel?>> getCurrentUser() async {
//     try {
//       final userId = AuthHiveService.getCachedUserId();
//       final userTypeString = AuthHiveService.getCachedUserType();

//       if (userId == null || userTypeString == null) {
//         return const Right(null);
//       }

//       // تحويل النص إلى UserType
//       final userType = UserType.values.firstWhere(
//         (type) => type.name == userTypeString,
//         orElse: () => UserType.attendee,
//       );

//       final collectionName = _getCollectionName(userType);
//       final doc = await _firestore.collection(collectionName).doc(userId).get();

//       if (!doc.exists) {
//         await AuthHiveService.clearUserSession();
//         return const Right(null);
//       }

//       final userModel = UserModel.fromJson(doc.data()!);
//       return Right(userModel);
//     } catch (e) {
//       return Left(ServerFailure('Failed to get current user: ${e.toString()}'));
//     }
//   }

//   @override
//   Future<Either<Failure, bool>> isUserLoggedIn() async {
//     try {
//       final isLoggedInHive = AuthHiveService.isUserLoggedIn();
//       final firebaseUser = _firebaseAuth.currentUser;

//       // التحقق من أن المستخدم مسجل في Firebase Auth أيضاً
//       if (isLoggedInHive && firebaseUser != null) {
//         return const Right(true);
//       } else {
//         // مسح الجلسة المحلية إذا لم يكن مسجلاً في Firebase
//         await AuthHiveService.clearUserSession();
//         return const Right(false);
//       }
//     } catch (e) {
//       return Left(CacheFailure('Failed to check login status: ${e.toString()}'));
//     }
//   }

//   @override
//   Future<Either<Failure, UserModel>> getUserById(String userId) async {
//     try {
//       // البحث في جميع الكولكشنز
//       for (final userType in UserType.values) {
//         final collectionName = _getCollectionName(userType);
//         final doc = await _firestore.collection(collectionName).doc(userId).get();

//         if (doc.exists) {
//           final userModel = UserModel.fromJson(doc.data()!);
//           return Right(userModel);
//         }
//       }

//       return const Left(ServerFailure('User not found'));
//     } catch (e) {
//       return Left(ServerFailure('Failed to get user: ${e.toString()}'));
//     }
//   }

//   // ================ Helper Methods ================

//   // دالة مساعدة لتحديد اسم الكولكشن حسب نوع المستخدم
//   String _getCollectionName(UserType userType) {
//     switch (userType) {
//       case UserType.vendor:
//         return FirebaseCollections.vendors;
//       case UserType.eventOwner:
//         return FirebaseCollections.eventOwners;
//       case UserType.attendee:
//         return FirebaseCollections.attendees;
//     }
//   }

//   // دالة مساعدة لتحويل أخطاء Firebase Auth إلى رسائل مفهومة
//   String _getAuthErrorMessage(String errorCode) {
//     switch (errorCode) {
//       case 'weak-password':
//         return 'The password provided is too weak.';
//       case 'email-already-in-use':
//         return 'The account already exists for that email.';
//       case 'user-not-found':
//         return 'No user found for that email.';
//       case 'wrong-password':
//         return 'Wrong password provided for that user.';
//       case 'invalid-email':
//         return 'The email address is not valid.';
//       case 'user-disabled':
//         return 'This user account has been disabled.';
//       case 'too-many-requests':
//         return 'Too many requests. Try again later.';
//       case 'operation-not-allowed':
//         return 'Email/password accounts are not enabled.';
//       case 'network-request-failed':
//         return 'Network error occurred. Please check your connection.';
//       case 'invalid-credential':
//         return 'The supplied auth credential is malformed or has expired.';
//       default:
//         return 'An authentication error occurred. Please try again.';
//     }
//   }
// }
