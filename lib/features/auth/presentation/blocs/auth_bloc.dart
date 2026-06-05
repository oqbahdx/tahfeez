import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../domain/entities/auth_token.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetAccessTokenUseCase getAccessTokenUseCase;
  final RefreshTokenUseCase refreshTokenUseCase;

  static const _splashDuration = Duration(seconds: 3);

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getAccessTokenUseCase,
    required this.refreshTokenUseCase,
  }) : super(AuthSplash()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthEvent>(_onCheckAuth);
    on<RefreshTokenEvent>(_onRefreshToken);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUseCase(event.email, event.password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (token) => emit(AuthAuthenticated(token)),
    );
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await registerUseCase(
      userName: event.userName,
      password: event.password,
      confirmPassword: event.confirmPassword,
      email: event.email,
      fullName: event.fullName,
      role: event.role,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await logoutUseCase();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onCheckAuth(
    CheckAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthSplash());
    final start = DateTime.now();
    final result = await getAccessTokenUseCase();
    final elapsed = DateTime.now().difference(start).inMilliseconds;
    final remaining = _splashDuration.inMilliseconds - elapsed;
    if (remaining > 0) {
      await Future.delayed(Duration(milliseconds: remaining));
    }
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (token) {
        if (token != null && token.isNotEmpty && !JwtDecoder.isExpired(token)) {
          emit(
            AuthAuthenticated(
              AuthToken(
                accessToken: token,
                refreshToken: '',
                expiresIn: 0,
                tokenType: 'Bearer',
              ),
            ),
          );
        } else {
          logoutUseCase();
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onRefreshToken(
    RefreshTokenEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await refreshTokenUseCase(event.refreshToken);
    result.fold(
      (failure) => emit(AuthUnauthenticated()),
      (token) => emit(AuthAuthenticated(token)),
    );
  }
}
