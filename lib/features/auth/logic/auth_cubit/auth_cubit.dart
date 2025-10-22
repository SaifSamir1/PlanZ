// lib/features/auth/presentation/cubit/auth_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/features/auth/data/auth_repo/auth_repo.dart';
import 'package:plan_z/features/auth/data/models/user_model.dart';
import 'package:plan_z/features/auth/logic/auth_cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthInitial());

  // ===== Sign Up Method =====
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required UserType userType,
    String? phoneNumber,
    Map<String, dynamic>? additionalInfo,
  }) async {
    emit(const AuthSignUpLoading());

    final result = await _authRepository.signUp(
      name: name,
      email: email,
      password: password,
      userType: userType,
      phoneNumber: phoneNumber,
      additionalInfo: additionalInfo,
    );

    result.fold(
      (failure) => emit(AuthSignUpError(message: failure.message)),
      (user) => emit(AuthSignUpSuccess(user: user)),
    );
  }

  // ===== Sign In Method =====
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(const AuthSignInLoading());

    final result = await _authRepository.signIn(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => emit(AuthSignInError(message: failure.message)),
      (user) => emit(AuthSignInSuccess(user: user)),
    );
  }

  // ===== Sign Out Method =====
  Future<void> signOut() async {
    emit(const AuthSignOutLoading());

    final result = await _authRepository.signOut();

    result.fold(
      (failure) => emit(AuthSignOutError(message: failure.message)),
      (success) => emit(const AuthSignOutSuccess()),
    );
  }

  // ===== Get Current User Method =====
  Future<void> getCurrentUser() async {
    emit(const AuthGetCurrentUserLoading());

    final result = await _authRepository.getCurrentUser();

    result.fold(
      (failure) => emit(AuthGetCurrentUserError(message: failure.message)),
      (user) => emit(AuthGetCurrentUserSuccess(user: user)),
    );
  }

  // ===== Check Login Status Method =====
  Future<void> checkLoginStatus() async {
    emit(const AuthLoading());

    final result = await _authRepository.isUserLoggedIn();

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (isLoggedIn) async {
        if (isLoggedIn) {
          // إذا كان المستخدم مسجلاً، احصل على بياناته
          await _getCurrentUserAfterLoginCheck();
        } else {
          emit(const AuthUserNotLoggedIn());
        }
      },
    );
  }

  // ===== Helper Method for Getting Current User After Login Check =====
  Future<void> _getCurrentUserAfterLoginCheck() async {
    final result = await _authRepository.getCurrentUser();

    result.fold(
      (failure) => emit(const AuthUserNotLoggedIn()),
      (user) {
        if (user != null) {
          emit(AuthUserLoggedIn(user: user));
        } else {
          emit(const AuthUserNotLoggedIn());
        }
      },
    );
  }

  // ===== Get User By ID Method =====
  Future<void> getUserById(String userId) async {
    emit(const AuthLoading());

    final result = await _authRepository.getUserById(userId);

    result.fold(
      (failure) => emit(AuthGetUserByIdError(message: failure.message)),
      (user) => emit(AuthGetUserByIdSuccess(user: user)),
    );
  }

  // ===== Reset Auth State =====
  void resetAuthState() {
    emit(const AuthInitial());
  }

  // ===== Helper Methods for UI =====
  
  // التحقق من أن المستخدم مسجل دخول حالياً
  bool get isUserAuthenticated {
    return state is AuthUserLoggedIn ||
           state is AuthSignInSuccess ||
           state is AuthSignUpSuccess;
  }

  // جلب بيانات المستخدم الحالي من الـ state
  UserModel? get currentUser {
    if (state is AuthUserLoggedIn) {
      return (state as AuthUserLoggedIn).user;
    } else if (state is AuthSignInSuccess) {
      return (state as AuthSignInSuccess).user;
    } else if (state is AuthSignUpSuccess) {
      return (state as AuthSignUpSuccess).user;
    }
    return null;
  }

  // التحقق من أن العملية في حالة تحميل
  bool get isLoading {
    return state is AuthLoading ||
           state is AuthSignUpLoading ||
           state is AuthSignInLoading ||
           state is AuthSignOutLoading ||
           state is AuthGetCurrentUserLoading;
  }

  // جلب رسالة الخطأ الحالية
  String? get errorMessage {
    if (state is AuthError) {
      return (state as AuthError).message;
    } else if (state is AuthSignUpError) {
      return (state as AuthSignUpError).message;
    } else if (state is AuthSignInError) {
      return (state as AuthSignInError).message;
    } else if (state is AuthSignOutError) {
      return (state as AuthSignOutError).message;
    } else if (state is AuthGetCurrentUserError) {
      return (state as AuthGetCurrentUserError).message;
    } else if (state is AuthGetUserByIdError) {
      return (state as AuthGetUserByIdError).message;
    }
    return null;
  }
}
