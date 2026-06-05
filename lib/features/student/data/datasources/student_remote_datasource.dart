import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/domain/enums/user_role.dart';

abstract class StudentRemoteDataSource {
  Future<List<UserModel>> getStudents();
  Future<UserModel> activateStudent(String studentId);
}

class StudentRemoteDataSourceImpl implements StudentRemoteDataSource {
  final ApiClient apiClient;

  StudentRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<UserModel>> getStudents() async {
    try {
      final response = await apiClient.get(
        ApiConstants.usersEndpoint,
        queryParameters: {'role': UserRole.student.value},
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

  @override
  Future<UserModel> activateStudent(String studentId) async {
    try {
      final response = await apiClient.post(
        '${ApiConstants.studentsEndpoint}/$studentId/activate',
      );
      final raw = response['value'];
      if (raw == null || raw is! Map<String, dynamic>) {
        throw ServerException(message: 'Invalid response from server');
      }
      return UserModel.fromJson(raw);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
