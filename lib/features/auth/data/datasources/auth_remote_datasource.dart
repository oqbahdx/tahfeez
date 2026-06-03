import 'dart:convert';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/auth_token_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokenModel> login(String username, String password);
  Future<AuthTokenModel> refreshToken(String refreshToken);
  Future<String?> getAccessToken();
  Future<UserModel> register({
    required String userName,
    required String password,
    required String confirmPassword,
    required String email,
    required String fullName,
    required int role,
  });
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl(this.apiClient);

  // Normalise Dio response data to a Map regardless of how it was decoded.
  Map<String, dynamic> _toMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is String && data.isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) return decoded;
      } catch (_) {}
    }
    return {};
  }

  // Extract a human-readable message from an OAuth2 / app error body.
  String _extractError(Map<String, dynamic> body) {
    return body['error_description'] as String? ??
        body['message'] as String? ??
        (body['errorsList'] is List && (body['errorsList'] as List).isNotEmpty
            ? (body['errorsList'] as List).first.toString()
            : null) ??
        body['error'] as String? ??
        'Authentication failed';
  }

  @override
  Future<AuthTokenModel> login(String username, String password) async {
    print('📤 [LOGIN] Calling API: ${ApiConstants.authEndpoint}');

    final response = await apiClient.postRaw(
      ApiConstants.authEndpoint,
      data: {
        'grant_type': 'password',
        'username': username,
        'password': password,
        'client_id': 'tahfeez-web-app',
        'client_secret': 'secret',
        // 'scope': 'offline_access openid profile email roles',
      },
      isFormUrlEncoded: true,
    );

    final body = _toMap(response.data);
    print('📥 [LOGIN] status=${response.statusCode} body=$body');

    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      final token = AuthTokenModel.fromJson(body);
      await apiClient.setTokens(token.accessToken, token.refreshToken);
      return token;
    }

    // 400 invalid_grant or any other error
    throw AuthException(message: _extractError(body));
  }

  @override
  Future<AuthTokenModel> refreshToken(String refreshToken) async {
    print('📤 [REFRESH] Calling API: ${ApiConstants.authEndpoint}');

    final response = await apiClient.postRaw(
      ApiConstants.authEndpoint,
      data: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
      },
      isFormUrlEncoded: true,
    );

    final body = _toMap(response.data);
    print('📥 [REFRESH] status=${response.statusCode} body=$body');

    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      final token = AuthTokenModel.fromJson(body);
      await apiClient.setTokens(token.accessToken, token.refreshToken);
      return token;
    }

    throw AuthException(message: _extractError(body));
  }

  @override
  Future<UserModel> register({
    required String userName,
    required String password,
    required String confirmPassword,
    required String email,
    required String fullName,
    required int role,
  }) async {
    try {
      print('📤 [REGISTER] Calling API: ${ApiConstants.registerEndpoint}');
      await apiClient.post(
        ApiConstants.registerEndpoint,
        data: {
          'userName': userName,
          'password': password,
          'confirmPassword': confirmPassword,
          'email': email,
          'fullName': fullName,
          'role': role,
        },
      );

      print('✅ [REGISTER] Success');
      return UserModel(id: '', email: email, userName: userName);
    } catch (e) {
      print('❌ [REGISTER] Error: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await apiClient.clearTokens();
  }

  @override
  Future<String?> getAccessToken() async {
    return apiClient.getAccessToken();
  }
}
