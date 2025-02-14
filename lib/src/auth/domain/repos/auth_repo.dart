import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  const AuthRepository();

  Future<Either<Exception, String>> signInAnonymously();
}
