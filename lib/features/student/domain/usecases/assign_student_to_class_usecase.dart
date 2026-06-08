import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/student_repository.dart';

class AssignStudentToClassUseCase {
  final StudentRepository repository;

  AssignStudentToClassUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String studentId,
    required String classId,
    required String level,
  }) {
    return repository.assignStudentToClass(
      studentId: studentId,
      classId: classId,
      level: level,
    );
  }
}
