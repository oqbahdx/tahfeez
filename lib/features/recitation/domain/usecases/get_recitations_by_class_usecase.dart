import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/recitation.dart';
import '../repositories/recitation_repository.dart';

class GetRecitationsByClassUseCase {
  final RecitationRepository repository;

  GetRecitationsByClassUseCase(this.repository);

  Future<Either<Failure, List<Recitation>>> call({
    required String classId,
    String? month,
  }) {
    return repository.getRecitationsByClass(
      classId: classId,
      month: month,
    );
  }
}
