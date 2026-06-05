import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/recitation_model.dart';

abstract class RecitationRemoteDataSource {
  Future<String> logRecitation({
    required String studentId,
    required String teacherId,
    required String date,
    required int ayahsCount,
    required int type,
    required int grade,
    String? notes,
  });

  Future<List<RecitationModel>> getRecitationsByStudent(String studentId);

  Future<List<RecitationModel>> getRecitationsByClass({
    required String classId,
    String? month,
  });
}

class RecitationRemoteDataSourceImpl implements RecitationRemoteDataSource {
  final ApiClient apiClient;

  RecitationRemoteDataSourceImpl(this.apiClient);

  @override
  Future<String> logRecitation({
    required String studentId,
    required String teacherId,
    required String date,
    required int ayahsCount,
    required int type,
    required int grade,
    String? notes,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.recitationsEndpoint,
        data: {
          'studentId': studentId,
          'teacherId': teacherId,
          'date': date,
          'ayahsCount': ayahsCount,
          'type': type,
          'grade': grade,
          if (notes != null && notes.isNotEmpty) 'notes': notes,
        },
      );
      final id = response['value'];
      if (id == null || id is! String) {
        throw ServerException(message: 'Invalid response: missing recitation ID');
      }
      return id;
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<RecitationModel>> getRecitationsByStudent(String studentId) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.recitationsEndpoint}/student/$studentId',
      );
      final raw = response['value'];
      if (raw == null || raw is! List) return [];
      return raw
          .whereType<Map<String, dynamic>>()
          .map((e) => RecitationModel.fromJson(e))
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
  Future<List<RecitationModel>> getRecitationsByClass({
    required String classId,
    String? month,
  }) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.recitationsEndpoint}/class/$classId',
        queryParameters: month != null ? {'month': month} : null,
      );
      final raw = response['value'];
      if (raw == null || raw is! List) return [];
      return raw
          .whereType<Map<String, dynamic>>()
          .map((e) => RecitationModel.fromJson(e))
          .toList();
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
