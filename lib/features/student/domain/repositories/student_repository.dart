import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user.dart';

abstract class StudentRepository {
  Future<Either<Failure, List<User>>> getStudents();
  Future<Either<Failure, User>> activateStudent(String studentId);
  Future<Either<Failure, void>> assignStudentToClass({
    required String studentId,
    required String classId,
    required String level,
  });
}
