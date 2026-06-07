import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/recitation.dart';
import '../repositories/recitation_repository.dart';

class GetRecitationsByStudentUseCase {
  final RecitationRepository repository;

  GetRecitationsByStudentUseCase(this.repository);

  Future<Either<Failure, List<Recitation>>> call(String studentId) {
    return repository.getRecitationsByStudent(studentId);
  }
}
