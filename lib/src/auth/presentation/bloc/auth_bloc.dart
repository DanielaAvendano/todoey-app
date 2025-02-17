import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/sign_in_anonim.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.signInAnonymously) : super(AuthInitial()) {
    on<SignInAnonymouslyEvent>(_onSignInAnonymously);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  final SignInAnonymously signInAnonymously;

  Future<void> _onSignInAnonymously(
      SignInAnonymouslyEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signInAnonymously();
    result.fold(
      (error) => emit(AuthError(error.toString())),
      (userId) => emit(Authenticated(userId)),
    );
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      emit(Authenticated(user.uid));
    } else {
      emit(AuthInitial());
    }
  }
}
