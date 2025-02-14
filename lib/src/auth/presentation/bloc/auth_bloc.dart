import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/sign_in_anonim.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.signInAnonymously) : super(AuthInitial()) {
    on<SignInAnonymouslyEvent>(_onSignInAnonymously);
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
}
