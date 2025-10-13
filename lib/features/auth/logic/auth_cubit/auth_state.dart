// lib/features/auth/presentation/cubit/auth_state.dart
import 'package:equatable/equatable.dart';
import 'package:plan_z/features/auth/data/models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// ===== Initial State =====
class AuthInitial extends AuthState {
  const AuthInitial();
}

// ===== Loading States =====
class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSignUpLoading extends AuthState {
  const AuthSignUpLoading();
}

class AuthSignInLoading extends AuthState {
  const AuthSignInLoading();
}

class AuthSignOutLoading extends AuthState {
  const AuthSignOutLoading();
}

class AuthGetCurrentUserLoading extends AuthState {
  const AuthGetCurrentUserLoading();
}

// ===== Success States =====
class AuthSignUpSuccess extends AuthState {
  final UserModel user;
  
  const AuthSignUpSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthSignInSuccess extends AuthState {
  final UserModel user;
  
  const AuthSignInSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthSignOutSuccess extends AuthState {
  const AuthSignOutSuccess();
}

class AuthUserLoggedIn extends AuthState {
  final UserModel user;
  
  const AuthUserLoggedIn({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthUserNotLoggedIn extends AuthState {
  const AuthUserNotLoggedIn();
}

class AuthGetCurrentUserSuccess extends AuthState {
  final UserModel? user;
  
  const AuthGetCurrentUserSuccess({this.user});

  @override
  List<Object?> get props => [user];
}

class AuthGetUserByIdSuccess extends AuthState {
  final UserModel user;
  
  const AuthGetUserByIdSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

// ===== Error States =====
class AuthError extends AuthState {
  final String message;
  
  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthSignUpError extends AuthState {
  final String message;
  
  const AuthSignUpError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthSignInError extends AuthState {
  final String message;
  
  const AuthSignInError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthSignOutError extends AuthState {
  final String message;
  
  const AuthSignOutError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthGetCurrentUserError extends AuthState {
  final String message;
  
  const AuthGetCurrentUserError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthGetUserByIdError extends AuthState {
  final String message;
  
  const AuthGetUserByIdError({required this.message});

  @override
  List<Object?> get props => [message];
}
