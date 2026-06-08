import 'package:equatable/equatable.dart';

import '../../domain/entities/auth_token.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthSplash extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final AuthToken token;
  final String role;
  final String? userName;

  const AuthAuthenticated(this.token, {
    required this.role,
    this.userName,
  });

  @override
  List<Object?> get props => [token, role, userName];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}
