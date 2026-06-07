import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

class GetAttendanceByDateUseCase {
  final AttendanceRepository repository;

  GetAttendanceByDateUseCase(this.repository);

  Future<Either<Failure, List<Attendance>>> call(DateTime date) {
    return repository.getAttendanceByDate(date);
  }
}
