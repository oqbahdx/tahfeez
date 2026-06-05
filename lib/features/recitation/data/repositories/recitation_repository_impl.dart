import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/recitation.dart';
import '../../domain/enums/recitation_type.dart';
import '../../domain/repositories/recitation_repository.dart';
import '../datasources/recitation_remote_datasource.dart';
import '../models/recitation_model.dart';

class RecitationRepositoryImpl implements RecitationRepository {
  final RecitationRemoteDataSource remoteDataSource;

  RecitationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> logRecitation({
    required String studentId,
    required String teacherId,
    required DateTime date,
    required int ayahsCount,
    required RecitationType type,
    required int grade,
    String? notes,
  }) async {
    try {
      final result = await remoteDataSource.logRecitation(
        studentId: studentId,
        teacherId: teacherId,
        date: RecitationModel.formatDate(date),
        ayahsCount: ayahsCount,
        type: type.value,
        grade: grade,
        notes: notes,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Recitation>>> getRecitationsByStudent(
    String studentId,
  ) async {
    try {
      final result = await remoteDataSource.getRecitationsByStudent(studentId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Recitation>>> getRecitationsByClass({
    required String classId,
    String? month,
  }) async {
    try {
      final result = await remoteDataSource.getRecitationsByClass(
        classId: classId,
        month: month,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }
}
