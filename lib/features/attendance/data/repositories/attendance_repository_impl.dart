import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/enums/attendance_status.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_remote_datasource.dart';
import '../models/record_attendance_request.dart';
import '../models/update_attendance_request.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource remoteDataSource;

  AttendanceRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Attendance>>> getAttendanceByDate(
    DateTime date,
  ) async {
    try {
      final result = await remoteDataSource.getByDate(date);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Attendance>>> getAttendanceByUser(
    String userId,
  ) async {
    try {
      final result = await remoteDataSource.getByUser(userId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Attendance>>> getAttendanceReport({
    required String classId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final result = await remoteDataSource.getReport(
        classId: classId,
        from: from,
        to: to,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> recordAttendance(
    String userId,
    DateTime date,
    int status,
    String? notes,
  ) async {
    try {
      final request = RecordAttendanceRequest(
        userId: userId,
        date: date,
        status: AttendanceStatus.fromApi(status),
        notes: notes,
      );
      await remoteDataSource.recordAttendance(request);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateAttendance(
    String attendanceId,
    int status,
    String? notes,
  ) async {
    try {
      final request = UpdateAttendanceRequest(
        status: AttendanceStatus.fromApi(status),
        notes: notes,
      );
      await remoteDataSource.updateAttendance(attendanceId, request);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }
}
