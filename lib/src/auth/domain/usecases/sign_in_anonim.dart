import 'package:dartz/dartz.dart';
import 'package:to_doey/src/auth/domain/repos/auth_repo.dart';

class SignInAnonymously {
  final AuthRepository repository;

  SignInAnonymously(this.repository);

  Future<Either<Exception, String>> call() async {
    return await repository.signInAnonymously();
  }
}
