part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String userId;

  Authenticated(this.userId);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
