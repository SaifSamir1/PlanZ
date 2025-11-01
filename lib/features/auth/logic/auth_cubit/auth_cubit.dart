// lib/features/auth/presentation/cubit/auth_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plan_z/features/auth/data/auth_repo/auth_repo.dart';
import 'package:plan_z/features/auth/data/models/user_manager.dart';
import 'package:plan_z/features/auth/data/models/user_model.dart';
import 'package:plan_z/features/auth/logic/auth_cubit/auth_state.dart';


class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final UserManager _userManager = UserManager();

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
      (user) async {
        await _userManager.setUser(user); // ✅ Save to UserManager + Hive
        emit(AuthSignUpSuccess(user: user));
      },
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
      (user) async {
        await _userManager.setUser(user); // ✅ Save to UserManager + Hive
        emit(AuthSignInSuccess(user: user));
      },
    );
  }

  // ===== Sign Out Method =====
  Future<void> signOut() async {
    emit(const AuthSignOutLoading());
    
    final result = await _authRepository.signOut();
    
    result.fold(
      (failure) => emit(AuthSignOutError(message: failure.message)),
      (success) async {
        await _userManager.clearUser(); // ✅ Clear UserManager + Hive
        emit(const AuthSignOutSuccess());
      },
    );
  }

  // ===== Get Current User Method =====
  Future<void> getCurrentUser() async {
    emit(const AuthGetCurrentUserLoading());
    
    final result = await _authRepository.getCurrentUser();
    
    result.fold(
      (failure) => emit(AuthGetCurrentUserError(message: failure.message)),
      (user) async {
        if (user != null) {
          await _userManager.setUser(user); // ✅ Save to UserManager + Hive
        }
        emit(AuthGetCurrentUserSuccess(user: user));
      },
    );
  }

  // ===== Check Login Status Method =====
  Future<void> checkLoginStatus() async {
    emit(const AuthLoading());
    
    // ✅ Check from UserManager (Hive) first
    if (_userManager.isLoggedIn) {
      emit(AuthUserLoggedIn(user: _userManager.currentUser!));
      return;
    }

    // ✅ If not in storage, check from Firebase
    final result = await _authRepository.isUserLoggedIn();
    
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (isLoggedIn) async {
        if (isLoggedIn) {
          await _getCurrentUserAfterLoginCheck();
        } else {
          await _userManager.clearUser();
          emit(const AuthUserNotLoggedIn());
        }
      },
    );
  }

  // ===== Helper Method for Getting Current User After Login Check =====
  Future<void> _getCurrentUserAfterLoginCheck() async {
    final result = await _authRepository.getCurrentUser();
    
    result.fold(
      (failure) async {
        await _userManager.clearUser();
        emit(const AuthUserNotLoggedIn());
      },
      (user) async {
        if (user != null) {
          await _userManager.setUser(user);
          emit(AuthUserLoggedIn(user: user));
        } else {
          await _userManager.clearUser();
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
  
  bool get isUserAuthenticated {
    return state is AuthUserLoggedIn ||
        state is AuthSignInSuccess ||
        state is AuthSignUpSuccess;
  }

  UserModel? get currentUser {
    // ✅ Use UserManager instead of State
    return _userManager.currentUser;
  }

  bool get isLoading {
    return state is AuthLoading ||
        state is AuthSignUpLoading ||
        state is AuthSignInLoading ||
        state is AuthSignOutLoading ||
        state is AuthGetCurrentUserLoading;
  }

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
