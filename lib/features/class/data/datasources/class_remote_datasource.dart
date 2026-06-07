import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/class_model.dart';
import '../../../auth/data/models/user_model.dart';

abstract class ClassRemoteDataSource {
  Future<List<ClassModel>> getAllClasses();
  Future<ClassModel> getClassById(String id);
  Future<List<UserModel>> getClassStudents(String classId);
  Future<String> createClass({
    required String name,
    required int type,
    required int mode,
    String? teacherId,
    String? assistantId,
    String? supervisorId,
  });
  Future<ClassModel> updateClass({
    required String id,
    required String name,
    required int type,
    required int mode,
  });
  Future<void> deleteClass(String id);
  Future<ClassModel> assignStaff({
    required String classId,
    String? teacherId,
    String? assistantId,
    String? supervisorId,
  });
  Future<List<UserModel>> getUsersByRole(int role);
}

class ClassRemoteDataSourceImpl implements ClassRemoteDataSource {
  final ApiClient apiClient;

  ClassRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<ClassModel>> getAllClasses() async {
    try {
      final response = await apiClient.get(ApiConstants.classesEndpoint);
      final raw = response['value'];
      if (raw == null || raw is! List) return [];
      return raw
          .whereType<Map<String, dynamic>>()
          .map((e) => ClassModel.fromJson(e))
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
  Future<ClassModel> getClassById(String id) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.classesEndpoint}/$id',
      );
      return ClassModel.fromJson(response);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<UserModel>> getClassStudents(String classId) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.classesEndpoint}/$classId/students',
      );
      return (response as List).map((e) => UserModel.fromJson(e)).toList();
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> createClass({
    required String name,
    required int type,
    required int mode,
    String? teacherId,
    String? assistantId,
    String? supervisorId,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.classesEndpoint,
        data: {
          'name': name,
          'type': type,
          'mode': mode,
          'teacherId': teacherId,
          'assistantId': assistantId,
          'supervisorId': supervisorId,
        },
      );
      final id = response['value'];
      if (id == null || id is! String) {
        throw ServerException(message: 'Invalid response: missing class ID');
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
  Future<ClassModel> updateClass({
    required String id,
    required String name,
    required int type,
    required int mode,
  }) async {
    try {
      final response = await apiClient.put(
        '${ApiConstants.classesEndpoint}/$id',
        data: {'name': name, 'type': type, 'mode': mode},
      );
      return ClassModel.fromJson(response);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteClass(String id) async {
    try {
      await apiClient.delete('${ApiConstants.classesEndpoint}/$id');
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<ClassModel> assignStaff({
    required String classId,
    String? teacherId,
    String? assistantId,
    String? supervisorId,
  }) async {
    try {
      final response = await apiClient.put(
        '${ApiConstants.classesEndpoint}/$classId/staff',
        data: {
          'teacherId': teacherId,
          'assistantId': assistantId,
          'supervisorId': supervisorId,
        },
      );
      return ClassModel.fromJson(response);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<UserModel>> getUsersByRole(int role) async {
    try {
      final response = await apiClient.get(
        ApiConstants.usersEndpoint,
        queryParameters: {'role': role},
      );
      final raw = response['value'];
      if (raw == null || raw is! List) return [];
      return raw
          .whereType<Map<String, dynamic>>()
          .map((e) => UserModel.fromJson(e))
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
