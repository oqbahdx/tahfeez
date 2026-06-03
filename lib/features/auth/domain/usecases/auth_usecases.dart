import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_token.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, AuthToken>> call(String email, String password) {
    return repository.login(email, password);
  }
}

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String userName,
    required String password,
    required String confirmPassword,
    required String email,
    required String fullName,
    required int role,
  }) {
    return repository.register(
      userName: userName,
      password: password,
      confirmPassword: confirmPassword,
      email: email,
      fullName: fullName,
      role: role,
    );
  }
}

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.logout();
  }
}

class GetAccessTokenUseCase {
  final AuthRepository repository;

  GetAccessTokenUseCase(this.repository);

  Future<Either<Failure, String?>> call() {
    return repository.getAccessToken();
  }
}

class RefreshTokenUseCase {
  final AuthRepository repository;

  RefreshTokenUseCase(this.repository);

  Future<Either<Failure, AuthToken>> call(String refreshToken) {
    return repository.refreshToken(refreshToken);
  }
}
