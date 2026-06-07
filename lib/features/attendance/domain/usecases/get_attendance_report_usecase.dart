import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

class GetAttendanceReportUseCase {
  final AttendanceRepository repository;

  GetAttendanceReportUseCase(this.repository);

  Future<Either<Failure, List<Attendance>>> call({
    required String classId,
    required DateTime from,
    required DateTime to,
  }) {
    return repository.getAttendanceReport(classId: classId, from: from, to: to);
  }
}
