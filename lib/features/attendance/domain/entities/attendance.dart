import 'package:equatable/equatable.dart';
import '../enums/attendance_status.dart';

class Attendance extends Equatable {
  final String id;
  final String userId;
  final String? userName;
  final DateTime date;
  final AttendanceStatus status;
  final String? notes;

  const Attendance({
    required this.id,
    required this.userId,
    this.userName,
    required this.date,
    required this.status,
    this.notes,
  });

  @override
  List<Object?> get props => [id, userId, userName, date, status, notes];
}
