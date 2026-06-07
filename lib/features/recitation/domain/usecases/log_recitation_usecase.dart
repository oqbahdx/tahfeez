import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../enums/recitation_type.dart';
import '../repositories/recitation_repository.dart';

class LogRecitationUseCase {
  final RecitationRepository repository;

  LogRecitationUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String studentId,
    required String teacherId,
    required DateTime date,
    required int ayahsCount,
    required RecitationType type,
    required int grade,
    String? notes,
  }) {
    return repository.logRecitation(
      studentId: studentId,
      teacherId: teacherId,
      date: date,
      ayahsCount: ayahsCount,
      type: type,
      grade: grade,
      notes: notes,
    );
  }
}
