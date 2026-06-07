import 'package:equatable/equatable.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object?> get props => [];
}

class FetchAttendanceByDate extends AttendanceEvent {
  final DateTime date;
  final String classId;

  const FetchAttendanceByDate({
    required this.date,
    required this.classId,
  });

  @override
  List<Object?> get props => [date, classId];
}

class FetchAttendanceHistory extends AttendanceEvent {
  final String userId;

  const FetchAttendanceHistory(this.userId);

  @override
  List<Object?> get props => [userId];
}

class FetchAttendanceReport extends AttendanceEvent {
  final String classId;
  final DateTime from;
  final DateTime to;

  const FetchAttendanceReport({
    required this.classId,
    required this.from,
    required this.to,
  });

  @override
  List<Object?> get props => [classId, from, to];
}

class RecordAttendanceEvent extends AttendanceEvent {
  final List<Map<String, dynamic>> records;

  const RecordAttendanceEvent(this.records);

  @override
  List<Object?> get props => [records];
}

class UpdateAttendanceEvent extends AttendanceEvent {
  final String attendanceId;
  final int status;
  final String? notes;

  const UpdateAttendanceEvent({
    required this.attendanceId,
    required this.status,
    this.notes,
  });

  @override
  List<Object?> get props => [attendanceId, status, notes];
}

class RefreshAttendance extends AttendanceEvent {
  const RefreshAttendance();
}

class ClearAttendance extends AttendanceEvent {
  const ClearAttendance();
}
