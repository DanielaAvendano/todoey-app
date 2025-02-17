part of 'auth_bloc.dart';

abstract class AuthEvent {}

class SignInAnonymouslyEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}
