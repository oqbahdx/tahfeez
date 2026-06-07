import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/recitation.dart';
import '../enums/recitation_type.dart';

abstract class RecitationRepository {
  Future<Either<Failure, String>> logRecitation({
    required String studentId,
    required String teacherId,
    required DateTime date,
    required int ayahsCount,
    required RecitationType type,
    required int grade,
    String? notes,
  });

  Future<Either<Failure, List<Recitation>>> getRecitationsByStudent(
    String studentId,
  );

  Future<Either<Failure, List<Recitation>>> getRecitationsByClass({
    required String classId,
    String? month,
  });
}
