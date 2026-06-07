import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, List<Attendance>>> getAttendanceByDate(DateTime date);

  Future<Either<Failure, List<Attendance>>> getAttendanceByUser(String userId);

  Future<Either<Failure, List<Attendance>>> getAttendanceReport({
    required String classId,
    required DateTime from,
    required DateTime to,
  });

  Future<Either<Failure, void>> recordAttendance(
    String userId,
    DateTime date,
    int status,
    String? notes,
  );

  Future<Either<Failure, void>> updateAttendance(
    String attendanceId,
    int status,
    String? notes,
  );
}
