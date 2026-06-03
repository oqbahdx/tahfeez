import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_token.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthToken>> login(String email, String password);
  Future<Either<Failure, User>> register({
    required String userName,
    required String password,
    required String confirmPassword,
    required String email,
    required String fullName,
    required int role,
  });
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, AuthToken>> refreshToken(String refreshToken);
  Future<Either<Failure, String?>> getAccessToken();
}
