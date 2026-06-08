import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/auth/auth_service.dart';
import '../../../../core/di/injection_container.dart' as di;
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
  static const _rolePrefsKey = 'user_role';

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

  Map<String, dynamic>? _decodePayload(String token) {
    try {
      return JwtDecoder.decode(token);
    } catch (_) {
      return null;
    }
  }

  String? _extractRole(Map<String, dynamic> claims) {
    return claims['role'] as String?;
  }

  String? _extractUserName(Map<String, dynamic> claims) {
    return claims['name'] as String?;
  }

  Future<void> _persistSession(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_rolePrefsKey, role);
    di.sl<AuthService>().setRole(role);
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rolePrefsKey);
    di.sl<AuthService>().clear();
  }

  AuthAuthenticated _buildAuthenticatedState(AuthToken token) {
    final claims = _decodePayload(token.accessToken) ?? {};
    final role = _extractRole(claims) ?? '';
    final userName = _extractUserName(claims);
    return AuthAuthenticated(
      token,
      role: role,
      userName: userName,
    );
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUseCase(event.email, event.password);
    await result.fold(
      (failure) async => emit(AuthError(failure.message)),
      (token) async {
        final state = _buildAuthenticatedState(token);
        await _persistSession(state.role);
        emit(state);
      },
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
    await _clearSession();
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
    await result.fold(
      (failure) async => emit(AuthUnauthenticated()),
      (token) async {
        if (token != null && token.isNotEmpty && !JwtDecoder.isExpired(token)) {
          final authToken = AuthToken(
            accessToken: token,
            refreshToken: '',
            expiresIn: 0,
            tokenType: 'Bearer',
          );
          final state = _buildAuthenticatedState(authToken);
          if (state.role.isNotEmpty) {
            await _persistSession(state.role);
          }
          emit(state);
        } else {
          await _clearSession();
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
    await result.fold(
      (failure) async {
        await _clearSession();
        emit(AuthUnauthenticated());
      },
      (token) async {
        final authState = _buildAuthenticatedState(token);
        if (authState.role.isNotEmpty) {
          await _persistSession(authState.role);
        }
        emit(authState);
      },
    );
  }
}
