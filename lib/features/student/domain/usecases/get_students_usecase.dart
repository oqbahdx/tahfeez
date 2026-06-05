import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user.dart';
import '../repositories/student_repository.dart';

class GetStudentsUseCase {
  final StudentRepository repository;

  GetStudentsUseCase(this.repository);

  Future<Either<Failure, List<User>>> call() {
    return repository.getStudents();
  }
}
