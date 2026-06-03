import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../features/auth/data/models/auth_token_model.dart';
import '../constants/api_constants.dart';
import '../error/exceptions.dart';

class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  ApiClient(this._dio, this._secureStorage) {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        compact: true,
        // Only log in debug mode
        enabled: kDebugMode,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          // Only set JSON as default if the request hasn't already specified
          // a content type (e.g. login uses application/x-www-form-urlencoded).
          options.headers.putIfAbsent('Content-Type', () => 'application/json');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) async {

          if (error.response?.statusCode == 401) {
            final refreshed = await _refreshToken();
            if (refreshed) {
              final token = await getAccessToken();
              error.requestOptions.headers['Authorization'] = 'Bearer $token';
              final response = await _dio.fetch(error.requestOptions);
              return handler.resolve(response);
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<String?> getAccessToken() async {
    return _secureStorage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return _secureStorage.read(key: _refreshTokenKey);
  }

  Future<void> setTokens(String accessToken, String refreshToken) async {
    await _secureStorage.write(key: _accessTokenKey, value: accessToken);
    await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<void> clearTokens() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
  }

  Future<bool> _refreshToken() async {
    final refreshToken = await _secureStorage.read(key: _refreshTokenKey);
    if (refreshToken == null) return false;

    try {
      final response = await _dio.post(
        ApiConstants.authEndpoint,
        data: {
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
        },
        options: Options(contentType: 'application/x-www-form-urlencoded'),
      );

      final token = AuthTokenModel.fromJson(response.data as Map<String, dynamic>);
      await setTokens(token.accessToken, token.refreshToken);
      return true;
    } catch (e) {
      await clearTokens();
      return false;
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool isFormUrlEncoded = false,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: isFormUrlEncoded ? data : (data ?? {}),
        queryParameters: queryParameters,
        options: isFormUrlEncoded
            ? Options(contentType: 'application/x-www-form-urlencoded')
            : null,
      );
      // 201/204 responses often have an empty body — return empty map
      if (response.data == null || response.data == '') {
        return {};
      }
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Like [post] but accepts any status code — caller is responsible for
  /// checking [Response.statusCode] and handling errors.
  Future<Response<dynamic>> postRaw(
    String path, {
    Map<String, dynamic>? data,
    bool isFormUrlEncoded = false,
  }) async {
    return _dio.post(
      path,
      data: data,
      options: Options(
        contentType: isFormUrlEncoded
            ? 'application/x-www-form-urlencoded'
            : 'application/json',
        validateStatus: (_) => true, // never throw — let caller decide
      ),
    );
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.put(path, data: data ?? {});
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> delete(String path) async {
    try {
      await _dio.delete(path);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return NetworkException(message: 'Connection timeout');
    }

    if (e.type == DioExceptionType.connectionError) {
      return NetworkException(message: 'No internet connection');
    }

    final statusCode = e.response?.statusCode;
    final rawData = e.response?.data;

    debugPrint('🔍 [ERROR HANDLER] statusCode=$statusCode, dataType=${rawData.runtimeType}, data=$rawData');

    // Normalise response body to a Map regardless of how Dio decoded it
    Map<String, dynamic>? body;
    if (rawData is Map<String, dynamic>) {
      body = rawData;
    } else if (rawData is String && rawData.isNotEmpty) {
      final decoded = _tryDecodeJson(rawData);
      if (decoded is Map<String, dynamic>) body = decoded;
    }

    if (body != null) {
      // OpenIddict / OAuth2 error: { "error": "invalid_grant", "error_description": "..." }
      final errorDescription = body['error_description'] as String?;
      final errorCode = body['error'] as String?;

      if (errorDescription != null && errorDescription.isNotEmpty) {
        if (statusCode == 400 || errorCode == 'invalid_grant') {
          return AuthException(message: errorDescription);
        }
        return ServerException(message: errorDescription, statusCode: statusCode);
      }

      // Fallback: message / errorsList fields used by the app's own API
      final message = body['message'] as String? ??
          (body['errorsList'] is List && (body['errorsList'] as List).isNotEmpty
              ? (body['errorsList'] as List).first.toString()
              : null) ??
          errorCode ??
          'Server error';

      if (statusCode == 401) return AuthException(message: message);
      return ServerException(message: message, statusCode: statusCode);
    }

    if (statusCode == 401) return AuthException(message: 'Unauthorized');
    if (statusCode == 400) return AuthException(message: 'Invalid credentials');

    return ServerException(message: 'Server error', statusCode: statusCode);
  }

  /// Safely decode a JSON string — returns null on failure.
  dynamic _tryDecodeJson(String source) {
    try {
      return jsonDecode(source);
    } catch (_) {
      return null;
    }
  }
}
