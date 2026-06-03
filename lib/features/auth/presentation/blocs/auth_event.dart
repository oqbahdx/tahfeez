import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  const LoginEvent({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String userName;
  final String password;
  final String confirmPassword;
  final String email;
  final String fullName;
  final int role;
  const RegisterEvent({
    required this.userName,
    required this.password,
    required this.confirmPassword,
    required this.email,
    required this.fullName,
    required this.role,
  });
  @override
  List<Object?> get props => [userName, password, confirmPassword, email, fullName, role];
}

class LogoutEvent extends AuthEvent {}

class CheckAuthEvent extends AuthEvent {}

class RefreshTokenEvent extends AuthEvent {
  final String refreshToken;
  const RefreshTokenEvent(this.refreshToken);
  @override
  List<Object?> get props => [refreshToken];
}
