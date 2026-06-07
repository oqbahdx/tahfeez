import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/attendance_repository.dart';

class RecordAttendanceUseCase {
  final AttendanceRepository repository;

  RecordAttendanceUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String userId,
    required DateTime date,
    required int status,
    String? notes,
  }) {
    return repository.recordAttendance(
      userId,
      date,
      status,
      notes,
    );
  }
}
