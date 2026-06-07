import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/attendance_repository.dart';

class UpdateAttendanceUseCase {
  final AttendanceRepository repository;

  UpdateAttendanceUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String attendanceId,
    required int status,
    String? notes,
  }) {
    return repository.updateAttendance(
      attendanceId,
      status,
      notes,
    );
  }
}
