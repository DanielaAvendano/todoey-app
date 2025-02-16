import 'package:dartz/dartz.dart';
import 'package:to_doey/src/auth/data/datasources/firebase_auth_service.dart';
import 'package:to_doey/src/auth/domain/repos/auth_repo.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService authService;

  AuthRepositoryImpl(this.authService);

  @override
  Future<Either<Exception, String>> signInAnonymously() async {
    try {
      final userId = await authService.signInAnonymously();
      return Right(userId);
    } catch (e) {
      return Left(Exception("Error al autenticar anónimamente"));
    }
  }

  @override
  Future<String> getUserId() async {
    try {
      final userId = await authService.getUserId();
      return userId;
    } catch (e) {
      rethrow;
    }
  }
}
