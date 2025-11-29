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
}
