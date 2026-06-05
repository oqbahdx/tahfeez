import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user.dart';
import '../repositories/student_repository.dart';

class ActivateStudentUseCase {
  final StudentRepository repository;

  ActivateStudentUseCase(this.repository);

  Future<Either<Failure, User>> call(String studentId) {
    return repository.activateStudent(studentId);
  }
}
