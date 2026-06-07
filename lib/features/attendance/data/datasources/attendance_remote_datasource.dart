import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/attendance_dto.dart';
import '../models/record_attendance_request.dart';
import '../models/update_attendance_request.dart';

abstract class AttendanceRemoteDataSource {
  Future<List<AttendanceDto>> getByDate(DateTime date);

  Future<List<AttendanceDto>> getByUser(String userId);

  Future<List<AttendanceDto>> getReport({
    required String classId,
    required DateTime from,
    required DateTime to,
  });

  Future<void> recordAttendance(RecordAttendanceRequest request);

  Future<void> updateAttendance(
    String attendanceId,
    UpdateAttendanceRequest request,
  );
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final ApiClient apiClient;

  AttendanceRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<AttendanceDto>> getByDate(DateTime date) async {
    try {
      final formatted = AttendanceDto.formatDate(date);
      final response = await apiClient.get(
        '${ApiConstants.attendanceEndpoint}/date/$formatted',
      );
      final raw = response['value'];
      if (raw == null || raw is! List) return [];
      return raw
          .whereType<Map<String, dynamic>>()
          .map((e) => AttendanceDto.fromJson(e))
          .toList();
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<AttendanceDto>> getByUser(String userId) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.attendanceEndpoint}/user/$userId',
      );
      final raw = response['value'];
      if (raw == null || raw is! List) return [];
      return raw
          .whereType<Map<String, dynamic>>()
          .map((e) => AttendanceDto.fromJson(e))
          .toList();
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<AttendanceDto>> getReport({
    required String classId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.attendanceEndpoint}/report',
        queryParameters: {
          'classId': classId,
          'from': AttendanceDto.formatDate(from),
          'to': AttendanceDto.formatDate(to),
        },
      );
      final raw = response['value'];
      if (raw == null || raw is! List) return [];
      return raw
          .whereType<Map<String, dynamic>>()
          .map((e) => AttendanceDto.fromJson(e))
          .toList();
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> recordAttendance(RecordAttendanceRequest request) async {
    try {
      await apiClient.post(
        ApiConstants.attendanceEndpoint,
        data: request.toJson(),
      );
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateAttendance(
    String attendanceId,
    UpdateAttendanceRequest request,
  ) async {
    try {
      await apiClient.put(
        '${ApiConstants.attendanceEndpoint}/$attendanceId',
        data: request.toJson(),
      );
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
